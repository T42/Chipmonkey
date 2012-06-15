//
//  CMSimplePopoverBackground.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/15/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMSimplePopoverBackground.h"

@implementation CMSimplePopoverBackground
@synthesize arrowOffset, arrowDirection;
+(UIEdgeInsets) contentViewInsets
{
	return UIEdgeInsetsMake(0, 0, 0, 0);
}

+ (CGFloat) arrowHeight
{
	return 1;
}

+ (CGFloat) arrowBase
{
	return 1;
}

- (UIPopoverArrowDirection) arrowDirection
{
	return UIPopoverArrowDirectionDown;
}

- (CGFloat) arrowOffset
{
	return 0;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
