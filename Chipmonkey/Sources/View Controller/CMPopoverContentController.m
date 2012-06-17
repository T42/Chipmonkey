//
//  CMPopoverContentController.m
//  
//
//  Created by Carsten Müller on 6/15/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMPopoverContentController.h"

@implementation CMPopoverContentController
@synthesize localPopoverController,parentPopoverController;

- (void) dismissAnimated:(BOOL) flag
{
	if(!self.parentPopoverController){
		[self dismissViewControllerAnimated:YES completion:nil];
	}else{
		[self.parentPopoverController dismissPopoverAnimated:YES];
	}
}

- (void) dealloc
{

	self.localPopoverController = nil;
	self.parentPopoverController = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Properties


- (void) setParentPopoverController:(UIPopoverController *)ppc
{
	if(self->parentPopoverController != ppc){
		[self->parentPopoverController autorelease];
		self->parentPopoverController = [ppc retain];
	}
}

- (BOOL) isModalInPopover
{
	return YES;
}

//- (CGSize) contentSizeForViewInPopover
//{
//	NSLog(@"ContentInPopOver: %@",NSStringFromCGSize(self.view.bounds.size));
//	return self.view.bounds.size;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
		return YES;
	return NO;
}


@end
