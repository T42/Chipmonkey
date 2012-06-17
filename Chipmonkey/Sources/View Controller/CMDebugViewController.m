//
//  CMDebugViewController.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/17/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMDebugViewController.h"

@interface CMDebugViewController ()

@end

@implementation CMDebugViewController

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
	return YES;
}

- (IBAction)doneAction:(id)sender
{
	
}

@end
