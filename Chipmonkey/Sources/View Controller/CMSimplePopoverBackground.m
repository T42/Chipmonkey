//
//  CMSimplePopoverBackground.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/15/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMSimplePopoverBackground.h"
#import <QuartzCore/QuartzCore.h>

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
      self.alpha = 1.0;
			self.backgroundColor = nil;
			self.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:.6]CGColor];
			self.layer.cornerRadius = 5;
			self.layer.borderWidth = 2;
			self.layer.backgroundColor = [[UIColor colorWithWhite:0.1 alpha:.96]CGColor];
			self.layer.masksToBounds = YES;
      self.layer.shadowPath = nil;
      self.layer.shadowColor =nil;
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
