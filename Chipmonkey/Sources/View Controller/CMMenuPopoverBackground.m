//
//  CMMenuPopoverBackground.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/16/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMMenuPopoverBackground.h"

@implementation CMMenuPopoverBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//			self.backgroundColor = nil;
			self.layer.borderColor = nil;
			self.layer.cornerRadius = 0;
			self.layer.borderWidth = 0;
		}
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
