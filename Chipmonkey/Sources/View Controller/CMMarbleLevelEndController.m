//
//  CMMarbleLevelEndController.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/21/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMMarbleLevelEndController.h"
#import "CMGameControllerProtocol.h"
#import "CMAppDelegate.h"

@interface CMMarbleLevelEndController ()

@end

@implementation CMMarbleLevelEndController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)finishLevel:(id)sender
{
  NSObject<CMGameControllerProtocol> *currentGamecontroller = 			[(CMAppDelegate*)[UIApplication sharedApplication].delegate currentGamecontroller];
  [currentGamecontroller finishLevel:nil];
  [self dismissAnimated:YES];
  
}

@end
