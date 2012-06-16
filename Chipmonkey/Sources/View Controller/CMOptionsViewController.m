//
//  CMOptionsViewController.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/15/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMOptionsViewController.h"

@interface CMOptionsViewController ()

@end

@implementation CMOptionsViewController

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
	self.view.backgroundColor = nil;
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
	return YES;
}

- (void) awakeFromNib
{
	//
	
	NSLog(@"Frame:%@",NSStringFromCGRect(self.view.frame));
	NSLog(@"Bounds:%@",NSStringFromCGRect(self.view.bounds));
}

- (BOOL)isModalInPopover
{
return YES;
}

#pragma mark - Actions

- (IBAction)doneAction:(id)sender
{
	[self dismissAnimated:YES];
}

@end
