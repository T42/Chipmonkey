//
//  CMOptionsViewController.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/15/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMOptionsViewController.h"
#import "CMAppDelegate.h"

@interface CMOptionsViewController ()

@end

@implementation CMOptionsViewController
@synthesize soundVolumeSlider,musicVolumeSlider,soundSwitch,musicSwitch;

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
- (void) viewWillAppear:(BOOL) animated
{
	NSObject<CMGameControllerProtocol> *currentGamecontroller = [(CMAppDelegate*)[UIApplication sharedApplication].delegate currentGamecontroller];
	self.soundSwitch.on = currentGamecontroller.playSound;
	self.soundVolumeSlider.value = currentGamecontroller.soundVolume;
	
	self.musicSwitch.on = currentGamecontroller.playMusic;
	self.musicVolumeSlider.value = currentGamecontroller.musicVolume;
}

- (void) awakeFromNib
{

}


#pragma mark - Actions
- (IBAction)soundVolume:(UISlider *)sender
{
	NSObject<CMGameControllerProtocol> *currentGamecontroller = [(CMAppDelegate*)[UIApplication sharedApplication].delegate currentGamecontroller];	
	currentGamecontroller.soundVolume = sender.value;
	if(self.soundSwitch.on && (sender.value < 0.05)){
		[self.soundSwitch setOn:NO animated:YES];
	}else if (!self.soundSwitch.on && (sender.value >0.05)) {
		[self.soundSwitch setOn:YES animated:YES];
	}
}

- (IBAction)switchSound:(UISwitch *)sSwitch
{
	NSObject<CMGameControllerProtocol> *currentGamecontroller = [(CMAppDelegate*)[UIApplication sharedApplication].delegate currentGamecontroller];
	currentGamecontroller.playSound = sSwitch.on;
}

- (IBAction)musicVolume:(UISlider *)sender
{
	NSObject<CMGameControllerProtocol> *currentGamecontroller = [(CMAppDelegate*)[UIApplication sharedApplication].delegate currentGamecontroller];
	currentGamecontroller.musicVolume = sender.value;
}

- (IBAction)switchMusic:(UISwitch *)sender
{
	NSObject<CMGameControllerProtocol> *currentGamecontroller = [(CMAppDelegate*)[UIApplication sharedApplication].delegate currentGamecontroller];
	currentGamecontroller.playMusic = sender.on;
}

- (IBAction)doneAction:(id)sender
{
	[self dismissAnimated:YES];
}

@end
