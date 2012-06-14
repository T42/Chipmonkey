//
//  CMMarbleMenuController.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/14/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMMarbleMenuController.h"

@interface CMMarbleMenuController ()

@end

@implementation CMMarbleMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

#pragma mark -
#pragma mark Actions

- (IBAction)menuAction:(UISegmentedControl *)sender
{
	switch (sender.selectedSegmentIndex) {
		case 0: 
			[self selectLevel:sender];
			break;
		case 1:
			[self openOptions:sender];
			break;
		case 2:
			[self resetProgress:sender];
			break;
		default:
			break;
	}
}
- (void) dismissMyself
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectLevel:(id)sender
{
	NSLog(@"%@ %@",NSStringFromSelector(_cmd),sender);
	[self dismissMyself];
}

- (IBAction)openOptions:(id)sender
{
	NSLog(@"%@ %@",NSStringFromSelector(_cmd),sender);	
	[self dismissMyself];
}

- (IBAction) resetProgress:(id) sender
{
	NSLog(@"%@ %@",NSStringFromSelector(_cmd),sender);		
	[self dismissMyself];
}

@end
