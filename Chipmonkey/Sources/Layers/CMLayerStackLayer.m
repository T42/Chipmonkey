//
//  CMLayerStackLayer.m
//  Chipmonkey
//
//  Created by Carsten Müller on 7/3/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMLayerStackLayer.h"

@implementation CMLayerStackLayer

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (void) pushLayer:(CALayer *)someLayer
{
	[self pushLayer:someLayer animated:YES];
}

- (void) pushLayer:(CALayer *)someLayer animated:(BOOL)flag
{
	someLayer.delegate = self;
	if (!flag) {
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	}
	CGFloat xPos = self.bounds.size.height * [self.sublayers count];
	if (xPos>0) {
		xPos +=2;
	}
	CGRect sframe = CGRectMake(xPos, 2, self.bounds.size.height-4, self.bounds.size.height-4);
	someLayer.frame = sframe;
	[self addSublayer:someLayer];
	if(!flag){
		[CATransaction commit];
	}
}

- (CALayer*) popLayer
{
	return [self popLayerAnimated:YES];
}

- (CALayer*) popLayerAnimated:(BOOL)flag
{
	CALayer *lastLayer = [self.sublayers lastObject];
	if (!flag) {
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	}
	[lastLayer removeFromSuperlayer];
	if(!flag){
		[CATransaction commit];
	}

	return lastLayer;
}
- (void) clearStack
{
	for (CALayer* aLayer in [self.sublayers copy]) {
    [aLayer removeFromSuperlayer];
	}
}

- (id < CAAction >)actionForLayer:(CALayer *)layer forKey:(NSString *)key
{
	if ([key isEqualToString:@"onOrderIn"] || [key isEqualToString:@"onOrderOut"]) {
		CABasicAnimation *pa = [CABasicAnimation animationWithKeyPath:@"position"];
		
		CGFloat startX =self.bounds.size.width+(self.bounds.size.height-4)/2.0;
		CGFloat maxDistance = startX - 16;
		CGFloat endX = layer.position.x;

		CGFloat distance = (startX - endX)-(self.bounds.size.height-4)/2.0;
		NSLog(@"distance: %f",distance);		
		pa.fromValue = [NSValue valueWithCGPoint:CGPointMake(startX, layer.position.y)];
		pa.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y)];
		
		pa.duration =1.8/(maxDistance/distance);
		NSLog(@"duration: %f",pa.duration);
		return pa;
	}else {
		return nil;
	}
}


@end
