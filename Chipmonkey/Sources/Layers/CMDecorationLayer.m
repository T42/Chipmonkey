//
//  CMScoreLayer.m
//  Chipmonkey
//
//  Created by Carsten Müller on 7/2/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMDecorationLayer.h"

@implementation CMDecorationLayer


- (id) init
{
  if((self = [super init])){
    self.backgroundColor = [[UIColor blackColor]CGColor];
    self.backgroundColor = CGColorCreateCopyWithAlpha(self.backgroundColor, .8);
    self.bounds = CGRectMake(0.0, 0.0, 30, 30);
  }
  return self;
}
- (void) dealloc
{
  [super dealloc];
}


-(void) createAnimations:(CMDecorationLayer*) layer duration:(CGFloat) duration endPosition:(CGPoint) endPos
{
  if(layer){
//    CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    an.fromValue = [NSNumber numberWithFloat: 1.0];
//    an.toValue = [NSNumber numberWithFloat:0.0];
//    an.duration = 2;
//    //    an.delegate = self;
//    [layer addAnimation:an forKey:@"fadeOut"];
//    layer.opacity = 1.0;
//    
//    CABasicAnimation *na = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    na.fromValue = [NSNumber numberWithFloat:1.0];
//    na.toValue = [NSNumber numberWithFloat:0.01];
//    na.duration = 2;
//    //    na.delegate = self;
//    [layer addAnimation:na forKey:@"fadeOut"];
//    [layer setValue:[NSNumber numberWithFloat:1.0] forKeyPath:@"transform.scale"];
    
    CABasicAnimation *pAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    pAnim.fromValue = [NSValue valueWithCGPoint:self.position];
    pAnim.toValue = [NSValue valueWithCGPoint:endPos];
    pAnim.duration = 2.1;
    pAnim.delegate = self;
    [layer addAnimation:pAnim forKey:@"move"];
    layer.position = endPos;
  }
}


- (void) addToSuperlayer:(CALayer *)superlayer withPosition:(CGPoint)position
{
  [superlayer addSublayer:self];
  self.position = position;
  [self createAnimations:self duration:2 endPosition:CGPointMake(position.x, position.y - 100)];
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  //	NSLog(@"finished: %i",flag);
	[self removeFromSuperlayer];
}

@end
