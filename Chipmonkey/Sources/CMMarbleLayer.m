//
//  ATChipmunkLayer.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/8/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMMarbleLayer.h"
#define MARBLE_FRICTION   .9
#define MARBLE_ELASTICITY .2

@implementation CMMarbleLayer

@synthesize chipmunkObjects, body, shape, radius ,touchedShapes, shouldDestroy,lastSoundTime;

- (ChipmunkShape *) circleShapeWithBody:(ChipmunkBody*) b andRadius:(CGFloat) r
{
	ChipmunkShape *shp = [ChipmunkCircleShape circleWithBody:b radius:r offset:cpv(0, 0)];
	shp.collisionType = [self class];
	shp.data = self;
	shp.friction=MARBLE_FRICTION;
	shp.elasticity=MARBLE_ELASTICITY;
	return shp;
}

- (ChipmunkBody*) circleBodyWithMass:(CGFloat)mass andRadius:(CGFloat) r
{
	cpFloat moment = cpMomentForCircle(mass, 0, r, cpv(0, 0));
	return [ChipmunkBody bodyWithMass:mass andMoment:moment];
}

- (void) initDefaults
{
	[self setRadius:1.0];
	[self setBody:[self circleBodyWithMass:1.0 andRadius:self.radius]];
	[self setShape:[self circleShapeWithBody:self.body andRadius:self.radius]];
	self.borderWidth = 2;
	self.borderColor = [[UIColor redColor]CGColor];
}

- (id) init
{
	if((self = [super init])){
		[self initDefaults];
	}
	return self;	
}

- (id) initWithMass:(CGFloat) mass andRadius:(CGFloat) r
{
	if ((self = [super init])) {
		[self setRadius:r];
		[self setBody:[self circleBodyWithMass:mass andRadius:self.radius]];
		[self setShape:[self circleShapeWithBody:self.body andRadius:self.radius]];
		self.borderColor = [[UIColor redColor]CGColor];
		self.borderWidth = 2;
    self.cornerRadius=self.radius;
	}
	return self;
}

- (void) dealloc
{
	[self setBody:nil];
	self.shape.body = nil;
	[self setShape:nil];
	[self->chipmunkObjects release];
//	[self setChipmunkObjects:nil];

	[super dealloc];	
}

- (NSArray*) chipmunkObjects
{
	return [NSArray arrayWithObjects:self.body,self.shape, nil];
}

#pragma mark -
#pragma mark Properties

- (void) setPosition:(CGPoint)position
{
	[super setPosition:position];
	self.body.pos = position;
}

- (void) setRadius:(CGFloat)r
{
	if (self->radius != r) {
			self->radius = r;
//		[self setShape:[self circleShapeWithBody:self.body andRadius:r]];
	}

}
- (void) setBody:(ChipmunkBody *)b
{
	if(self->body != b){
		[self->body autorelease];
		self->body = [b retain];
	}
}

- (void) setShape:(ChipmunkShape *)s
{
	if(self->shape != s){
		[self->shape autorelease];
		self->shape = [s retain];
	}
}

//- (void) setChipmunkObjects:(NSArray *)cO
//{
//	if (self->chipmunkObjects != cO) {
//		[self->chipmunkObjects autorelease];
//		self->chipmunkObjects = [cO retain];
//	}
//}


- (void) setShouldDestroy:(BOOL)sD
{
	if (sD) {
		self->shouldDestroy = sD;
		CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"opacity"];
		an.fromValue = [NSNumber numberWithFloat: 1.0];
		an.toValue = [NSNumber numberWithFloat:0.0];
		an.duration = .3;
		an.delegate = self;
		[self addAnimation:an forKey:@"shouldDestroy"];
		self.opacity = 0.0;
		
		CABasicAnimation *na = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		na.fromValue = [NSNumber numberWithFloat:1.0];
		na.toValue = [NSNumber numberWithFloat:0.010];
		na.duration = .3;
		na.delegate = self;
		[self addAnimation:na forKey:@"shouldDestroy2"];
		[self setValue:[NSNumber numberWithFloat:0.010f] forKeyPath:@"transform.scale"];
	
	}
}
- (void) layoutSublayers
{
	[super layoutSublayers];
	self.body.pos = cpv(self.position.x,self.position.y);
  //	NSLog(@"Layout called");
}

- (void) updatePosition
{
//	NSLog(@"transform: %@",NSStringFromCGAffineTransform(self.body.affineTransform));
	//self.affineTransform = CGAffineTransformTranslate(self.body.affineTransform,0,0);
	self.position = self.body.pos;
//	NSLog(@"Position: %@,%@",NSStringFromCGPoint(self.position),NSStringFromCGPoint(self.body.pos));
	CGFloat angle = (CGFloat)(self.body.angle*180.0/M_PI);
	NSInteger t = (int)angle % 360;
//	NSLog(@"%i",t);
	
	CGAffineTransform trans = CGAffineTransformMakeRotation((CGFloat)(t*M_PI/180.0));
	self.affineTransform = trans;
}

- (id <CAAction>) actionForKey:(NSString *)event
{
	if ([event isEqualToString:@"shouldDestroy"]) {
		CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"opacity"];
		an.fromValue = [NSNumber numberWithFloat: 1.0];
		an.toValue = [NSNumber numberWithFloat:0.0];
		an.duration = 10;
		an.delegate = self;
		return an;
	}	
	return nil;
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  //	NSLog(@"finished: %i",flag);
	[self removeFromSuperlayer];
}

//- (void) setTouchedShapes:(NSUInteger)tS
//{
//	if(tS != self->touchedShapes){
//		self->touchedShapes = tS;
//	}
//	if (self->touchedShapes!=0) {
//		self.backgroundColor = [[UIColor redColor]CGColor];
//	}else{
//		self.backgroundColor = nil;
//	}
//}
- (void) destroy
{
	
}
#pragma mark -
#pragma mark NSCopying

- (id) copyWithZone:(NSZone*) zone
{
	return [self retain];
}

#pragma mark -
#pragma mark ChipmunkObject

@end
