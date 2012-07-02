//
//  CMScoreLayer.h
//  Chipmonkey
//
//  Created by Carsten Müller on 7/2/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//  Simple temporary layer moving upward from its initial position.

#import <QuartzCore/QuartzCore.h>

@interface CMDecorationLayer : CALayer

- (void) addToSuperlayer:(CALayer*)superlayer withPosition:(CGPoint) position;
@end
