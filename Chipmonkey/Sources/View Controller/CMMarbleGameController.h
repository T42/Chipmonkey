//
//  ATViewController.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/8/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CMMarbleSimulationView.h"
#import "CMMarbleImageSource.h"
#import "CMMarbleMenuController.h"

@interface UIButton (CMMarbleGameHelper)
@property (retain,nonatomic) UIImage* image;
@end
@interface CMMarbleGameController : UIViewController <CMMarbleImageSource>
{
	@protected
	CMMarbleSimulationView			*playgroundView;
	NSMutableArray							*marbleImages;
	UIButton										*marblePreview;
	NSMutableArray							*nextMarbleImages;
	UIView											*finishView;
	UIView											*startView;
	UILabel											*levelLabel;
	NSUInteger									levelLimit;
	NSUInteger									currentLevel;
	NSMutableArray							*levels;
	
	CMMarbleMenuController			* menuController;
	UIPopoverController					*localPopoverController;
}
@property(retain,nonatomic) IBOutlet UIView* finishView, *startView;;
@property(retain,nonatomic) IBOutlet CMMarbleSimulationView *playgroundView;
@property(retain,nonatomic) IBOutlet UIButton* marblePreview;
@property(retain,nonatomic) IBOutlet UILabel *levelLabel;
@property(assign,nonatomic) NSUInteger levelLimit, currentLevel;
@property(retain,nonatomic) NSMutableArray *levels;
@property(retain,nonatomic) IBOutlet CMMarbleMenuController *menuController;
@property(retain,nonatomic) IBOutlet UIPopoverController *localPopoverController;

- (IBAction) resetLevels:(id) sender; 	// Depricated 
- (IBAction)startSimulation:(id)sender; // used internaly 
- (IBAction)stopSimulation:(id)sender;	// used internaly
- (IBAction)resetSimulation:(id)sender; // used internaly


- (IBAction)fireMarbles:(id) sender;		// from main bar

// From Level Begin Dialog
- (IBAction)cancelLevel:(id)sender;			
- (IBAction)startLevel:(id)sender;			

//From Level Finished Dialog
- (IBAction)thanksAction:(id)sender;

// Menubar
- (IBAction)showMenuBar:(id)sender;

- (void) prepareLevel:(NSUInteger) levelIndex;
@end
