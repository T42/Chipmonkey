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
#import "CMGameControllerProtocol.h"
#import "CMMarbleLevelStartController.h"
#import "CMMarbleLevelEndController.h"
#import "CMMarbleCollisionCollector.h"

#define USE_BILLARD_IMAGES 0


@interface UIButton (CMMarbleGameHelper)
@property (retain,nonatomic) UIImage* image;
@end

@class CMMarbleLevelSet,CMMarbleLevelStatistics;
@interface CMMarbleGameController : UIViewController <CMMarbleImageSource,CMGameControllerProtocol>
{
	@protected
	CMMarbleSimulationView          *playgroundView;
	NSMutableArray                  *marbleImages;
	UIImage                         *marblePreview;
	NSMutableArray                  *nextMarbleImages;
	UILabel                         *levelLabel;
	UIView													*scoreView;	
	CMMarbleMenuController          * menuController;
  CMMarbleLevelStartController    *levelStartController;
  CMMarbleLevelEndController      *levelEndController;
	UIPopoverController             *localPopoverController;
  UIButton                        *menuButton;

	// score view Elements
	UILabel											*levelTimeLabel;
	UILabel											*playerScoreLabel;
	UILabel											*comboMarkerView;

	
	NSUInteger                      currentLevel;
	CMMarbleLevelSet                *levelSet;
	NSMutableDictionary							*levelStatistics;
	CMMarbleLevelStatistics					*currentStatistics;
  
  // game time
  CADisplayLink               *displayLink;
  NSTimeInterval              lastSimulationTime;
	NSTimeInterval							lastDisplayTime;
	NSTimeInterval							frameTime;
	
	
	// properties for the Current Score and time etc. These properties will move to a player class some day
	NSUInteger									playerScore;
	NSTimeInterval							levelTime;
	
	// audio Properties
	CGFloat											soundVolume,musicVolume;
	BOOL												playSound, playMusic;
	
	// combo Helper
	NSUInteger					comboHits;
}
@property(retain,nonatomic) IBOutlet UIButton * menuButton;
@property(retain,nonatomic) IBOutlet CMMarbleSimulationView *playgroundView;
@property(retain,nonatomic) UIImage* marblePreview;
@property(retain,nonatomic) IBOutlet UILabel *levelLabel;
@property(retain,nonatomic) IBOutlet UIView* scoreView;
@property(retain,nonatomic) IBOutlet CMMarbleMenuController *menuController;
@property(retain,nonatomic) IBOutlet CMMarbleLevelStartController *levelStartController;
@property(retain,nonatomic) IBOutlet CMMarbleLevelEndController *levelEndController;
@property(retain,nonatomic) IBOutlet UIPopoverController *localPopoverController;
@property(retain,nonatomic) IBOutlet UILabel *comboMarkerView;

@property(retain,nonatomic) IBOutlet UILabel* levelTimeLabel;
@property(retain,nonatomic) IBOutlet UILabel* playerScoreLabel;

@property(assign,nonatomic) NSUInteger currentLevel;
@property(retain,nonatomic) CMMarbleLevelSet *levelSet;
@property(retain, nonatomic) NSMutableDictionary *levelStatistics;
@property(assign, nonatomic) CMMarbleLevelStatistics *currentStatistics;

@property(retain,nonatomic) CADisplayLink *displayLink;
@property(assign,nonatomic) NSTimeInterval lastSimulationTime,lastDisplayTime,frameTime;

@property(assign,nonatomic) NSUInteger playerScore;
@property(assign,nonatomic) NSTimeInterval levelTime;

@property(assign, nonatomic) CGFloat soundVolume, musicVolume;
@property(assign, nonatomic) BOOL playSound, playMusic;

@property(assign, nonatomic) NSUInteger comboHits;

- (IBAction)resetLevels:(id) sender; 	// Depricated 
- (IBAction)startSimulation:(id)sender; // used internaly 
- (IBAction)stopSimulation:(id)sender;	// used internaly
- (IBAction)resetSimulation:(id)sender; // used internaly


- (IBAction)fireMarbles:(id) sender;		// from main bar

// From Level Begin Dialog
- (IBAction)cancelLevel:(id)sender;			
- (IBAction)startLevel:(id)sender;			

//From Level Finished Dialog
- (IBAction)finishLevel:(id)sender;

// Menubar
- (IBAction)showMenuBar:(id)sender;

- (void) prepareLevel:(NSUInteger) levelIndex;
@end
