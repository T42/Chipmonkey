//
//  CMSimpleLevel.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/13/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMSimpleShapeReader;

@interface CMSimpleLevel : NSObject
{
	@protected
	NSUInteger index;
	NSString *backgroundImagePath;
	NSString *overlayImagePath;
	NSString *staticBodiesPath;
}

@property(retain, nonatomic) NSString *backgroundImagePath, *overlayImagePath, *staticBodiesPath;

@property(retain, nonatomic) UIImage *backgroundImage, *overlayImage;
@property(retain, nonatomic) CMSimpleShapeReader *shapeReader;
@property(assign, nonatomic) NSUInteger index;
- (id) initWithLevelNumber:(NSUInteger) levelIndex;

+(NSUInteger) maxLevelIndex;

@end
