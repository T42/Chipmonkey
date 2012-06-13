//
//  BezierDrawer.m
//  GraffleReader
//
//  Created by Carsten Müller on 19/01/2009.
//  Copyright 2009 T42 Networking. All rights reserved.
//

#import "BezierDrawView.h"

#import "SimpleBezier.h"

@implementation BezierDrawView

- (id)initWithFrame:(NSRect)frame 
{
  self = [super initWithFrame:frame];
  if (self) {
    _bezierPathes = [[NSMutableArray array] retain];
  }
  return self;
}


- (void) dealloc
{
  [_bezierPathes release];
  [super dealloc];
}

- (void) addBezierPath:(SimpleBezier*) bp
{
  if(bp){
    [_bezierPathes addObject:bp];
    [self setNeedsDisplay:YES];
  }
}

- (void) removeBezierPath:(SimpleBezier*)bp
{
  if(bp){
    [_bezierPathes removeObject:bp];
    [self setNeedsDisplay:YES];
  }
}

- (void) removeAllPathes
{
  [_bezierPathes removeAllObjects];
  [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)rect {
  NSGraphicsContext *gc = [NSGraphicsContext currentContext];
  [gc saveGraphicsState];
  [[NSColor whiteColor] set];

  [NSBezierPath fillRect:[self bounds]];

  [[NSColor blackColor] set];
  [NSBezierPath strokeRect:[self bounds]];
//  NSPoint p ;
//  p.x = self.bounds.size.width;
//  p.y = self.bounds.size.height;
//    [NSBezierPath strokeLineFromPoint:NSZeroPoint toPoint:p];
  for(SimpleBezier *bPath in _bezierPathes){
    NSBezierPath *bp = bPath.path;
    NSColor *strokeColor = bPath.pathColor;
    NSColor *fillColor = bPath.fillColor;
    if(fillColor){
      [fillColor set];
      [bp fill];
    }
    if(strokeColor){
      [strokeColor set];
      [bp stroke];
    }
  }
  [gc restoreGraphicsState];

}

- (BOOL) isFlipped
{
  return NO;
}

@end
