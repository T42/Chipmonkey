//
//  CMSimpleLevel.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/13/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMSimpleLevel.h"
#import "CMSimpleShapeReader.h"
@interface CMSimpleLevel ()
- (NSString*) backgroundImagePathFromIndex:(NSUInteger)index;
- (NSString*) overlayImagePathFromIndex:(NSUInteger)index;
- (NSString*) staticBodiesPathFromIndex:(NSUInteger)index;
- (UIImage*) readImageFromPath:(NSString*)path;
@end

@implementation CMSimpleLevel
@synthesize backgroundImagePath, backgroundImage,overlayImagePath, overlayImage, staticBodiesPath, shapeReader,index;

- (id) init
{
	if ((self = [super init])) {
		self.index = -1;
		self.backgroundImagePath = nil;
		self.overlayImagePath = nil;
		self.staticBodiesPath = nil;
	}
	return self;
}

- (id) initWithLevelNumber:(NSUInteger)levelIndex
{
	
	if((self = [super init])){
		self.index = levelIndex;
		self.backgroundImagePath = [self backgroundImagePathFromIndex:self.index];
		self.overlayImagePath = [self overlayImagePathFromIndex:self.index];
		self.staticBodiesPath = [self staticBodiesPathFromIndex:self.index];
	}
	return self;
}
- (void) dealloc
{
	self.index = -1;
	self.backgroundImagePath = nil;
	self.overlayImagePath = nil;
	self.backgroundImage = nil;
	self.overlayImage = nil;
	self.staticBodiesPath = nil;
	self.shapeReader = nil;
	[super dealloc];
}
#pragma mark -
#pragma mark Properties

- (UIImage*) backgroundImage
{
	if(!self->backgroundImage){
		self.backgroundImage = [self readImageFromPath:self.backgroundImagePath];
	}
	return self->backgroundImage;
}

- (UIImage*) overlayImage
{
	if(!self->overlayImage){
		self.overlayImage = [self readImageFromPath:self.overlayImagePath];
	}
	return self->overlayImage;
}

- (void) setStaticBodiesPath:(NSString *)sBP
{
	if(sBP != self->staticBodiesPath){
		[self->staticBodiesPath autorelease];
		self->staticBodiesPath = [sBP retain];
		if (self->staticBodiesPath) {
			self.shapeReader = [[[CMSimpleShapeReader alloc]initWithContentsOfFile:self->staticBodiesPath]autorelease];
		}else{
			self.shapeReader = nil;
		}
	}
}

#pragma mark -
#pragma mark Helpers

- (NSString*) levelPrefixForIndex:(NSUInteger)idx
{
	return [NSString stringWithFormat:@"Level%d-",idx];
}

- (NSString*) backgroundImagePathFromIndex:(NSUInteger)idx
{
	NSBundle *mb = [NSBundle mainBundle];
	NSString *result;
	NSString *prefix = [self levelPrefixForIndex:idx];
	result = [NSString stringWithFormat:@"%@Background",prefix];
	result = [mb pathForResource:result ofType:@"png"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:result])
		return nil;
	return result;
}

- (NSString*) overlayImagePathFromIndex:(NSUInteger)idx
{
		NSBundle *mb = [NSBundle mainBundle];
	NSString *result;
	NSString *prefix = [self levelPrefixForIndex:idx];
	result = [NSString stringWithFormat:@"%@Overlay",prefix];
	result = [mb pathForResource:result ofType:@"png"];

	if(![[NSFileManager defaultManager] fileExistsAtPath:result])
		return nil;

	return result;
}
- (NSString*) staticBodiesPathFromIndex:(NSUInteger)idx
{
	NSBundle *mb = [NSBundle mainBundle];
	NSString *result;
	NSString *prefix = [self levelPrefixForIndex:idx];
	result = [NSString stringWithFormat:@"%@StaticBodies",prefix];
	result = [mb pathForResource:result ofType:@"stb"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:result])
		return nil;
	return result;
}

- (UIImage*) readImageFromPath:(NSString *)path
{
	return [UIImage imageWithContentsOfFile:path];
}

#pragma mark -
#pragma mark Class Methods

+ (NSUInteger) maxLevelIndex
{
//	NSString *resourcePath = [[NSBundle mainBundle]resourcePath];
//	NSFileManager *fm = [NSFileManager defaultManager];
//	NSError *resultError = nil;
//	NSArray *allFiles = [fm contentsOfDirectoryAtPath:resourcePath error:&resultError];
//	allFiles = nil;
	// search for levels here
	return 2;
}

@end
