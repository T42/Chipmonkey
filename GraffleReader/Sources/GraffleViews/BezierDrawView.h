//
//  BezierDrawer.h
//  GraffleReader
//
//  Created by Carsten Müller on 19/01/2009.
//  Copyright 2009 T42 Networking. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SimpleBezier.h"


@interface BezierDrawView : NSView {
  NSMutableArray *_bezierPathes; 
}


- (void) removeAllPathes;
- (void) addBezierPath:(SimpleBezier*) bp;
- (void) removeBezierPath:(SimpleBezier*)bp;

@end
