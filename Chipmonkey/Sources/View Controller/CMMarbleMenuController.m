//
//  CMMarbleMenuController.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/14/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMMarbleMenuController.h"
#import "CMMarbleGameController.h"
#import "CMSimplePopoverBackground.h"
#import "CMOptionsViewController.h"
#import "CMDebugViewController.h"
@interface CMMarbleMenuController ()

@end

@implementation CMMarbleMenuController
@synthesize  gameController, optionsController,debugController, menuControl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
#if (DEBUG == 1)
	NSUInteger p = [self.menuControl numberOfSegments];
	[self.menuControl insertSegmentWithTitle:@"Debug" atIndex:p animated:YES];
#endif
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
		case 3:
			[self restartLevel:sender];
			break;
		case 4:
			[self previousLevel:sender];
			break;
		case 5:
			[self nextLevel:sender];
			break;
		case 6:
			[self debugAction:sender];
			break;

		default:			
			break;
	}
}

- (IBAction)selectLevel:(id)sender
{
	NSLog(@"%@ %@",NSStringFromSelector(_cmd),sender);
	[self dismissAnimated:YES];
}

- (IBAction)openOptions:(id)sender
{
	NSLog(@"%@ %@",NSStringFromSelector(_cmd),sender);	
	[self dismissAnimated:YES];
	
	if(!self.localPopoverController){
		self.localPopoverController = [[[UIPopoverController alloc]initWithContentViewController:self.optionsController]autorelease];
	}
	self.localPopoverController.contentViewController = self.optionsController;
	self.localPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
	self.localPopoverController.popoverBackgroundViewClass = [CMSimplePopoverBackground class];
	self.optionsController.parentPopoverController=self.localPopoverController;
	[self.localPopoverController presentPopoverFromRect:CGRectMake(0, 0, 1024,768) inView:self.view permittedArrowDirections:(0) animated:YES];
}

- (IBAction) resetProgress:(id) sender
{
	NSLog(@"%@ %@",NSStringFromSelector(_cmd),sender);		
	[self dismissAnimated:YES];
	[self.gameController resetLevels:nil];
}

- (IBAction)restartLevel:(id)sender
{
	NSLog(@"%@ %@",NSStringFromSelector(_cmd),sender);		
	[self.gameController resetSimulation:nil];
	[self.gameController prepareLevel:self.gameController.currentLevel];
	[self dismissAnimated:YES];	
}

- (IBAction)nextLevel:(id)sender
{
	[self.gameController resetSimulation:nil];
	self.gameController.currentLevel++;
	[self.gameController prepareLevel:self.gameController.currentLevel];
	[self dismissAnimated:YES];		
}

- (IBAction)previousLevel:(id)sender
{
	[self.gameController resetSimulation:nil];
	self.gameController.currentLevel--;
	[self.gameController prepareLevel:self.gameController.currentLevel];
	[self dismissAnimated:YES];		
}

- (IBAction) debugAction:(id) sender
{
	[self dismissAnimated:YES];
	if (!self.localPopoverController) {
				self.localPopoverController = [[[UIPopoverController alloc]initWithContentViewController:self.debugController]autorelease];
	}
	self.localPopoverController.contentViewController = self.debugController;
	self.localPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
	self.localPopoverController.popoverBackgroundViewClass = [CMSimplePopoverBackground class];
	self.debugController.parentPopoverController=self.localPopoverController;
	[self.localPopoverController presentPopoverFromRect:CGRectMake(0, 0, 1024,768) inView:self.view permittedArrowDirections:(0) animated:YES];
	
}

#pragma mark - Popover

- (BOOL) isModalInPopover
{
	return NO;
}

@end
