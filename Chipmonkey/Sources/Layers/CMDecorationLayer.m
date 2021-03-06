//
//  CMScoreLayer.m
//  Chipmonkey
//
//  Created by Carsten Müller on 7/2/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMDecorationLayer.h"

@implementation CMDecorationLayer

- (void) initDefaults
{
  self.backgroundColor = [[UIColor colorWithWhite:0.0 alpha:0.8]CGColor];
  self.bounds = CGRectMake(0.0, 0.0, 30, 30);
  
}


- (id) init
{
  if((self = [super init])){
    [self initDefaults];
  }
  return self;
}

- (id) initWithContent:(id) content andSize:(CGSize) size
{
  if((self = [super init])){
    [self initDefaults];
    self.bounds = CGRectMake(0, 0, size.width, size.height);
    self.contents = content;
  }
  return self;
}

- (void) dealloc
{
  [super dealloc];
}

//- (void) createAnimations:(CMDecorationLayer*) layer duration:(CGFloat) duration endPosition:(CGPoint) endPos
//{
//  self.duration = duration;
//  self.opacity = 0.0;
//  //  self.transform.scale = 0.01;
//  self.position = endPos;
//  
//}

-(void) createAnimations:(CMDecorationLayer*) layer duration:(CGFloat) duration endPosition:(CGPoint) endPos
{
  if(layer){
		CAAnimationGroup *group = [CAAnimationGroup animation];

    CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"opacity"];
    an.fromValue = [NSNumber numberWithFloat: 1.0];
    an.toValue = [NSNumber numberWithFloat:0.0];
    an.duration = duration;
    an.delegate = self;
//    [layer addAnimation:an forKey:@"opacity"];
    layer.opacity = 0.0;
    
    CABasicAnimation *na = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    na.fromValue = [NSNumber numberWithFloat:1.0];
    na.toValue = [NSNumber numberWithFloat:0.01];
    na.duration = duration;
    na.delegate = self;
//    [layer addAnimation:na forKey:@"fadeOut"];
    [layer setValue:[NSNumber numberWithFloat:0.01] forKeyPath:@"transform.scale"];
		
		CABasicAnimation *rotAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
		rotAnim.fromValue = [NSNumber numberWithFloat:0*M_PI/180.0];
		rotAnim.toValue = [NSNumber numberWithFloat:359*M_PI/180.0];
		rotAnim.repeatCount = 5;
		rotAnim.autoreverses = NO;
		rotAnim.duration = duration/rotAnim.repeatCount;
    
    CABasicAnimation *pAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    pAnim.fromValue = [NSValue valueWithCGPoint:self.position];
    pAnim.toValue = [NSValue valueWithCGPoint:endPos];
    pAnim.duration = duration;
    pAnim.delegate = self;
//    [layer addAnimation:pAnim forKey:@"position"];
    layer.position = endPos;
		
		group.animations = [NSArray arrayWithObjects:an,na,pAnim,rotAnim, nil];
		group.duration = duration;
		group.delegate = self;
		[layer addAnimation:group forKey:@"flow"];
  }
}


- (void) addToSuperlayer:(CALayer *)superlayer withPosition:(CGPoint)position
{
  [superlayer addSublayer:self];
  self.position = position;
  [self createAnimations:self duration:3 endPosition:CGPointMake(position.x, position.y - 300)];
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  //	NSLog(@"finished: %i",flag);
	[self removeFromSuperlayer];
}

//- (id <CAAction>) actionForKey:(NSString *)event
//{
//	return nil ;
//}

@end
