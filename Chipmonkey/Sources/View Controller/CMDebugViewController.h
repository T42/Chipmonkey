//
//  CMDebugViewController.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/17/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMPopoverContentController.h"

@interface CMDebugViewController : CMPopoverContentController <UITextFieldDelegate>


@property(retain,nonatomic) IBOutlet UITextField* framerateText;
@property(retain,nonatomic) IBOutlet UITextField*simulationrateText;
@property(retain,nonatomic) IBOutlet UITextField*timescaleText;

@property(retain,nonatomic) IBOutlet UISlider* framerateSlider;
@property(retain,nonatomic) IBOutlet UISlider *simulationrateSlider;

@property(retain,nonatomic) IBOutlet UIStepper *timescaleStepper;


- (IBAction)textFieldAction:(UITextField*)sender;
- (IBAction)sliderAction:(UISlider*)sender;
- (IBAction)stepperAction:(UIStepper*)sender;

- (IBAction)doneAction:(id)sender;
@end
