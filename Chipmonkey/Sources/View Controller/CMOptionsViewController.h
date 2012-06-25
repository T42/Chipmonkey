//
//  CMOptionsViewController.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/15/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopoverContentController.h"

@interface CMOptionsViewController : CMPopoverContentController
{
	@protected
	UISlider				*soundVolumeSlider,*musicVolumeSlider;
	UISwitch				*soundSwitch,*musicSwitch;
				
}

@property (retain, nonatomic) IBOutlet UISlider* soundVolumeSlider;
@property (retain, nonatomic) IBOutlet UISwitch* soundSwitch;
@property (retain, nonatomic) IBOutlet UISlider *musicVolumeSlider;
@property (retain, nonatomic) IBOutlet UISwitch *musicSwitch;

- (IBAction)soundVolume:(UISlider*)sender;

- (IBAction)switchSound:(UISwitch*)soundSwitch;

- (IBAction)musicVolume:(UISlider*)sender;

- (IBAction)switchMusic:(UISwitch*)sender;

- (IBAction)doneAction:(id)sender;
@end
