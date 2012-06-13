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
#define MAX_MARBLE_IMAGES 9

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
@synthesize playgroundView, marblePreview,finishView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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


- (void)viewDidLoad
{
  [super viewDidLoad];
	[self loadMarbleImages];
	
	self.marblePreview.image = [self freshImage];
	// Do any additional setup after loading the view, typically from a nib.
		self.playgroundView.layer.masksToBounds = YES;
	[self.playgroundView startSimulation];
	self.finishView.hidden = YES;
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
	return YES;
}

#pragma mark -
#pragma mark Stupid Level handling
- (void) loadLevelImages:(NSString*) levelName
{
	self.playgroundView.levelForeground = [UIImage imageNamed:[NSString stringWithFormat:@"%@-Overlay",levelName]];
	self.playgroundView.levelBackground = [UIImage imageNamed:[NSString stringWithFormat:@"%@-Background",levelName]];
}

- (void) loadLevelStaticBodies:(NSString*) levelName
{
	NSString *fileName = [NSString stringWithFormat:@"%@-StaticBodies",levelName];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"stb"];
	CMSimpleShapeReader *shapeReader = [[CMSimpleShapeReader alloc]initWithContentsOfFile:filePath];
	NSLog(@"Static Shapes: %@",shapeReader.shapes);
	
	ChipmunkBody *staticBody = self.playgroundView.space.staticBody;
	for (ChipmunkShape *shape in shapeReader.shapes) {
		shape.body = staticBody;
		[self.playgroundView.space add:shape];
	}
	[shapeReader release];
}

- (void) loadLevel:(NSUInteger) count
{
	NSString *levelName = [NSString stringWithFormat:@"Level%d",count];
	[self loadLevelImages:levelName];
	[self loadLevelStaticBodies:levelName];
}

#pragma mark -
#pragma mark Actions

- (IBAction)loadLevelAction:(id)sender
{
	[self loadLevel:1];
	
}

- (IBAction)stopSimulation:(id)sender
{
	[self.playgroundView stopSimulation];
}

- (IBAction)startSimulation:(id)sender
{
	[self.playgroundView startSimulation];
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
	[self.playgroundView fireMarbles:100 inTime:10];
}

- (IBAction)thanksAction:(id)sender
{
	self.finishView.hidden = YES;
	[self.playgroundView startSimulation];
}
#pragma mark -
#pragma mark ATImageSource

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
	}
}


@end
