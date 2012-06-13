//
//  GraffleBezierFactory.h
//  GraffleReader
//
//  Created by Carsten Müller on 19/01/2009.
//  Copyright 2009 T42 Networking. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GraffleDocument, SimpleBezier;


@interface GraffleBezierFactory : NSObject {
  GraffleDocument*  _graffleDocument;
}


@property(assign) GraffleDocument* graffleDocument;

- (id) initWithDocument:(GraffleDocument*)document;
- (SimpleBezier*) bezierPathForComponentAtIndex:(NSUInteger)index;
@end


NSPoint shiftPointByPoint(NSPoint p, NSPoint o);
NSPoint scalePointBySize(NSPoint p, NSSize s);
NSPoint unflipPointForRect(NSPoint p,NSRect b);

