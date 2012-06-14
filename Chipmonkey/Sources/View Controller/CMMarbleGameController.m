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
#import "CMSimpleLevel.h"
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

static cpFloat frand_unit(){return 2.0f*((cpFloat)rand()/(cpFloat)RAND_MAX) - 1.0f;}

@implementation CMMarbleGameController

@synthesize playgroundView, marblePreview,finishView,startView,levelLabel,levelLimit,currentLevel,levels,menuController;

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
	self.levelLimit = [CMSimpleLevel maxLevelIndex];
	self.currentLevel = 0;
	[self loadLevels];
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
	// Return YES for supported orientations
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
	if(!self.levels){
		self.levels = [NSMutableArray array];
	}
	
	for (NSUInteger i=0; i<(self.levelLimit+1); i++) {
		CMSimpleLevel *sl = [[[CMSimpleLevel alloc]initWithLevelNumber:i]autorelease];
		if (sl) {
			[self.levels addObject:sl];
		}
	}
}

- (void) prepareLevel:(NSUInteger) levelIndex
{
	[self resetSimulation:nil];
	CMSimpleLevel *currentL = [self.levels objectAtIndex:levelIndex];
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



#pragma mark -
#pragma mark Actions


- (IBAction)stopSimulation:(id)sender
{
	[self.playgroundView stopSimulation];
}

- (IBAction)startSimulation:(id)sender
{
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
	[self.playgroundView stopSimulation];
	[self.playgroundView resetSimulation];
	[self loadMarbleImages];
	self.marblePreview.image = [self freshImage];
	[self.playgroundView removeLevelData];
	[self.playgroundView startSimulation];
}

- (IBAction)fireMarbles:(id)sender
{
	[self.playgroundView fireMarbles:NUM_LEVEL_MARBLES inTime:10];
}

#pragma mark -

- (IBAction)thanksAction:(id)sender
{
	self.finishView.hidden = YES;
	self.currentLevel = (self.currentLevel +1)%(self.levelLimit+1);
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
	[self presentModalViewController:self.menuController animated:YES];
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
