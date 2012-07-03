//
//  CMLayerStackLayer.h
//  Chipmonkey
//
//  Created by Carsten Müller on 7/3/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CMLayerStackLayer : CALayer 
{

}

- (void) pushLayer:(CALayer*) someLayer;

- (void) pushLayer:(CALayer *)someLayer animated:(BOOL) flag;

- (CALayer*) popLayer;
- (CALayer*) popLayerAnimated:(BOOL) flag;
- (void) clearStack;
@end
