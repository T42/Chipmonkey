//
//  GraffleBezierView.m
//  GraffleReader
//
//  Created by Carsten Müller on 19/01/2009.
//  Copyright 2009 T42 Networking. All rights reserved.
//

#import "GraffleBezierViewController.h"
#import "GraffleDocument.h"
#import "GraffleBezierFactory.h"
#import "TGZoomingScrollView.h"
#import "BezierDrawView.h"


@implementation GraffleBezierViewController

@synthesize drawingView = _drawingView, scrollView = _scrollView, zoomFactor = _zoomFactor;

- (void) awakeFromNib
{
  NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
   [_scrollView bind:TGZoomingScrollViewFactor toObject:self withKeyPath:@"zoomFactor" options:nil];
  self.zoomFactor = 1.0;
}

- (void) dealloc
{
  NSLog(@"%@ %@",self, NSStringFromSelector(_cmd));
  [_scrollView unbind:TGZoomingScrollViewFactor];
  [super dealloc];
}
- (NSString*) nibName
{
  return @"GraffleBezierView";
}

- (void) addObjects:(NSArray*)indices fromFactory:(GraffleBezierFactory*)gbf
{
  for(NSNumber *index  in indices){
    SimpleBezier *bp = [gbf bezierPathForComponentAtIndex:[index intValue]];
    [_drawingView addBezierPath:bp];
  }
}

- (void) setRepresentedObject:(id) object
{
  [super setRepresentedObject:object];
//  NSLog(@"%@ %@ %@",self,NSStringFromSelector(_cmd),object);
  if([object isKindOfClass:[GraffleDocument class]]){
    GraffleDocument * document = (GraffleDocument*) object;
    NSRect p = [document bounds];
    [_drawingView setFrame:p];
    GraffleBezierFactory *gbf = [[[GraffleBezierFactory alloc] initWithDocument:document] autorelease];

    NSEnumerator *layerNames = [[document layernames] reverseObjectEnumerator];
    for(NSString* ln in layerNames){
      NSLog(@"Got layer:%@",ln);
      NSArray *indices = [object indicesOfObjectsFromLayerNamed:ln];
      [self addObjects:indices fromFactory:gbf];
      
    }
    
//    NSArray *indices = [object indicesOfObjectsFromLayerNamed:@"Ground"];
//    [self addObjects:indices fromFactory:gbf];
//
//    indices = [object indicesOfObjectsFromLayerNamed:@"Water"];
//    [self addObjects:indices fromFactory:gbf]; 
//
//    indices = [object indicesOfObjectsFromLayerNamed:@"Islands"];
//    [self addObjects:indices fromFactory:gbf];
//
//    indices = [object indicesOfObjectsFromLayerNamed:@"Buoys"];
//    [self addObjects:indices fromFactory:gbf];

  }
}
@end
