//
//  GraffleBezierFactory.m
//  GraffleReader
//
//  Created by Carsten Müller on 19/01/2009.
//  Copyright 2009 T42 Networking. All rights reserved.
//

#import "GraffleBezierFactory.h"
#import "GraffleDocument.h"
#import "BezierDrawView.h"
#import "SimpleBezier.h"

// functions
NSPoint scalePointBySize(NSPoint p, NSSize s)
{ 
  NSPoint result = p;
  result.x*=s.width;
  result.y*=s.height;
  return result;
}

NSPoint shiftPointByPoint(NSPoint p, NSPoint o)
{
  NSPoint result = p;
  result.x += o.x;
  result.y += o.y;
  return result;
}

NSPoint unflipPointForRect(NSPoint p, NSRect b)
{
  NSPoint result = p;
  result.y = (b.origin.y + b.size.height) - p.y;
  return result;
}

NSRect unflipRectForRect(NSRect p, NSRect b)
{
  NSRect result = NSZeroRect;
  result.origin.x = p.origin.x;
  result.origin.y = b.size.height -(p.origin.y + p.size.height) ;
//  result.origin.y -= p.size.height ;
  result.size = p.size;
  return result;
}

@interface GraffleBezierFactory (ShapeConverter)
- (NSDictionary*) Rectangle:(NSDictionary*)dict;
- (NSDictionary*) Bezier:(NSDictionary*)dict;
- (NSDictionary*) Line:(NSDictionary*)dict;
@end

@interface GraffleBezierFactory (StyleConverter)
- (NSColor*) colorFromDescription:(NSDictionary*)colorDescription;
- (NSDictionary*) styleDescriptionFromShapeDescription:(NSDictionary*)shapeDescription;
@end

@implementation GraffleBezierFactory
@synthesize graffleDocument = _graffleDocument;

- (id) initWithDocument:(GraffleDocument*) document
{
  if(self = [super init]){
    self.graffleDocument = document;
  }
  return self;
}

- (NSDictionary*) exportedShapeNamed:(NSString*)shapeName withDescription:(NSDictionary*)shapeDescription
{
  NSRect bounds = NSRectFromString([shapeDescription valueForKey:@"Bounds"]);
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  // search the shape
  NSDictionary *item = nil;
  NSArray *exportedShapes = [self.graffleDocument valueForKey:@"ExportShapes"];
  NSDictionary *shape;
  for(shape in exportedShapes){
    if([[shape valueForKey:@"ShapeName"] isEqualToString:shapeName]){
      item = shape;
      break;
    }
  }
  
  if(item){
    if([[shapeDescription objectForKey:@"HFlip"]boolValue]){
      NSLog(@"Flipping %@",shapeDescription);
    }
    NSBezierPath *bp = [[NSBezierPath new] autorelease];
    NSRect docBounds = [self.graffleDocument bounds];
    NSArray *elements = [item valueForKeyPath:@"StrokePath.elements"];
//    NSLog(@"Elements: %@",elements);
    NSDictionary *element ;
    NSPoint offset = NSMakePoint(bounds.origin.x+bounds.size.width/2.0,bounds.origin.y+bounds.size.height/2.0);
    for(element in elements){
      NSString* elementType = [element valueForKey:@"element"];
      if([elementType isEqualToString:@"MOVETO"]){
        NSPoint p = NSPointFromString([element valueForKey:@"point"]);
        p = scalePointBySize(p, bounds.size);
        p = shiftPointByPoint(p, offset);
        p = unflipPointForRect(p, docBounds);
        [bp moveToPoint:p];
      }else if([elementType isEqualToString:@"CURVETO"]){
        NSPoint p = NSPointFromString([element valueForKey:@"point"]);
        NSPoint c1 = NSPointFromString([element valueForKey:@"control1"]); 
        NSPoint c2= NSPointFromString([element valueForKey:@"control2"]); 
        p = scalePointBySize(p, bounds.size);
        p = shiftPointByPoint(p, offset);
        p = unflipPointForRect(p, docBounds);
        c1 = scalePointBySize(c1, bounds.size);
        c1 = shiftPointByPoint(c1, offset);
        c1 = unflipPointForRect(c1, docBounds);
        c2 = scalePointBySize(c2, bounds.size);
        c2 = shiftPointByPoint(c2, offset);
        c2 = unflipPointForRect(c2, docBounds);
        [bp curveToPoint:p controlPoint1:c1 controlPoint2:c2];
      }else if([elementType isEqualToString:@"LINETO"]){
        NSPoint p = NSPointFromString([element valueForKey:@"point"]);
        p = scalePointBySize(p, bounds.size);
        p = shiftPointByPoint(p, offset);
        p = unflipPointForRect(p, docBounds);
        [bp lineToPoint:p];
        NSLog(@"LineTo :%@",NSStringFromPoint(p));
      }else if([elementType isEqualToString:@"CLOSE"]){
        [bp closePath];
      }else{
        NSLog(@"Unsuported element");
      }
    }
    [result setValue:bp forKey:kBezierPathKey];
  }
  NSDictionary *style = [self styleDescriptionFromShapeDescription:shapeDescription];
  [result addEntriesFromDictionary:style];
  return result;
}

- (SimpleBezier*) bezierPathForComponentAtIndex:(NSUInteger)index
{
  NSDictionary *result = nil;
  if(!self.graffleDocument)
    return nil;
  // retrieve the shape description
  NSArray *gl= [self.graffleDocument.graffleData objectForKey:@"GraphicsList"];
  NSDictionary* shapeDescription = [gl objectAtIndex:index];
  // determine Class
  NSString * className = [shapeDescription objectForKey:@"Class"];
  if([className isEqualToString:@"ShapedGraphic"]){
    NSString *type = [shapeDescription objectForKey:@"Shape"];
    NSString* selectorString = [type stringByAppendingString:@":"];
    SEL typeSelector = NSSelectorFromString(selectorString);
    if([self respondsToSelector:typeSelector]){
      result = [self performSelector:typeSelector withObject:shapeDescription];
    }else{
      result = [self exportedShapeNamed:type withDescription:shapeDescription];
//      NSLog(@"unsupport Shape: %@",type);
    }
  } else if([className isEqualToString:@"LineGraphic"]){
	  result = [self Line:shapeDescription];
	  
  }else{
    NSLog(@"Unsupported Class: %@",className);
  }
  SimpleBezier * bezier = [[[SimpleBezier alloc] initWithBezierDescription:result]autorelease];
  return bezier;
}


@end

@implementation GraffleBezierFactory (ShapeConverter)

- (NSDictionary*) Rectangle:(NSDictionary*) shapeDescription
{
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  NSRect docBounds = [self.graffleDocument bounds];
  NSRect bounds = NSRectFromString([shapeDescription objectForKey:@"Bounds"]);
  bounds = unflipRectForRect(bounds, docBounds);
  NSBezierPath *bp = [NSBezierPath bezierPathWithRect:bounds];
  [result setObject:bp forKey:kBezierPathKey];
  NSDictionary *style = [self styleDescriptionFromShapeDescription:shapeDescription];
  [result addEntriesFromDictionary:style];
  return result;
}


- (NSDictionary*) Bezier:(NSDictionary*) shapeDescription
{
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  NSArray *points = [[shapeDescription objectForKey:@"ShapeData"] objectForKey:@"UnitPoints"];
//  NSLog(@"PointsInPath: %d",[points count]);
  NSBezierPath *bp = [NSBezierPath bezierPath];
  NSRect bounds = NSRectFromString([shapeDescription objectForKey:@"Bounds"]);
  NSRect docBounds = [self.graffleDocument bounds];

  NSPoint starter[3]; 
  NSPoint p1,p2,p3;
  NSPoint offset = NSMakePoint(bounds.origin.x+bounds.size.width/2.0,bounds.origin.y+bounds.size.height/2.0);
  for(int i=[points count]-3;i>=0;i-=3){
    p1 = NSPointFromString([points objectAtIndex:i+0]);
    p2 = NSPointFromString([points objectAtIndex:i+1]);
    p3 = NSPointFromString([points objectAtIndex:i+2]);

    // scale boundingbox
    p1 = scalePointBySize(p1, bounds.size);
    p2 = scalePointBySize(p2, bounds.size);
    p3 = scalePointBySize(p3, bounds.size);

    // shift to final position
    p1 = shiftPointByPoint(p1, offset);
    p2 = shiftPointByPoint(p2, offset);
    p3 = shiftPointByPoint(p3, offset);

    p1 = unflipPointForRect(p1, docBounds);
    p2 = unflipPointForRect(p2, docBounds);
    p3 = unflipPointForRect(p3, docBounds);
    if(i==[points count]-3){
      [bp moveToPoint:p1];
      starter[0]=p1;
      starter[1]=p2;
      starter[2]=p3;
      continue;
    }
    
    //    [bp lineToPoint:p1];
    [bp curveToPoint:p1 controlPoint1:p3 controlPoint2:p2];
  }
  [bp curveToPoint:starter[0] controlPoint1:starter[2] controlPoint2:starter[1]];
//  [bp closePath];
  if([[shapeDescription objectForKey:@"HFlip"] boolValue]){
    NSLog(@"Flipping: %@",shapeDescription);
  }
  [result setObject:bp forKey:kBezierPathKey];
  NSDictionary *style = [self styleDescriptionFromShapeDescription:shapeDescription];
  [result addEntriesFromDictionary:style];
  
  return result;
}

- (NSDictionary*) Circle:(NSDictionary*) shapeDescription
{
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  NSRect docBounds = [self.graffleDocument bounds];
  NSRect circleBounds = NSRectFromString([shapeDescription objectForKey:@"Bounds"]);
  circleBounds = unflipRectForRect(circleBounds, docBounds);
  NSBezierPath *bp = [NSBezierPath bezierPathWithOvalInRect:circleBounds];
  [result setObject:bp forKey:kBezierPathKey];
  NSDictionary *style = [self styleDescriptionFromShapeDescription:shapeDescription];
  [result addEntriesFromDictionary:style];
  return result;
}

- (NSDictionary*) Line:(NSDictionary*) lineDescription {
			// NSLog(@"%@",[self className]);
	NSArray *points = [lineDescription objectForKey:@"Points"];
	BOOL firstRun = TRUE;
	NSBezierPath *bp = [[[NSBezierPath alloc] init] autorelease];
	for(NSString *p in points) {
		NSPoint mypoint = NSPointFromString(p);
		mypoint = unflipPointForRect(mypoint, [self.graffleDocument bounds]);
		if(firstRun) {
			NSLog(@"%@ %@   MOVETO %@",[self className],NSStringFromSelector(_cmd), p);
			[bp moveToPoint:mypoint];
			firstRun = FALSE;
		} else {
			NSLog(@"%@ %@   LINETO %@",[self className],NSStringFromSelector(_cmd), p);
			[bp lineToPoint:mypoint];
		};
	}
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:bp forKey:kBezierPathKey];
	NSDictionary *style = [self styleDescriptionFromShapeDescription:lineDescription];
	[dict addEntriesFromDictionary:style];
	
	return dict; //FIXME
}
@end

@implementation GraffleBezierFactory (StyleConverter)

- (NSColor*) colorFromDescription:(NSDictionary*) colorDescription
{
  float r=0.0, g=0.0, b=0.0, a=1.0;
  NSNumber *aNumber = nil;
  if(aNumber = [colorDescription objectForKey:@"r"])
    r = [aNumber floatValue];
  if(aNumber = [colorDescription objectForKey:@"g"])
    g = [aNumber floatValue];
  if(aNumber = [colorDescription objectForKey:@"b"])
    b = [aNumber floatValue];
  if(aNumber = [colorDescription objectForKey:@"a"])
    a = [aNumber floatValue];
  return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a];
}
- (NSDictionary*) styleDescriptionFromShapeDescription:(NSDictionary*)shapeDescription
{
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  NSDictionary * style = [shapeDescription objectForKey:@"Style"];
  NSDictionary *stroke = [style objectForKey:@"stroke"];
  if(stroke){
    NSNumber *drawFlag = [stroke objectForKey:@"Draws"];
    if(drawFlag && ![drawFlag boolValue]){
      NSLog(@"NoStroke");
    }else{
      NSDictionary *colorDict = [stroke objectForKey:@"Color"];
      [result setObject:[self colorFromDescription:colorDict] forKey:kStrokeColorKey];
    }
  }else{
    [result setObject:[NSColor blackColor] forKey:kStrokeColorKey];
  }
  NSDictionary *fill = [style objectForKey:@"fill"];
  if(fill){
    NSDictionary *colorDict = [fill objectForKey:@"Color"];
    [result setObject:[self colorFromDescription:colorDict] forKey:kFillColorKey];
  }
  return result;
} 

@end