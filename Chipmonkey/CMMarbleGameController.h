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

@interface UIButton (CMMarbleGameHelper)
@property (retain,nonatomic) UIImage* image;
@end
@interface CMMarbleGameController : UIViewController <CMMarbleImageSource>
{
	@protected
	CMMarbleSimulationView			*playgroundView;
	NSMutableArray				*marbleImages;
	UIButton						*marblePreview;
	NSMutableArray				*nextMarbleImages;
	UIView								*finishView;
}
@property(retain,nonatomic) IBOutlet UIView* finishView;
@property(retain,nonatomic) IBOutlet CMMarbleSimulationView *playgroundView;
@property(retain,nonatomic) IBOutlet UIButton* marblePreview;

- (IBAction)loadLevelAction:(id)sender;
- (IBAction)startSimulation:(id)sender;
- (IBAction)stopSimulation:(id)sender;
- (IBAction)resetSimulation:(id)sender;
- (IBAction)fireMarbles:(id) sender;
- (IBAction)thanksAction:(id)sender;
@end
