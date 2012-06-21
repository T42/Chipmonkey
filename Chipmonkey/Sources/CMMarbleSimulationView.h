//
//  ATSimulationView.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/8/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveChipmunk.h"
#import "CMMarbleLayer.h"
#import "CMMarbleImageSource.h"
@class AVAudioPlayer;
@interface CMMarbleSimulationView : UIView
	
{
	@protected
	NSMutableArray *simulatedLayers;
	NSMutableDictionary *touchingMarbles;
	ChipmunkSpace *space;
	CADisplayLink *displayLink;
	
	CMMarbleLayer *preparedLayer;
	id <CMMarbleImageSource> delegate;
	NSTimer *fireTimer;
	NSUInteger marblesToFire;
	
  
	// special images for foreground and background layers
	UIImage	*levelBackground;
	UIImage *levelForeground;
	CALayer *foregroundLayer, *backgroundLayer;
	
  
  // simulation timing
  NSTimeInterval  accumulator;
  CGFloat         timeScale;
  NSTimeInterval  timeStep;
	
	AVAudioPlayer		*marbleSound;
	
}
@property (retain, nonatomic) UIImage* levelBackground, *levelForeground;
@property (retain, nonatomic) CALayer* foregroundLayer, *backgroundLayer;

@property (retain, nonatomic) NSTimer *fireTimer;
@property (assign, nonatomic) IBOutlet id <CMMarbleImageSource> delegate;
@property (readonly, nonatomic) NSDictionary *touchingMarbles;
@property (readonly, nonatomic) NSArray *simulatedLayers;
@property (retain, nonatomic) ChipmunkSpace *space;
@property (retain, nonatomic) CADisplayLink *displayLink;
@property (retain, nonatomic) CMMarbleLayer *preparedLayer;
@property (assign, nonatomic) NSArray* staticShapes;

@property(nonatomic, readonly) NSTimeInterval accumulator;
@property(nonatomic, assign) cpFloat timeScale;
//@property(nonatomic, readonly) NSTimeInterval preferredTimeStep;
@property(nonatomic, assign) NSTimeInterval timeStep;


- (IBAction)createMarble:(id)sender;
- (void) startSimulation;
- (void) fireMarbles:(NSUInteger) numOfMarbles inTime:(CGFloat) seconds;
- (void) stopSimulation;
- (void) resetSimulation;
- (void) removeLevelData;
- (void) update:(NSTimeInterval)dt;
- (NSUInteger) filterSimulatedLayers;
- (void) updateLayerPositions;
@end
