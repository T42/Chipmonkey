//
//  CMPopoverContentController.m
//  
//
//  Created by Carsten Müller on 6/15/12.
//  Copyright (c) 2012 Apple GmbH. All rights reserved.
//

#import "CMPopoverContentController.h"

@implementation CMPopoverContentController
@synthesize popoverController;

- (void) dismissAnimated:(BOOL) flag
{
	if(!self.popoverController){
		[self dismissViewControllerAnimated:YES completion:nil];
	}else{
		[self.popoverController dismissPopoverAnimated:YES];
	}
}


@end
