//
//  CMPopoverContentController.h
//  
//
//  Created by Carsten Müller on 6/15/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CMPopoverContentController : UIViewController 
{
	UIPopoverController *localPopoverController;
	UIPopoverController *parentPopoverController;
}
@property (retain, nonatomic) UIPopoverController* localPopoverController;
@property (retain, nonatomic) UIPopoverController* parentPopoverController;
- (void) dismissAnimated:(BOOL) flag;


@end
