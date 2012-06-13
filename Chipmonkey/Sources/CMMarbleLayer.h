//
//  ATChipmunkLayer.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/8/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ObjectiveChipmunk.h"

@interface CMMarbleLayer : CALayer <ChipmunkObject>
{
	@protected
	ChipmunkBody *body;
	ChipmunkShape *shape;
	NSArray *chipmunkObjects;
	CGFloat radius;
	
	NSUInteger touchedShapes;
	BOOL shouldDestroy;
}
@property (assign, nonatomic) BOOL shouldDestroy;
@property (nonatomic) NSUInteger touchedShapes;
@property (readonly,nonatomic) NSArray *chipmunkObjects;
@property (readonly,nonatomic) ChipmunkBody *body;
@property (readonly, nonatomic) ChipmunkShape *shape;
@property (readonly,nonatomic) CGFloat radius;
- (id) initWithMass:(CGFloat) mass andRadius:(CGFloat) radius;
- (void) updatePosition;
- (void) destroy;
@end
