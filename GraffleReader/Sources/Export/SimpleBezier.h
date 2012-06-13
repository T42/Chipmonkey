//
//  SimpleBezier.h
//  GraffleReader
//
//  Created by Carsten Müller on 09/03/2009.
//  Copyright 2009 T42 Networking. All rights reserved.
//
// Simple Datacontainer for closed bezierpathes. mainly to create a abstract rep. for the pathData 

#if IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif


extern NSString* kBezierPathKey,*kStrokeColorKey,*kFillColorKey;

#if IPHONE
typedef  UIColor* CurrentColor_t;
typedef  CGPathRef CurrentBezier_t;
#else
typedef  NSColor* CurrentColor_t;
typedef NSBezierPath* CurrentBezier_t;
#endif


@interface SimpleBezier : NSObject <NSCoding>{
  NSMutableArray *_points; /// list of NSPoints forming the closed path

  CurrentColor_t _pathColor;
  CurrentColor_t _fillColor;
  CurrentBezier_t _path;

}
@property (retain) NSMutableArray* points;
@property (retain) CurrentColor_t pathColor, fillColor;
#if IPHONE
@property (assign) CurrentBezier_t path;
#else
@property (retain) CurrentBezier_t path;
- (id) initWithBezierDescription:(NSDictionary*)description;
- (SimpleBezier*) flippedForBounds:(NSRect) bounds;
#endif


@end
