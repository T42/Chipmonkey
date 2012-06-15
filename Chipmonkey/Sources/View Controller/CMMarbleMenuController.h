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

@class CMMarbleGameController;

@interface CMMarbleMenuController : CMPopoverContentController
{
	@protected
	CMMarbleGameController *gameController;
	
}
@property(retain, nonatomic) IBOutlet CMMarbleGameController* gameController;
- (IBAction)menuAction:(UISegmentedControl*)sender;
- (IBAction) selectLevel:(id)sender;
- (IBAction) openOptions:(id) sender;
- (IBAction) resetProgress:(id)sender;
- (IBAction)restartLevel:(id)sender;
- (IBAction) nextLevel:(id)sender;
- (IBAction)previousLevel:(id)sender;
@end
