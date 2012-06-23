//
//  ATChipmunkLayer.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/8/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ObjectiveChipmunk.h"

@interface CMMarbleLayer : CALayer <ChipmunkObject,NSCopying>
{
	@protected
	ChipmunkBody *body;
	ChipmunkShape *shape;
	CGFloat radius;
	
	NSUInteger touchedShapes;
	BOOL shouldDestroy;
	NSTimeInterval lastSoundTime;
}
@property (assign, nonatomic) BOOL shouldDestroy;
@property (nonatomic) NSUInteger touchedShapes;
@property (readonly,nonatomic) NSArray *chipmunkObjects;
@property (readonly,nonatomic) ChipmunkBody *body;
@property (readonly, nonatomic) ChipmunkShape *shape;
@property (readonly,nonatomic) CGFloat radius;
@property (assign, nonatomic) NSTimeInterval lastSoundTime;
- (id) initWithMass:(CGFloat) mass andRadius:(CGFloat) radius;
- (void) updatePosition;
- (void) destroy;
@end
