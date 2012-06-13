//
//  SimpleBezier.m
//  GraffleReader
//
//  Created by Carsten Müller on 09/03/2009.
//  Copyright 2009 T42 Networking. All rights reserved.
//

#import "SimpleBezier.h"
#if !IPHONE
#import "GraffleBezierFactory.h" // BAD!!!
#endif

NSString *kStrokeColorKey = @"strokeColor";
NSString *kFillColorKey = @"fillColor";
NSString *kBezierPathKey = @"bezierPath";


@implementation SimpleBezier


@synthesize pathColor = _pathColor,fillColor = _fillColor, points = _points, path = _path;


- (void) initializeDefaults
{
  self.points = [NSMutableArray array];
#if IPHONE
  self.fillColor = nil;
  self.pathColor = [UIColor whiteColor];
#else
  self.fillColor = nil;
  self.pathColor = [NSColor whiteColor];
#endif
}
- (id) init
{
  if(self = [super init]){
    [self initializeDefaults];
  }
  return self;
}


- (void) dealloc
{
#if IPHONE
  CGPathRelease(self.path);
#endif
  self.path = nil;

  [super dealloc];
}

#if !IPHONE
- (void) createPointsArray
{
  NSMutableArray *newPoints = [NSMutableArray array];
  NSBezierPath * flatPath = [self.path bezierPathByFlatteningPath];
  unsigned int count = [flatPath elementCount];
  NSPoint l[10];
  for(unsigned int i = 0;i<count;i++){
    NSBezierPathElement element = [flatPath elementAtIndex:i associatedPoints:l];
    switch(element){
      case NSMoveToBezierPathElement:
      {
        [newPoints addObject:[NSValue valueWithPoint:l[0]]];
        break;
      }
      case NSCurveToBezierPathElement:
      case NSLineToBezierPathElement:
      {
          [newPoints addObject:[NSValue valueWithPoint:l[0]]];
        break;
      }
      case NSClosePathBezierPathElement:
      {
        [newPoints addObject:[newPoints objectAtIndex:0]];
        break;
      }
    }
//    NSLog(@"Element: %d",element);
  }
  self.points = newPoints;
}

- (id) initWithBezierDescription:(NSDictionary*) description
{
  self.fillColor = [description objectForKey:kFillColorKey];
  self.pathColor = [description objectForKey:kStrokeColorKey];
  self.path = [description objectForKey:kBezierPathKey];
  [self createPointsArray];
  return self;
}
#endif

- (CurrentColor_t) decodeColor:(NSString*) colorDescription
{
#if IPHONE
  CGRect p = CGRectFromString(colorDescription);
  return [UIColor colorWithRed:p.origin.x
                         green:p.origin.y
                          blue:p.size.width
                         alpha:p.size.height];
#else
  NSRect p = NSRectFromString(colorDescription);
  return [NSColor colorWithDeviceRed:p.origin.x 
                               green:p.origin.y
                                blue:p.size.width
                               alpha:p.size.height];
#endif
}

#if IPHONE
- (void) createBezierPath
{
  CGMutablePathRef path = CGPathCreateMutable();
  BOOL first = YES;
  CGAffineTransform transform   = CGAffineTransformIdentity;
  transform = CGAffineTransformInvert(transform);
  for(NSValue *v in self.points){
    CGPoint p = [v CGPointValue];
    if(first){
      CGPathMoveToPoint(path, &transform, p.x, p.y);
      first = NO;
    }else{
      CGPathAddLineToPoint(path, &transform, p.x, p.y);
    }
  }
  self.path = path;
}
#endif

#if IPHONE
- (NSMutableArray*) deserializePoints:(NSArray*) array
{
  NSMutableArray *output = [NSMutableArray array];
  for(NSString* p in array){
    NSValue *v = [NSValue valueWithCGPoint:CGPointFromString(p)];
    [output addObject:v];
  }
  return output;
}
#else

- (NSArray*) serializedPoints
{
  NSMutableArray *output = [NSMutableArray array];
  for(NSValue *number in self.points){
    NSPoint p = [number pointValue];
    NSString *l= NSStringFromPoint(p);
    [output addObject:l];
  }
  return output;
}
#endif


- (id) initWithCoder:(NSCoder*)coder
{
#if IPHONE
  self = [self init];
  self.points = [self deserializePoints:[coder decodeObjectForKey:@"points"]];
  self.fillColor = [self decodeColor:[coder decodeObjectForKey:@"fillColor"]];
  self.pathColor = [self decodeColor:[coder decodeObjectForKey:@"pathColor"]];
  [self createBezierPath];
#endif
  return self;
}

- (void) encodeColor:(CurrentColor_t)color forKey:(NSString*) key withCoder:(NSCoder*)coder
{
  NSString *result ;
#if IPHONE
  const CGFloat *buffer = CGColorGetComponents([color CGColor]);  
  CGRect r;
  r.origin.x = buffer[0];
  r.origin.y = buffer[1];
  r.size.width = buffer[2];
  r.size.height = buffer[4];
  result = NSStringFromCGRect(r);
#else
  NSRect p;
  p.origin.x = [color redComponent];
  p.origin.y = [color greenComponent];
  p.size.width = [color blueComponent];
  p.size.height = [color alphaComponent];
  result = NSStringFromRect(p);
#endif
  [coder encodeObject:result forKey:key];
}

- (void) encodeWithCoder:(NSCoder*)coder
{
#if !IPHONE
  [coder encodeObject:[self serializedPoints] forKey:@"points"];

  [self encodeColor:self.pathColor forKey:@"pathColor" withCoder:coder];
  [self encodeColor:self.fillColor forKey:@"fillColor" withCoder:coder];
#else
  // can't write on the phone yet
#endif
}

#if !IPHONE
- (SimpleBezier*) flippedForBounds:(NSRect) bounds
{
  SimpleBezier *k = [[SimpleBezier alloc] init];
  k.fillColor = self.fillColor;
  k.pathColor = self.pathColor;
  NSMutableArray *points = [NSMutableArray array];
  for(NSValue *p in self.points){
    NSValue *k = [NSValue valueWithPoint:unflipPointForRect([p pointValue], bounds)];
    [points addObject:k];
  }
  k.points = points;
  return k;
}
#endif
@end
