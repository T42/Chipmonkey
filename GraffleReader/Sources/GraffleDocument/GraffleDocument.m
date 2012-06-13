//
//  GraffleDocument.m
//  GraffleReader
//
//  Created by Carsten Müller on 13/01/2009.
//  Copyright T42 Networking 2009 . All rights reserved.
//

#import "GraffleDocument.h"
#import "GraffleWindowController.h"
@interface GraffleDocument (PRIVATE)

@property (readwrite,retain) NSDictionary* graffleData;
@property (readwrite,retain) NSString* dataPath;
@end


@implementation GraffleDocument

@synthesize graffleData = _graffleData,dataPath= _pathToDatafile;

- (id)init
{
  self = [super init];
  if (self) {
    self.graffleData = nil;
    self.dataPath = nil;
  }
  return self;
}

- (void) dealloc
{
  NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
  self.graffleData = nil;
  self.dataPath = nil;

  [super dealloc];
}

- (void) removeWindowController:(NSWindowController*)windowController
{
  [super removeWindowController:windowController];
}

- (NSString *)windowNibName
{
  return @"GraffleDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
  [super windowControllerDidLoadNib:aController];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
  NSLog(@"%@ %@ %@ %p",self, NSStringFromSelector(_cmd),typeName,typeName,outError);
  if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL) readFromURL:(NSURL*)url ofType:(NSString*) typeName error:(NSError**) outError
{
  NSError *ownError = nil;
  NSURL *normalized = [url standardizedURL];
  NSLog(@"%@ %@ %@ %@ %p",self, NSStringFromSelector(_cmd),url,typeName,outError);
  // check if it is a plain file or a Bundle.
  if([normalized isFileURL]){ // we only can handle fileURLs
    NSString *pathToFile = [normalized path];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirectory ;
    if([fm fileExistsAtPath:pathToFile isDirectory:&isDirectory]){
      if(isDirectory){
        pathToFile = [pathToFile stringByAppendingPathComponent:@"data.plist"];
        if(![fm fileExistsAtPath:pathToFile]){
          ownError = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:nil];
          goto theEnd;
        }
      }
      NSData *contentData = [NSData dataWithContentsOfFile:pathToFile options:0 error:&ownError];
      return [self readFromData:contentData ofType:typeName error:outError];
    }else{
      ownError = [NSError errorWithDomain:NSURLErrorDomain code:-2 userInfo:nil];
      goto theEnd;
    }
  }else{
    ownError = [NSError errorWithDomain:NSURLErrorDomain code:-3 userInfo:nil];
  }

theEnd:
  if(outError != nil && ownError != nil)
    *outError = ownError;
    
  return ownError == nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
  NSLog(@"%@ %@ %d %@ %p",self, NSStringFromSelector(_cmd),[data length],typeName,outError);
  NSString *errorString = nil;
  NSDictionary *propList = [NSPropertyListSerialization propertyListFromData:data 
                                                            mutabilityOption:NSPropertyListImmutable 
                                                                      format:nil 
                                                            errorDescription:&errorString];
  
  if(errorString){
    NSLog(@"Error: %@",errorString);
      if ( outError != NULL ) {
        *outError = [NSError errorWithDomain:@"TGraffleReader" code:-1 userInfo:NULL];
      }
    return NO;
  }
  self.graffleData = propList;
  return YES;
}


- (void) makeWindowControllers
{
  GraffleWindowController *gfwc = [[[GraffleWindowController alloc] initWithWindowNibName:[self windowNibName]]autorelease];
  [self addWindowController:gfwc];
}

- (NSArray*) authors
{
  return [(NSDictionary*)[self.graffleData objectForKey:@"UserInfo"] objectForKey:(NSString*)kMDItemAuthors];
}

- (NSArray*) layers
{
  return [_graffleData objectForKey:@"Layers"];
}

- (NSArray*) layernames
{
  NSMutableArray *names = [NSMutableArray array];
  NSArray *layers = [_graffleData objectForKey:@"Layers"];
  NSLog(@"Layers: %@",layers);

  for(NSDictionary* layer in layers){
    [names addObject:[layer objectForKey:@"Name"]];
  }
  return names;
}

- (NSRect) bounds
{
  NSRect bounds = NSRectFromString([[self.graffleData objectForKey:@"BackgroundGraphic"] objectForKey:@"Bounds"]);
  NSLog(@"%@ %@ %@",self,NSStringFromSelector(_cmd),NSStringFromRect(bounds));
  return bounds;
}

- (NSString*) graffleDescription
{
  NSString *result = [NSString stringWithFormat:@"%@ %@",[super description],_graffleData];
  return result;
}
- (NSInteger) indexForLayerWithName:(NSString*) layerName
{
  NSInteger result = -1;
  
  NSArray *layers = [self layers];
  NSInteger counter = 0;
  for(NSDictionary *layer in layers){
    NSString *currentLayerName = [layer objectForKey:@"Name"];
    if([currentLayerName isEqualToString:layerName])
      return counter;
    counter ++;
  }
  return result;
}

- (NSArray*) indicesOfObjectsFromLayerNamed:(NSString*)layerName
{
  NSMutableArray *result = [NSMutableArray array];
  NSInteger layerIndex = [self indexForLayerWithName:layerName];
  NSArray* graphicsObjects = [self.graffleData objectForKey:@"GraphicsList"];
  NSInteger counter = 0;
  for(NSDictionary *go in graphicsObjects){
    NSInteger currentLayer = [[go objectForKey:@"Layer"]intValue];
    if(currentLayer == layerIndex){
      [result addObject:[NSNumber numberWithInt:counter]];
    }
    counter ++;
  }
  return result;
}

#pragma mark -
#pragma mark KVC

- (id) valueForUndefinedKey:(NSString*) key
{
  return [_graffleData valueForKey:key];
}


//- (IBAction) export:(id) sender
//{
//  NSLog(@"%@ %@ %@",self,NSStringFromSelector(_cmd),sender);
//}


@end

@implementation GraffleDocument (PRIVATE)
@dynamic graffleData, dataPath;

- (void) setGraffleData:(NSDictionary*) data
{
  if(_graffleData != data){
    [_graffleData autorelease];
    _graffleData = [data retain];
//    NSLog(@"data: %@",_graffleData);
  }
}

- (void) setDataPath:(NSString*)dataPath
{
  if(![_pathToDatafile isEqualToString:dataPath]){
    [_pathToDatafile autorelease];
    _pathToDatafile = [dataPath retain];
  }
}



@end
