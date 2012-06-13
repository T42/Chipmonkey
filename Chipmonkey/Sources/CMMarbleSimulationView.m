//
//  ATSimulationView.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/8/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMMarbleSimulationView.h"
#define MARBLE_RADIUS 20
static NSString *borderType = @"borderType";

#define BORDER_FRICTION   1.0
#define BORDER_ELASTICITY 0.1
#define SPACE_GRAVITY     981.0
#define MARBLE_MASS       20.0

static cpFloat frand_unit(){return 2.0f*((cpFloat)rand()/(cpFloat)RAND_MAX) - 1.0f;}
@implementation CMMarbleSimulationView

@synthesize space, displayLink, preparedLayer,simulatedLayers,touchingMarbles, delegate, fireTimer, levelBackground, levelForeground, foregroundLayer, backgroundLayer;


- (void) createDecorationLayers
{
	self.backgroundLayer = [CALayer layer];
	self.foregroundLayer = [CALayer layer];
	self.backgroundLayer.frame = self.bounds;
	self.foregroundLayer.frame = self.bounds;
	self.foregroundLayer.zPosition = 1.0;
	[self.layer addSublayer:self.foregroundLayer];
}

- (void) initDefaults
{
	[self createDecorationLayers];
	
	self.space = [[[ChipmunkSpace alloc] init] autorelease];
	CGRect newBounds = 	CGRectInset(self.bounds, 0, 0);
	[self.space addBounds:newBounds thickness:20.0 elasticity:BORDER_ELASTICITY friction:BORDER_FRICTION layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
	self.space.gravity = cpv(0.0, SPACE_GRAVITY);
	NSLog(@"Persistance: %u Bias: %f Slope: %f",self.space.collisionPersistence,self.space.collisionBias,self.space.collisionSlop);
  //	self.space.collisionPersistence = 120.0;
  self.space.collisionSlop = 0.01;
	
	[self.space addCollisionHandler:self typeA:[CMMarbleLayer class] typeB:[CMMarbleLayer class]
														begin:@selector(beginMarbleCollision:space:) 
												 preSolve:nil 
												postSolve:nil 
												 separate:@selector(separateMarbleCollision:space:)];
	
	self->simulatedLayers = [[NSMutableArray array]retain];
	self->touchingMarbles = [[NSMutableDictionary dictionary]retain];	
	self.layer.borderWidth =1.0;
	self.layer.borderColor = [[UIColor blackColor]CGColor];
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
	[self->touchingMarbles release];self->touchingMarbles = nil;
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

- (void) removeLevelData
{
	self.levelBackground = nil;
	self.levelForeground = nil;
	for (NSObject<ChipmunkObject> *data in self.space.staticBody.shapes) {
    [self.space remove:data];
	}
[self.space addBounds:self.bounds thickness:20.0 elasticity:BORDER_ELASTICITY friction:BORDER_FRICTION layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
}


- (void) filterSimulatedLayers
{
	BOOL hasRemovedMarbles = NO;
	for (CMMarbleLayer *aLayer in [[[[self.touchingMarbles allKeys]copy]autorelease] 
																	 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
																		 NSUInteger a = [[self.touchingMarbles objectForKey:obj1]count];
																		 NSUInteger b = [[self.touchingMarbles objectForKey:obj2]count];
																		 if (a<b) {
																			 return NSOrderedDescending;
																		 }else if(a>b){
																			 return NSOrderedAscending;
																		 }else {
																			 return NSOrderedSame;
																		 }
																	 }]){
    NSMutableSet *touchingSet = [self.touchingMarbles objectForKey:aLayer];
		if ([touchingSet count]>=2) {
			hasRemovedMarbles = YES;
			for (CMMarbleLayer *depLayer in [touchingSet copy]) {
				[self->touchingMarbles removeObjectForKey:depLayer];
				[self.space remove:depLayer];
				[self->simulatedLayers removeObject:depLayer];
				depLayer.shouldDestroy = YES;
			}
			[self->touchingMarbles removeObjectForKey:aLayer];
			[self.space remove:aLayer];
			[self->simulatedLayers removeObject:aLayer];
			aLayer.shouldDestroy = YES;
		}
	}
	if (hasRemovedMarbles) {
		NSMutableSet *imageSet = [NSMutableSet set];
		for (CMMarbleLayer *aLayer in self.simulatedLayers) {
			[imageSet addObject:aLayer.contents];
		}
		[self.delegate imagesOnField:imageSet];
	}
	
}

- (void) update
{
	cpFloat dt = displayLink.duration*displayLink.frameInterval;
	[space step:dt];
	[self filterSimulatedLayers];
	for (CMMarbleLayer *aLayer in self.simulatedLayers) {
    [aLayer updatePosition];
		if ([self.touchingMarbles objectForKey:aLayer]) {
			aLayer.borderColor=[[UIColor greenColor]CGColor];
      aLayer.borderWidth = 2.0;
		}else{
      
      aLayer.borderWidth = 0.0;
		
		}
	}
}

#pragma mark -
#pragma mark Marbles
-(void) createAnimations:(CMMarbleLayer*) layer
{
	[self createAnimations:layer duration:0.8];
}

-(void) createAnimations:(CMMarbleLayer*) layer duration:(CGFloat) duration
{
  if(layer){
  CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"opacity"];
  an.fromValue = [NSNumber numberWithFloat: 0.0];
  an.toValue = [NSNumber numberWithFloat:1.0];
  an.duration = duration;
  an.delegate = self;
  [layer addAnimation:an forKey:@"shouldDestroy"];
  layer.opacity = 1.0;
  
  CABasicAnimation *na = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  na.fromValue = [NSNumber numberWithFloat:0.010];
  na.toValue = [NSNumber numberWithFloat:1.0];
  na.duration = duration;
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
		self.preparedLayer.position=CGPointMake(self.bounds.size.width/2.0, 40);
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
    return marble1Layer;
}

- (IBAction) createMarble:(id) sender
{
	UIImage *myImage = [self.delegate nextImage];
	if (myImage) {
		CMMarbleLayer *marble1Layer;
        marble1Layer = [self createMarbleLayer:myImage];
		self.preparedLayer =marble1Layer;
		[marble1Layer release];
	}
}


#pragma mark -
#pragma mark Collision Handlers


- (NSMutableSet*) marbleSetFor:(CMMarbleLayer*)layer
{
	NSMutableSet *result = [self.touchingMarbles objectForKey:layer];
	if(!result){
		result = [NSMutableSet set];
		[self->touchingMarbles setObject:result forKey:layer];
	}
	return result;
}

- (void) marble:(CMMarbleLayer*)first releasing:(CMMarbleLayer*) second
{
	NSMutableSet *firstSet = [self marbleSetFor:first];
	NSMutableSet *secondSet = [self marbleSetFor:second];
	
	[firstSet removeObject:second];
	[secondSet removeObject:first];
	
	if ([firstSet count]==0) {
		[self->touchingMarbles removeObjectForKey:first];
	}
	if([secondSet count]==0){
		[self->touchingMarbles removeObjectForKey:second];
	}
}

- (void) marble:(CMMarbleLayer*)first touching:(CMMarbleLayer*)second
{
	NSMutableSet *firstArray = [self marbleSetFor:first];
	NSMutableSet *secondArray= [self marbleSetFor:second];
	
	[firstArray addObject:second];
	[secondArray addObject:first];
}

- (bool) beginMarbleCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space
{
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, firstMarble, secondMarble);
	CMMarbleLayer *firstMarbleLayer = firstMarble.data;
	CMMarbleLayer *secondMarbleLayer = secondMarble.data;
	
	if (firstMarbleLayer.contents == secondMarbleLayer.contents) {
		[self marble:firstMarbleLayer touching:secondMarbleLayer];
	}
	return TRUE;
}

- (void) separateMarbleCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space
{
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, firstMarble, secondMarble);
	CMMarbleLayer *firstMarbleLayer = firstMarble.data;
	CMMarbleLayer *secondMarbleLayer = secondMarble.data;
	
	if (firstMarbleLayer.contents == secondMarbleLayer.contents) {
		[self marble:firstMarbleLayer releasing:secondMarbleLayer];
	}

}
#pragma mark -
#pragma mark Simulation

- (void)simulateLayer:(CMMarbleLayer *)localLayer
{
	[self.space add:localLayer];
	[self->simulatedLayers addObject:localLayer];
	[self.layer addSublayer:localLayer];
	localLayer.borderWidth=0;
}

- (void) startSimulation
{
	self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
	self.displayLink.frameInterval = 1.0;
	[self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
	if(!preparedLayer){
		[self createMarble:nil];
	}
}
- (void) stopSimulation
{
	self.displayLink = nil;
	self.preparedLayer = nil;
}

- (void) resetSimulation
{
	[self stopSimulation];
	[self->touchingMarbles removeAllObjects];
	for (CMMarbleLayer * aLAyer in [[self.simulatedLayers copy]autorelease]) {
    [self.space remove:aLAyer];
		[aLAyer removeFromSuperlayer];
	}
	self.preparedLayer = nil;
	[self->simulatedLayers removeAllObjects];
}

#pragma mark -
#pragma mark Marble Canon

- (void) fireSingleMarble:(NSTimer*) aTimer
{

	UIImage *marbleImage = [self.delegate nextImage];
	CMMarbleLayer *marbleLayer = [self createMarbleLayer:marbleImage];
	[self createAnimations:marbleLayer duration: 0.3];
	CGFloat velX = frand_unit() * 1000;
	CGFloat velY = -fabs(frand_unit() * 1000);
	marbleLayer.body.vel = cpv(velX,velY);
	marbleLayer.position = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/3.0);
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
		ll.x = (p.x - p0.x)*10.;
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

	}
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  //	NSLog(@"ended %@",touches);
}

@end
