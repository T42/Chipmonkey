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

#define MAX_MARBLE_IMAGES 9

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



@implementation CMMarbleGameController

@synthesize playgroundView, marblePreview,finishView,startView,levelLabel,currentLevel,levelSet,menuController,localPopoverController,displayLink,lastSimulationTime,lastDisplayTime,frameTime;

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
	
	self.marblePreview.image = [self freshImage];
	// Do any additional setup after loading the view, typically from a nib.
	self.playgroundView.layer.masksToBounds = YES;
	[self.playgroundView startSimulation];
	self.finishView.hidden = YES;
	self.startView.hidden = YES;
	[self configureDialogViews];
	[self loadLevels];


	self.currentLevel = 0;
	self.frameTime = 1.0/60;

	[self prepareLevel:self.currentLevel];
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

#pragma mark - Dialog preparation

- (void) configureDialogViews
{
	self.startView.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:.6]CGColor];
	self.startView.layer.cornerRadius = 15;
	self.startView.layer.borderWidth = 2;
	self.startView.layer.backgroundColor = [[UIColor colorWithWhite:0.1 alpha:.9]CGColor];
	
	self.finishView.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:.6]CGColor];
	self.finishView.layer.cornerRadius = 15;
	self.finishView.layer.borderWidth = 2;
	self.finishView.layer.backgroundColor = [[UIColor colorWithWhite:0.1 alpha:.9]CGColor];
}



#pragma mark - Marble Image Handling


- (void) loadMarbleImages
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSInteger i=1; i<MAX_MARBLE_IMAGES+1; i++) {
		NSString *imageName = [NSString stringWithFormat:@"Marble_%i",i];
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
	if (!currentL.backgroundImage) {
		[self.playgroundView removeLevelData];
	}else{
		self.playgroundView.levelBackground = currentL.backgroundImage;
		self.playgroundView.levelForeground = currentL.overlayImage;
		self.playgroundView.staticShapes = currentL.shapeReader.shapes;
	}
	self.startView.hidden = NO;
	self.levelLabel.text = [NSString stringWithFormat:@"Level - %d",levelIndex];
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

#pragma mark - Animation
#define MAX_DT_SIMULATION (1.0/15.0)
#define MAX_DT_FRAMERATE (1.0/10.0)
- (void) displayTick:(CADisplayLink*) link
{
  //  cpFloat dt = link.duration*link.frameInterval;
  NSTimeInterval time = link.timestamp;
	
	NSTimeInterval dt = MIN(time - self.lastSimulationTime, MAX_DT_SIMULATION);
  [self.playgroundView update:dt];

  self.lastSimulationTime = time;

  NSTimeInterval k = MIN(time - self.lastDisplayTime,MAX_DT_FRAMERATE);
	if (k>=self.frameTime) {
		[self.playgroundView filterSimulatedLayers];
		[self.playgroundView updateLayerPositions];
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
	self.marblePreview.image = [self freshImage];
	[self.playgroundView removeLevelData];
	[self startSimulation:nil];
}

- (IBAction)fireMarbles:(id)sender
{
	[self.playgroundView fireMarbles:NUM_LEVEL_MARBLES inTime:10];
}

#pragma mark -

- (IBAction)thanksAction:(id)sender
{
	self.finishView.hidden = YES;
	self.currentLevel = (self.currentLevel +1)%([self.levelSet.levelList count]+1);
	[self prepareLevel:self.currentLevel];
}
- (IBAction)cancelLevel:(id)sender
{
	self.startView.hidden = YES;
	[self resetSimulation:nil];
	[self startSimulation:nil];
	self.currentLevel = 0;
}

- (IBAction)startLevel:(id)sender
{
	self.startView.hidden = YES;
	[self startSimulation:nil];
}
#pragma mark -

- (IBAction)showMenuBar:(id)sender
{
	if(!self.localPopoverController){
		self.localPopoverController = [[[UIPopoverController alloc]initWithContentViewController:self.menuController]autorelease];
	}
	self.localPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
	self.localPopoverController.popoverBackgroundViewClass = [CMMenuPopoverBackground class];
	self.menuController.parentPopoverController=self.localPopoverController;
	[self.localPopoverController presentPopoverFromRect:CGRectMake(0, 0, 1024, 60) inView:self.view permittedArrowDirections:(0) animated:YES];

}


#pragma mark -
#pragma mark CMMarbleImageSource

- (UIImage*) nextImage
{
	UIImage *marbleImage = self.marblePreview.image;
	self.marblePreview.image = [self freshImage];;
	return marbleImage;
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
	}
	if(self.playgroundView.preparedLayer){
		UIImage *t = [self marbleImageForCGImage:(CGImageRef)self.playgroundView.preparedLayer.contents];
		if (!t) {
			self.playgroundView.preparedLayer.contents = (id)[[self freshImage] CGImage];
		}
	}
	
	if(![self->marbleImages containsObject:self.marblePreview.image]){
		self.marblePreview.image = [self freshImage];
	}
	if (![self->marbleImages count]) {
		[self stopSimulation:nil];
		[self loadMarbleImages];
		self.marblePreview.image = [self freshImage];
//		[self resetSimulation:nil];
		self.finishView.hidden = NO;
		[self.view addSubview:self.finishView];
		self.finishView.layer.zPosition = 10;
	}
}


@end
