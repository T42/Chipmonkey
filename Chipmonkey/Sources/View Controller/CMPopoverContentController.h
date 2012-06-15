//
//  CMPopoverContentController.h
//  
//
//  Created by Carsten Müller on 6/15/12.
//  Copyright (c) 2012 Apple GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CMPopoverContentController : UIViewController 
{
    UIPopoverController *popoverController;
}
@property (retain, nonatomic) UIPopoverController* popoverController;
- (void) dismissAnimated:(BOOL) flag;
@end
