//
//  CMMarbleMenuController.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/14/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CMPopoverContentController.h"

@class CMMarbleGameController,CMOptionsViewController,CMDebugViewController;

@interface CMMarbleMenuController : CMPopoverContentController
{
	@protected
	CMMarbleGameController *gameController;
	CMOptionsViewController *optionsController;
	CMDebugViewController *debugController;
}
@property(retain, nonatomic) IBOutlet CMMarbleGameController* gameController;
@property(retain, nonatomic) IBOutlet CMOptionsViewController* optionsController;
@property(retain, nonatomic) IBOutlet CMDebugViewController *debugController;
- (IBAction)menuAction:(UISegmentedControl*)sender;
- (IBAction) selectLevel:(id)sender;
- (IBAction) openOptions:(id) sender;
- (IBAction) resetProgress:(id)sender;
- (IBAction)restartLevel:(id)sender;
- (IBAction) nextLevel:(id)sender;
- (IBAction)previousLevel:(id)sender;
- (IBAction)debugAction:(id)sender;
@end
