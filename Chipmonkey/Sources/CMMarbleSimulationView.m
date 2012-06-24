//
//  ATSimulationView.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/8/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMMarbleSimulationView.h"
#import "CMMarbleCollisionCollector.h"
#import "CMFunctions.h"
#import "ObjectAL.h"

#define MARBLE_RADIUS 20
static NSString *borderType = @"borderType";

#define BORDER_FRICTION   1.0f
#define BORDER_ELASTICITY 0.1f
#define SPACE_GRAVITY     981.0f
#define MARBLE_MASS       20.0f
#define MARBLE_SOUND @"marbleKlick.mp3"

#define USE_NEW_COLLISION_DETECTOR 1

@implementation CMMarbleSimulationView

@synthesize space, displayLink, preparedLayer, simulatedLayers, collisionCollector, delegate, fireTimer, 
levelBackground, levelForeground, foregroundLayer, backgroundLayer,accumulator,timeStep,timeScale,
lastMarbleSoundTime;


- (void) createDecorationLayers
{
	self.backgroundLayer = [CALayer layer];
	self.foregroundLayer = [CALayer layer];
	self.backgroundLayer.frame = self.bounds;
	self.foregroundLayer.frame = self.bounds;
	self.foregroundLayer.zPosition = 1.0;
	[self.layer addSublayer:self.foregroundLayer];
}
- (void) setupAudio
{
	// This loads the sound effects into memory so that
	// there's no delay when we tell it to play them.
	[[OALSimpleAudio sharedInstance] preloadEffect:MARBLE_SOUND];
}

- (void) initDefaults
{
	[self createDecorationLayers];
	
	self.space = [[[ChipmunkSpace alloc] init] autorelease];
	CGRect newBounds = 	CGRectInset(self.bounds, 0, 0);
	[self.space addBounds:newBounds thickness:20.0 elasticity:BORDER_ELASTICITY friction:BORDER_FRICTION layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
	self.space.gravity = cpv(0.0, SPACE_GRAVITY);

	NSLog(@"Persistance: %u Bias: %f Slope: %f,iterations %i",self.space.collisionPersistence,self.space.collisionBias,self.space.collisionSlop,self.space.iterations);
//  self.space.collisionPersistence = 10;
//  self.space.collisionSlop = 0.01;
//	self.space.collisionBias=.1;
//	self.space.iterations = 10;	
//	self.space.damping=0.7;
	self.space.sleepTimeThreshold = .50;
	[self.space addCollisionHandler:self typeA:[CMMarbleLayer class] typeB:[CMMarbleLayer class]
														begin:@selector(beginMarbleCollision:space:) 
												 preSolve:nil 
												postSolve:@selector(postMarbleCollision:space:)
												 separate:@selector(separateMarbleCollision:space:)];
	
	self->simulatedLayers = [[NSMutableArray array]retain];
	self.layer.borderWidth =1.0;
	self.layer.borderColor = [[UIColor blackColor]CGColor];
  self.timeStep = 1.0 / 80.0;
  self.timeScale = 1.0;
  self->accumulator = 0.0;
	self.collisionCollector = [[[CMMarbleCollisionCollector alloc] init]autorelease];
	self.collisionCollector.collisionDelay = 0.2;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
			[self initDefaults];
    }
    return self;
}
- (void) dealloc
{
	[self stopSimulation];
	[self->simulatedLayers release];self->simulatedLayers = nil;

	self.space = nil;
	self.displayLink = nil;
	self.preparedLayer = nil;
	self.delegate = nil;
	self.fireTimer = nil;
	self.levelForeground = nil;
	self.levelBackground = nil;
	self.foregroundLayer = nil;
	self.backgroundLayer = nil;
	[super dealloc];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	[self initDefaults];
	return self;
}
- (void) awakeFromNib
{
	[super awakeFromNib];
//	[self initDefaults];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark Properties
- (void) setDisplayLink:(CADisplayLink *)dL
{
	if (self->displayLink != dL) {
		[self->displayLink invalidate];
		[self->displayLink autorelease];
		self->displayLink = [dL retain];
	}
}


- (void) setLevelBackground:(UIImage *)lBackground
{
	if (self->levelBackground != lBackground) {
		[self->levelBackground autorelease];
		self->levelBackground = [lBackground retain];
		self.layer.contents =  (id)[lBackground CGImage];
	}
	
}

- (void) setLevelForeground:(UIImage *)lForeground
{
	if (self->levelForeground != lForeground) {
		[self->levelForeground autorelease];
		self->levelForeground = [lForeground retain];
		self.foregroundLayer.contents = (id) [lForeground CGImage];
	}
}
- (void) setStaticShapes:(NSArray *)staticBodies
{
	ChipmunkBody * staticBody = self.space.staticBody;
	for (ChipmunkShape *shape in staticBodies) {
		shape.body = staticBody;
		[self.space add:shape];
	}
}

- (NSArray*) staticShapes
{
	return self.space.staticBody.shapes;
}



#pragma mark -
#pragma mark Marbles
-(void) createAnimations:(CMMarbleLayer*) layer
{
	[self createAnimations:layer duration:0.8f];
}

-(void) createAnimations:(CMMarbleLayer*) layer duration:(CGFloat) duration
{
  if(layer){
  CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"opacity"];
  an.fromValue = [NSNumber numberWithFloat: 0.0];
  an.toValue = [NSNumber numberWithFloat:1.0];
  an.duration = duration/self.timeScale;
  an.delegate = self;
  [layer addAnimation:an forKey:@"shouldDestroy"];
  layer.opacity = 1.0;
  
  CABasicAnimation *na = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  na.fromValue = [NSNumber numberWithFloat:0.010];
  na.toValue = [NSNumber numberWithFloat:1.0];
  na.duration = duration/self.timeScale;
  na.delegate = self;
  [layer addAnimation:na forKey:@"shouldDestroy2"];
  [layer setValue:[NSNumber numberWithFloat:1.0] forKeyPath:@"transform.scale"];
  }
}


- (void) setPreparedLayer:(CMMarbleLayer *)pL
{
	if (self->preparedLayer != pL) {
		[self->preparedLayer autorelease];
		[self->preparedLayer removeFromSuperlayer];
		self->preparedLayer = [pL retain];
		[self.layer addSublayer:self->preparedLayer];
		self.preparedLayer.position=CGPointMake(self.bounds.size.width/2.0, 30);
    [self createAnimations:self.preparedLayer];
	}
}


- (CMMarbleLayer *)createMarbleLayer:(UIImage *)myImage
{
    CMMarbleLayer *marble1Layer = [[CMMarbleLayer alloc] initWithMass:MARBLE_MASS andRadius:MARBLE_RADIUS];
    CGRect layerRect = CGRectMake(0, 0, MARBLE_RADIUS*2.0, MARBLE_RADIUS*2.0);
    marble1Layer.bounds = layerRect;
    marble1Layer.frame = layerRect;
    marble1Layer.anchorPoint=CGPointMake(0.5, .5);
    marble1Layer.position=CGPointMake(self.bounds.size.width/2.0, MARBLE_RADIUS+5);
    CGImageRef texture = [myImage CGImage];
    marble1Layer.contents = (id)texture;
    return [marble1Layer autorelease];
}

- (IBAction) createMarble:(id) sender
{
	UIImage *myImage = [self.delegate nextImage];
	if (myImage) {
		CMMarbleLayer *marble1Layer;
		marble1Layer = [self createMarbleLayer:myImage];
		self.preparedLayer =marble1Layer;
	}
}


#pragma mark -
#pragma mark Collision Handlers


- (bool) beginMarbleCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space
{
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, firstMarble, secondMarble);
	CMMarbleLayer *firstMarbleLayer = firstMarble.data;
	CMMarbleLayer *secondMarbleLayer = secondMarble.data;
	
	if (firstMarbleLayer.contents == secondMarbleLayer.contents) {
#if USE_NEW_COLLISION_DETECTOR
				[self.collisionCollector object:firstMarbleLayer touching:secondMarbleLayer];
#else
				[self marble:firstMarbleLayer touching:secondMarbleLayer];
#endif
	}

	return TRUE;
}

- (void) postMarbleCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)sp
{
	if (!self.delegate.playSound) {
		return;
	}
	
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, firstMarble, secondMarble);
	CMMarbleLayer *firstMarbleLayer = firstMarble.data;
	CMMarbleLayer *secondMarbleLayer = secondMarble.data;
	if ((self.lastMarbleSoundTime - firstMarbleLayer.lastSoundTime) < 1/2) {
		return;
	}
	
	NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
	if ((currentTime -self.lastMarbleSoundTime)<(1.0f/10.0f)) {
		return;
	}
	cpFloat impulse = cpvlength(cpArbiterTotalImpulseWithFriction(arbiter));
	if (impulse<2500.00) {
		return;
	}

//	NSLog(@"%f,%f,(%f)",self.lastMarbleSoundTime,currentTime,currentTime-self.lastMarbleSoundTime);
	float volume = MIN(impulse/8000.0f, 1.0f);
	volume *= self.delegate.soundVolume;
	if(volume > 0.05f){
		[[OALSimpleAudio sharedInstance] playEffect:MARBLE_SOUND volume:volume pitch:1.0 pan:1.0 loop:NO];
		self.lastMarbleSoundTime = [NSDate timeIntervalSinceReferenceDate];
		firstMarbleLayer.lastSoundTime = self.lastMarbleSoundTime;
		secondMarbleLayer.lastSoundTime = self.lastMarbleSoundTime;
		//		[SimpleSound playSoundWithVolume:volume];
	}

}

- (void) separateMarbleCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space
{
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, firstMarble, secondMarble);
	CMMarbleLayer *firstMarbleLayer = firstMarble.data;
	CMMarbleLayer *secondMarbleLayer = secondMarble.data;
	
	if (firstMarbleLayer.contents == secondMarbleLayer.contents) {
#if USE_NEW_COLLISION_DETECTOR
				[self.collisionCollector object:firstMarbleLayer releasing:secondMarbleLayer];
#else
				[self marble:firstMarbleLayer releasing:secondMarbleLayer];
#endif
	}

}
#pragma mark -
#pragma mark Simulation

- (void)updateLayerPositions
{
	NSArray *touchingMarbles = [self.collisionCollector activeObjects]; 
	for (CMMarbleLayer *aLayer in self.simulatedLayers) {
		[aLayer updatePosition];
		if ([touchingMarbles containsObject:aLayer]) {
			aLayer.borderColor=[[UIColor greenColor]CGColor];
			aLayer.borderWidth = 2.0;
		}else{
			aLayer.borderWidth = 0.0;
		}
	}
}

- (void) update:(NSTimeInterval) dt
{
  //	
	NSTimeInterval fixed_dt = self.timeStep;
	
	self->accumulator += dt*self.timeScale;
	while(self.accumulator > fixed_dt){
    [space step:(CGFloat)fixed_dt];
		self->accumulator -= fixed_dt;
	}
}
- (NSArray*) removeCollisionSets
{
	NSArray *collisionSets = [self.collisionCollector collisionSetsWithMinMembers:3];
	NSMutableSet *alreadyRemoved = [NSMutableSet set];
	for (NSSet *colSet in [collisionSets sortedArrayUsingComparator:
												 ^NSComparisonResult(id obj1, id obj2){
													 NSUInteger a = [obj1 count];
													 NSUInteger b = [obj2 count];
													if(a<b){return NSOrderedAscending;}
													 if(a>b){return NSOrderedDescending;}
													 return NSOrderedSame;
												 }])
	{
		NSLog(@"Length: %d",[colSet count]);
		for (CMMarbleLayer* layer in colSet) {
			if (![alreadyRemoved containsObject:layer]) {
				[alreadyRemoved addObject:layer];
				//				NSLog(@"Remove: %@",layer);
				[self.space remove:layer];

				[self->simulatedLayers removeObject:layer];
				layer.shouldDestroy = YES;
				[self.collisionCollector removeObject:layer];
			}else {
				NSLog(@"Possible 4");
			}
		}
	}
	if ([alreadyRemoved count]) {
		NSMutableSet *imageSet = [NSMutableSet set];
		for (CMMarbleLayer *aLayer in self.simulatedLayers) {
			[imageSet addObject:aLayer.contents];
		}
		[self.delegate imagesOnField:imageSet];
		NSLog(@"---\r");
	}
	
	[self.collisionCollector cleanupFormerCollisions];
	return collisionSets;
}

- (NSUInteger) filterSimulatedLayers
{
	NSUInteger removedMarbles=0;
	NSArray *p = [self removeCollisionSets];
	NSMutableSet *testSet  = [NSMutableSet set];
	for (NSSet *t in p) {
    [testSet addObjectsFromArray:[t allObjects]];
		removedMarbles += [t count];
	}
	
	if (removedMarbles != [testSet count]) {
		NSLog(@"Count missmatch (double hits) sets: %d, test:%d",removedMarbles,[testSet count]);
	}
	return removedMarbles;
}


- (void)simulateLayer:(CMMarbleLayer *)localLayer
{
	[self.space add:localLayer];
	[self->simulatedLayers addObject:localLayer];
	[self.layer addSublayer:localLayer];
	localLayer.borderWidth=0;
}

- (void) startSimulation
{
	if(!preparedLayer){
		[self createMarble:nil];
	}
}
- (void) stopSimulation
{

	self.preparedLayer = nil;
}

- (void) resetSimulation
{
	[self stopSimulation];
	[self.collisionCollector reset];
	for (CMMarbleLayer * aLAyer in [[self.simulatedLayers copy]autorelease]) {
    [self.space remove:aLAyer];
		[aLAyer removeFromSuperlayer];
	}
	self.preparedLayer = nil;
	[self->simulatedLayers removeAllObjects];
}

- (void) removeLevelData
{
	self.levelBackground = nil;
	self.levelForeground = nil;
	for (NSObject<ChipmunkObject> *data in self.space.staticBody.shapes) {
    [self.space remove:data];
	}
	CGRect b = self.bounds;
//	b.size.height -=60;
  [self.space addBounds:b thickness:20.0 elasticity:BORDER_ELASTICITY friction:BORDER_FRICTION layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
}


#pragma mark -
#pragma mark Marble Canon

- (void) fireSingleMarble:(NSTimer*) aTimer
{
	UIImage *marbleImage = [self.delegate nextImage];
	CMMarbleLayer *marbleLayer = [self createMarbleLayer:marbleImage];
	[self createAnimations:marbleLayer duration: 0.3f];
	CGFloat velX = frand_unit() * 1000;
	CGFloat velY = (CGFloat)-fabs(frand_unit() * 1000);
	marbleLayer.body.vel = cpv(velX,velY);
	marbleLayer.position = CGPointMake(self.bounds.size.width/2.0, 200);
	self->marblesToFire--;
	if (marblesToFire == 0) {
		[aTimer invalidate];
		self.fireTimer = nil;
	}
	[self simulateLayer:marbleLayer];
}

- (void) fireMarbles:(NSUInteger)numOfMarbles inTime:(CGFloat)seconds
{
	if(!self.fireTimer){
		CGFloat marbleCadenz = seconds/numOfMarbles;
		self->marblesToFire = numOfMarbles;
		NSTimer *marbleTimer = [NSTimer scheduledTimerWithTimeInterval:marbleCadenz target:self selector:@selector(fireSingleMarble:) userInfo:nil repeats:YES];
		self.fireTimer = marbleTimer;	
	}
}


#pragma mark -
#pragma mark Responder

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self->fireTimer) {
		return;
	}
	if(!self.preparedLayer){
		[self createMarble:nil];
	}
	if (self.preparedLayer) {
		NSArray *t = touches.allObjects;
		UITouch *k =[t objectAtIndex:0];
		CGPoint p = [k locationInView:self];
		p.y = self.preparedLayer.position.y;
		self.preparedLayer.position = p;
	}
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"moved %@ %@",touches,event);
	if (self.preparedLayer) {
		NSArray *t = touches.allObjects;
		UITouch *k =[t objectAtIndex:0];
		CGPoint p = [k locationInView:self];
		CGPoint p0 = [k previousLocationInView:self];
		p.y = self.preparedLayer.position.y;
		self.preparedLayer.position = p;

		cpVect ll =  self.preparedLayer.body.vel;
		ll.x = (p.x - p0.x)*12.0f;
		self.preparedLayer.body.vel = ll;
	}
	
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//		NSLog(@"ended %@",touches);
	if (self.preparedLayer) {
		CMMarbleLayer *localLayer = self.preparedLayer;
		self.preparedLayer = nil;
		[self simulateLayer:localLayer];	
    [self createMarble:nil];
		[self.delegate marbleThrown];

	}
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  //	NSLog(@"ended %@",touches);
}

@end
