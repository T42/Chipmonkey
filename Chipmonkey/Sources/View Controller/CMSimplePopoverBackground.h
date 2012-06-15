//
//  CMSimplePopoverBackground.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/15/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSimplePopoverBackground : UIPopoverBackgroundView
{
	@protected
	CGFloat										arrowOffset;
	UIPopoverArrowDirection		arrowDirection;
	
}

@property (nonatomic, readwrite) CGFloat arrowOffset;
@property (nonatomic, readwrite) UIPopoverArrowDirection arrowDirection;
@end
