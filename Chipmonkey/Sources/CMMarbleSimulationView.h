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
#import "CMGameControllerProtocol.h"
@class AVAudioPlayer, CMMarbleCollisionCollector;
@interface CMMarbleSimulationView : UIView
	
{
	@protected
	NSMutableArray *simulatedLayers;
	
	NSMutableDictionary *touchingMarbles;
	
	CMMarbleCollisionCollector *collisionCollector;
	
	ChipmunkSpace *space;
	CADisplayLink *displayLink;
	
	CMMarbleLayer *preparedLayer;
	NSObject<CMMarbleImageSource,CMGameControllerProtocol> *delegate;
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
	
	CGFloat 				soundVolume;
	AVAudioPlayer		*marbleSound;
	NSTimeInterval  lastMarbleSoundTime;
	
}
@property (retain, nonatomic) CMMarbleCollisionCollector* collisionCollector;
@property (retain, nonatomic) UIImage* levelBackground, *levelForeground;
@property (retain, nonatomic) CALayer* foregroundLayer, *backgroundLayer;

@property (retain, nonatomic) NSTimer *fireTimer;
@property (assign, nonatomic) IBOutlet NSObject <CMMarbleImageSource,CMGameControllerProtocol> *delegate;
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
@property(nonatomic, assign) NSTimeInterval lastMarbleSoundTime;


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
