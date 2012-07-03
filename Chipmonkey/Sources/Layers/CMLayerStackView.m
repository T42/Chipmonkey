//
//  CMLayerStackView.m
//  Chipmonkey
//
//  Created by Carsten Müller on 7/3/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMLayerStackView.h"
#import "CMLayerStackLayer.h"

@implementation CMLayerStackView

+ (Class)layerClass
{
	return [CMLayerStackLayer class];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self){
		self.layer.cornerRadius = self.bounds.size.height/2.0;
		self.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:.5]CGColor];
		self.layer.borderWidth = 2.0;
		self.layer.masksToBounds = YES;
	}
	return self;
}


- (void) pushLayer:(CALayer *)aLayer
{
	[(CMLayerStackLayer*)self.layer pushLayer:aLayer];
}

- (CALayer*) popLayer
{
	return [(CMLayerStackLayer*)self.layer popLayer];
}
- (void) clearStack
{
	[(CMLayerStackLayer*)self.layer clearStack];
}
@end
