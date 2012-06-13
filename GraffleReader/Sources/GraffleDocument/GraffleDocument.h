//
//  GraffleDocument.h
//  GraffleReader
//
//  Created by Carsten Müller on 13/01/2009.
//  Copyright T42 Networking 2009 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface GraffleDocument : NSDocument
{
  NSString*     _pathToDatafile;
  NSDictionary* _graffleData;
}

@property (readonly) NSDictionary* graffleData;
@property (readonly) NSString*     dataPath;

- (NSRect) bounds;
- (NSArray*) layers;
- (NSArray*) layernames;

- (NSInteger) indexForLayerWithName:(NSString*) layerName;
- (NSArray*) indicesOfObjectsFromLayerNamed:(NSString*)layerName;


//- (IBAction) export:(id) sender;
@end
