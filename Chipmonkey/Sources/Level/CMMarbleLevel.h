//
//  CMMarbleLevel.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/20/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMSimpleShapeReader, CMMarbleLevelSet;

@interface CMMarbleLevel : NSObject
{
	@protected
	UIImage 	*backgroundImage;
	UIImage 	*overlayImage;
	NSString	*name;
	CMSimpleShapeReader * shapeReader;
	NSUInteger numberOfMarbles;

	NSString *backgroundFilename;
	NSString *overlayFilename;
	NSString *staticBodiesFilename;
	
	NSURL		*baseURL;
}

@property (retain, nonatomic) NSString *name;															///< levelname
@property (retain, nonatomic) NSString* backgroundFilename;								///< filename of the background image

@property (retain, nonatomic) NSString* overlayFilename;									///< filename of the overlayimage

@property (retain, nonatomic) NSString* staticBodiesFilename;							///< filename of the statics bodies file

@property (retain, nonatomic) UIImage* backgroundImage;										///< backgroundimage

@property (retain, nonatomic) UIImage* overlayImage;											///< overlayimage

@property(retain, nonatomic) CMSimpleShapeReader *shapeReader;						///< shapeReader

@property (assign, nonatomic) NSUInteger numberOfMarbles;									///< initial number of marbles

///< baseURL for all file operation
@property (retain, nonatomic) NSURL*baseURL;
- (id) initWithDictionary:(NSDictionary*)dict;

@end
