//
//  CMDebugViewController.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/17/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMDebugViewController.h"
#import "CMAppDelegate.h"

@interface CMDebugViewController ()
{
@protected
	// UI
	UITextField		*framerateText;
	UISlider			*framerateSlider;
	UITextField		*simulationrateText;
	UISlider			*simulationrateSlider;
	UITextField		*timescaleText;
	UIStepper			*timescaleStepper;
	
	// data
//	NSUInteger framerate,simulationrate,timescale;
}

//@property(assign,nonatomic) NSUInteger framerate,simulationrate,timescale;

@end

@implementation CMDebugViewController
@synthesize framerateText,framerateSlider,simulationrateText,simulationrateSlider,timescaleText,timescaleStepper;
//@synthesize  framerate, simulationrate, timescale;

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

- (void) viewWillAppear:(BOOL) animated
{
  [super viewWillAppear:animated];

	NSObject<CMGameControllerProtocol> *currentGamecontroller = 			[(CMAppDelegate*)[UIApplication sharedApplication].delegate currentGamecontroller];
	self.framerateSlider.value = currentGamecontroller.framerate;
	self.framerateText.text = [NSString stringWithFormat:@"%i",currentGamecontroller.framerate];
	
	self.simulationrateSlider.value = currentGamecontroller.simulationrate;
	self.simulationrateText.text = [NSString stringWithFormat:@"%i",currentGamecontroller.simulationrate];

	self.timescaleStepper.value = currentGamecontroller.timescale;
	self.timescaleText.text = [NSString stringWithFormat:@"%i",currentGamecontroller.timescale];
}


- (void) setDebugValue:(CGFloat)value forTag:(NSInteger) tag
{

	NSObject<CMGameControllerProtocol> *currentGamecontroller = 			[(CMAppDelegate*)[UIApplication sharedApplication].delegate currentGamecontroller];
	switch (tag) {
		case 0:
			if (value>self.framerateSlider.maximumValue) {value = self.framerateSlider.maximumValue;}else if(value<self.framerateSlider.minimumValue){value = self.framerateSlider.minimumValue;}
			self.framerateSlider.value = (NSInteger)value;
			self.framerateText.text = [NSString stringWithFormat:@"%i",(NSInteger)value];
			currentGamecontroller.framerate = (NSInteger) value;
			break;
		case 1:
			if (value>self.simulationrateSlider.maximumValue) {value = self.simulationrateSlider.maximumValue;}else if(value<self.simulationrateSlider.minimumValue){value = self.simulationrateSlider.minimumValue;}
			self.simulationrateSlider.value = (NSInteger)value;
			self.simulationrateText.text = [NSString stringWithFormat:@"%i",(NSInteger)value];
			currentGamecontroller.simulationrate = (NSInteger) value;
			break;
		case 2:
			if (value>self.timescaleStepper.maximumValue) {value = self.timescaleStepper.maximumValue;}else if(value<self.timescaleStepper.minimumValue){value = self.timescaleStepper.minimumValue;}
			self.timescaleStepper.value = (NSInteger)value;
			self.timescaleText.text = [NSString stringWithFormat:@"%i",(NSInteger)value];
			currentGamecontroller.timescale = (NSInteger) value;
			break;
		default:
			break;
	}
	
}

#pragma mark - Actions



- (IBAction)stepperAction:(UIStepper*)sender
{
	[self setDebugValue:sender.value forTag: sender.tag];	
	
}
- (IBAction)sliderAction:(UISlider*)sender
{
	[self setDebugValue:sender.value forTag: sender.tag];
}

- (IBAction)textFieldAction:(UITextField*)sender
{
		[self setDebugValue:sender.text.integerValue forTag: sender.tag];
}

- (IBAction)doneAction:(id)sender
{
	[self dismissAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}
- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
}

@end
