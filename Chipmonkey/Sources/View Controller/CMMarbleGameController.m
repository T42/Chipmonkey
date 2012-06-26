//
//  ATViewController.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/8/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMMarbleGameController.h"
#import "CMMarbleSimulationView.h"
#import "CMSimpleShapeReader.h"
#import "CMFunctions.h"
#import "CMSimplePopoverBackground.h"
#import "CMMenuPopoverBackground.h"
#import "CMGameControllerProtocol.h"
#import "CMAppDelegate.h"
#import "CMMarbleLevelSet.h"
#import "CMMarbleLevel.h"
#import "ObjectAL.h"
#import "CMMarbleLevelStatistics.h"

#define MAX_MARBLE_IMAGES 9

#if USE_BILLARD_IMAGES
#define MARBLE_IMAGE_PREFIX @"Ball"
#else
#define MARBLE_IMAGE_PREFIX @"wmarble"
#endif

#define NUM_LEVEL_MARBLES 80

@implementation UIButton (CMMarbleGameHelper)

- (void) setImage:(UIImage *)image
{
  [self setImage:image forState:UIControlStateNormal];
}

- (UIImage*) image
{
  return [self imageForState:UIControlStateNormal];
}

@end

@interface CMMarbleGameController ()
- (void) popupViewController:(CMPopoverContentController*)controller withBackgroundClass:(Class) backgroundClass andRect:(CGRect) rect;
- (void) popupViewController:(CMPopoverContentController*)controller withBackgroundClass:(Class) backgroundClass;
@end



@implementation CMMarbleGameController

@synthesize playgroundView, marblePreview,
levelLabel,currentLevel,levelSet, playerScoreLabel, levelTimeLabel, scoreView,
playerScore, levelTime,
menuController,localPopoverController, levelEndController, levelStartController,
displayLink,lastSimulationTime,lastDisplayTime,frameTime,
playMusic,playSound,musicVolume,soundVolume,
levelStatistics,currentStatistics,comboMarkerView,fourMarkerView,comboHits;

@synthesize timescale,framerate,simulationrate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
  [super viewDidLoad];

	[self loadMarbleImages];
	self.marblePreview = [self freshImage];
	// Do any additional setup after loading the view, typically from a nib.
	self.playgroundView.layer.masksToBounds = YES;
	[self loadLevels];
	self.currentLevel = 0;
	self.frameTime = 1.0/60;
	self->scoreView.hidden = YES;
	self.playSound = YES;
	self.playMusic = NO;
	self.soundVolume = 1.0;
	self.musicVolume = 1.0;
	self.levelStatistics = [NSMutableDictionary dictionary];

}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[self->marbleImages release];
	self->marbleImages = nil;

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[self prepareLevel:self.currentLevel];
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
		return YES;
	return NO;
}

#pragma mark - Marble Image Handling

- (void) loadMarbleImages
{
	NSMutableArray *array = [NSMutableArray array];
  NSUInteger currentLoadIndex = 0;
	for (NSInteger i=9; (i>=1) && (currentLoadIndex < MAX_MARBLE_IMAGES); i--) {
    currentLoadIndex ++;
		NSString *imageName = [NSString stringWithFormat:@"%@_%i",MARBLE_IMAGE_PREFIX,i];
		UIImage *myImage = [UIImage imageNamed:imageName];
		if (myImage) {
			[array addObject:myImage];
		}
	}
	[self->marbleImages autorelease];
	self->marbleImages = [array retain];
}

- (UIImage*) freshImage
{
	NSInteger index = fabs(frand_unit() * [self->marbleImages count]);
	UIImage *newImage = nil;
	if (index <[self->marbleImages count]) {
			newImage = [self->marbleImages objectAtIndex:index];
	}

	return newImage;	
}

#pragma mark - Levels

- (CMMarbleLevelStatistics*) statisticsForLevel:(NSString*) levelName
{
	CMMarbleLevelStatistics *result = [self.levelStatistics objectForKey:levelName];
	if (!result) {
		result = [[[CMMarbleLevelStatistics alloc]init]autorelease];
		[self.levelStatistics setObject:result forKey:levelName];
	}
	return result;
}

- (void) loadLevels
{
	if(!self.levelSet){
		CMAppDelegate *myAppDel= [[UIApplication sharedApplication] delegate];
		self.levelSet = [myAppDel currentLevelSet];
	}
}

- (void) prepareLevel:(NSUInteger) levelIndex
{
	[self resetSimulation:nil];
	CMMarbleLevel *currentL = [self.levelSet.levelList objectAtIndex:levelIndex];
//	if (!currentL.backgroundImage) {
//		[self.playgroundView removeLevelData];
//	}else{
		self.playgroundView.levelBackground = currentL.backgroundImage;
		self.playgroundView.levelForeground = currentL.overlayImage;
		self.playgroundView.staticShapes = currentL.shapeReader.shapes;
//	}
	self.currentStatistics = [self statisticsForLevel:currentL.name];
	[self.currentStatistics reset];
  [self popupViewController:self.levelStartController withBackgroundClass:[CMSimplePopoverBackground class]];
  self.levelStartController.levelname.text =currentL.name;//[NSString stringWithFormat:@"Level - %d",levelIndex];
}

#pragma mark - Properties

- (void) setCurrentLevel:(NSUInteger)cLevel
{
	if (cLevel == -1) {
		cLevel = [self.levelSet.levelList count]-1;
	}
	cLevel = cLevel % ([self.levelSet.levelList count]);
	if(cLevel != self->currentLevel){
		self->currentLevel = cLevel;
	}
}

- (void) setTimescale:(NSUInteger)tscale
{
	[self.playgroundView setTimeScale:1.0/tscale];
}

- (NSUInteger) timescale
{
	return 1.0/self.playgroundView.timeScale;
}

- (void) setFramerate:(NSUInteger)frate
{
	[self setFrameTime:1.0/frate];
	//	[self.playgroundView setF
}
- (NSUInteger) framerate
{
	return 1.0/self.frameTime;
}

- (void) setSimulationrate:(NSUInteger)srate
{
	[self.playgroundView setTimeStep:1.0/srate];
}

- (NSUInteger) simulationrate
{
	return 1.0/self.playgroundView.timeStep;
}

- (void) setPlayerScore:(NSUInteger) score
{
	if (self->playerScore != score) {
		self->playerScore = score;
		self.playerScoreLabel.text = [NSString stringWithFormat:@"%d",self->playerScore];
	}
}

- (void) setLevelTime:(NSTimeInterval)lTime
{
	if (self->levelTime != lTime) {
		self->levelTime = lTime;
		NSInteger min = (NSInteger)(lTime / 60.0);
		NSInteger sec = ((NSInteger)lTime) % 60;
		self->levelTimeLabel.text = [NSString stringWithFormat:@"%2d:%02d",min,sec];
	}
}

- (void) setDisplayLink:(CADisplayLink *)dLink
{
	if (self->displayLink != dLink) {
		[self->displayLink invalidate];
		[self->displayLink autorelease];
		self->displayLink = [dLink retain];
	}
}

#pragma mark - Animation
#define MAX_DT_SIMULATION (1.0/15.0)
#define MAX_DT_FRAMERATE (1.0/10.0)

- (void) markerTimerCallback:(NSTimer*) someTimer
{
	UIView *dataView = [someTimer userInfo];
	dataView.hidden = YES;
}


- (void) marbleThrown
{
	self.comboHits = 0;	
}

- (void) updateStatisticsView
{
	self.playerScoreLabel.text = [NSString stringWithFormat:@"%d",self.currentStatistics.score];
	
	NSInteger min = (NSInteger)(self.currentStatistics.time / 60.0);
	NSInteger sec = ((NSInteger)self.currentStatistics.time) % 60;
	self->levelTimeLabel.text = [NSString stringWithFormat:@"%2d:%02d",min,sec];
	
}

- (void) displayTick:(CADisplayLink*) link
{
  //  cpFloat dt = link.duration*link.frameInterval;
  NSTimeInterval time = link.timestamp;

	NSTimeInterval dt = MIN(time - self.lastSimulationTime, MAX_DT_SIMULATION);
  [self.playgroundView update:dt];

  self.lastSimulationTime = time;

  NSTimeInterval k = MIN(time - self.lastDisplayTime,MAX_DT_FRAMERATE);
	if (k>=self.frameTime) {
		[self.playgroundView updateLayerPositions];
		__block NSUInteger normalHits = 0;
		__block NSUInteger multiHits = 0;
		NSArray *removedMarbles = [self.playgroundView removeCollisionSets];
		[removedMarbles enumerateObjectsUsingBlock:
		 ^(id obj, NSUInteger idx, BOOL* stop){
			 if ([obj count]==3) {
				 normalHits ++;
			 }else if ([obj count]>3) {
				 multiHits ++;
			 }
		 }];
		if (multiHits) {
			self.fourMarkerView.hidden=NO;
			[NSTimer scheduledTimerWithTimeInterval:5 
																			 target:self 
																		 selector:@selector(markerTimerCallback:) 
																		 userInfo:self.fourMarkerView 
																			repeats:NO];
		}
		self.comboHits += [removedMarbles count];
		
		if (self.comboHits>1) {
			if (self.comboMarkerView.hidden) {
				self.comboMarkerView.hidden = NO;
				[NSTimer scheduledTimerWithTimeInterval:5 
																				 target:self 
																			 selector:@selector(markerTimerCallback:) 
																			 userInfo:self.comboMarkerView 
																				repeats:NO];

			}
			self.currentStatistics.score += self.comboHits*10;
			self.comboHits --;
		}

		//		NSUInteger minusMarbles = [self.playgroundView filterSimulatedLayers];

		if (self.lastDisplayTime) {
			self.currentStatistics.time+= (time - self.lastDisplayTime);
		}

		self.currentStatistics.score += (normalHits*3) + (multiHits*6);
		[self updateStatisticsView];
		self.lastDisplayTime = time;		

	}
}

#pragma mark -
#pragma mark Actions


- (IBAction)stopSimulation:(id)sender
{
  self.displayLink = nil;
  [self.playgroundView stopSimulation];
 	[self.playgroundView updateLayerPositions];
}

- (IBAction)startSimulation:(id)sender
{
  self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayTick:)];
	self.displayLink.frameInterval = 1;
	[self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
  [self.playgroundView startSimulation];
}

- (IBAction)resetLevels:(id)sender
{
	[self resetSimulation:sender];
	self.currentLevel = 0;
	[self prepareLevel:self.currentLevel];

}

- (IBAction)resetSimulation:(id)sender
{
  [self stopSimulation:nil];
	[self.playgroundView resetSimulation];
	[self loadMarbleImages];
	self.marblePreview = [self freshImage];
	[self.playgroundView removeLevelData];
	[self startSimulation:nil];
}

- (IBAction)fireMarbles:(id)sender
{
	[self.playgroundView fireMarbles:NUM_LEVEL_MARBLES inTime:10];
}

#pragma mark -

- (IBAction)finishLevel:(id)sender
{
  self.scoreView.hidden = YES;
  self.localPopoverController = nil;
	self.currentLevel = (self.currentLevel +1)%([self.levelSet.levelList count]+1);
	[self prepareLevel:self.currentLevel];
}

- (IBAction)cancelLevel:(id)sender
{
	[self resetSimulation:nil];
	[self startSimulation:nil];
	self.currentLevel = 0;
}

- (IBAction)startLevel:(id)sender
{
  //	self.startView.hidden = YES;
  //  self.localPopoverController = nil;
	self.levelTime = 0.0;
	self.currentStatistics.time = 0.0;
	self.scoreView.hidden = NO;
	[self startSimulation:nil];
	CMMarbleLevel *currentL = [self.levelSet.levelList objectAtIndex:self.currentLevel];
  [self.playgroundView fireMarbles:currentL.numberOfMarbles inTime:10.0];

}
#pragma mark -

- (void) popupViewController:(CMPopoverContentController*)controller withBackgroundClass:(Class) backgroundClass andRect:(CGRect)rect
{
//	if(!self.localPopoverController){
		self.localPopoverController = [[[UIPopoverController alloc]initWithContentViewController:controller]autorelease];
//	}
  self.localPopoverController.contentViewController = controller;
	self.localPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
	self.localPopoverController.popoverBackgroundViewClass = backgroundClass;
	controller.parentPopoverController=self.localPopoverController;
 	[self.localPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:(0) animated:YES];
}

- (void) popupViewController:(CMPopoverContentController*)controller withBackgroundClass:(Class) backgroundClass
{
  [self popupViewController:controller withBackgroundClass:backgroundClass andRect:CGRectMake(0, 0, 1024, 768)];
}

- (IBAction)showMenuBar:(id)sender
{
  [self popupViewController:self.menuController withBackgroundClass:[CMMenuPopoverBackground class] andRect:CGRectMake(0, 0, 1024, 60)];
}


#pragma mark -
#pragma mark CMMarbleImageSource

- (UIImage*) nextImage
{
	UIImage *marbleImage = self.marblePreview;
	self.marblePreview= [self freshImage];;
	return marbleImage;
}

- (UIImage*) marbleGlossImage
{
  return [UIImage imageNamed:@"wmarble_overlay"];
}
- (UIImage*) marbleImageForCGImage:(CGImageRef) imageRef
{
	UIImage *result = nil;
	for (UIImage *t in self->marbleImages) {
    if([t CGImage] == imageRef){
			result = t;
			break;
		}
	}
	return result;
}

- (void) imagesOnField:(NSSet *)images
{
	NSMutableSet *mySet = [NSMutableSet set];
	for (UIImage *loadedImage in self->marbleImages) {
    if (![images member:(id)loadedImage.CGImage]) {
			[mySet addObject:loadedImage];
		}
	}
	for (UIImage * anImage in mySet) {
    [self->marbleImages removeObject:anImage];
		[self.currentStatistics marbleCleared:anImage];
	}
	if(self.playgroundView.preparedLayer){
		UIImage *t = [self marbleImageForCGImage:(CGImageRef)self.playgroundView.preparedLayer.contents];
		if (!t) {
			self.playgroundView.preparedLayer.contents = (id)[[self freshImage] CGImage];
		}
	}
	
	if(![self->marbleImages containsObject:self.marblePreview]){
		self.marblePreview = [self freshImage];
	}
	if (![self->marbleImages count]) {
    //		self.scoreView.hidden = YES;
		[self stopSimulation:nil];
		[self loadMarbleImages];
		self.marblePreview = [self freshImage];
//		[self resetSimulation:nil];
    [self popupViewController:self.levelEndController withBackgroundClass:[CMSimplePopoverBackground class]];
	}
}


@end
