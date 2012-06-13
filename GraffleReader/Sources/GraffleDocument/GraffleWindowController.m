//
//  GraffleWindowController.m
//  GraffleReader
//
//  Created by Carsten Müller on 19/01/2009.
//  Copyright 2009 T42 Networking. All rights reserved.
//

#import "GraffleWindowController.h"
#import "PropertyInfoViewController.h"
#import "GraffleBezierViewController.h"
#import "GraffleBezierFactory.h"
#import "GraffleDocument.h"
#import "SimpleBezier.h"

@implementation GraffleWindowController
@synthesize currentViewController = _currentViewController, targetView = _targetView,
            viewSelector = _viewSelector;


- (id) retain 
{
  return [super retain];
}

- (void) dealloc
{
  NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
  self.currentViewController = nil;
  self.targetView = nil;
  self.viewSelector = nil;
  [super dealloc];
}

- (void) awakeFromNib
{
  NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));  
  // initialize the initaly used contentView
  [self switchContentView:_viewSelector];
}
- (IBAction) analyseGraffleData:(id) sender
{
  NSLog(@"%@ %@ %@",self,NSStringFromSelector(_cmd),sender);
}

- (IBAction) switchContentView:(id) sender
{
  NSInteger tag = [[sender selectedItem] tag];
  NSLog(@"%@ %@ %@ (%d)",self,NSStringFromSelector(_cmd),sender,tag);  
  [[self.currentViewController view] removeFromSuperview];
  switch(tag){
    case 0:
    {
      PropertyInfoViewController * propViewController = [[[PropertyInfoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
      self.currentViewController = propViewController;
      [propViewController setRepresentedObject:self.document];
      break;
    }
    case 1:
    {
      GraffleBezierViewController *gbv = [[[GraffleBezierViewController alloc] initWithNibName:nil bundle:nil]autorelease];
      [gbv loadView];
      self.currentViewController = gbv;
      [gbv setRepresentedObject:self.document];
      break;
    }
    default:
    {
      break;
    }
  }
  [self.targetView addSubview:[self.currentViewController view]];
  [[self.currentViewController view] setFrame: [self.targetView bounds]];
}


- (NSArray*) objectsOnLayer:(NSString*)layerName
{
  GraffleBezierFactory *gbf = [[[GraffleBezierFactory alloc] initWithDocument:self.document] autorelease];
  NSArray *indices = [(GraffleDocument*)self.document indicesOfObjectsFromLayerNamed:layerName];
  NSMutableArray *objects = [NSMutableArray array];
  for(NSNumber * index in indices){   
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver setOutputFormat:NSPropertyListXMLFormat_v1_0];
    SimpleBezier *bp = [gbf bezierPathForComponentAtIndex:[index intValue]];
    bp = [bp flippedForBounds:[self.document bounds]];
    [bp encodeWithCoder:archiver];
    [archiver finishEncoding];
    [objects addObject:data];
  }
  return objects;
}

- (IBAction) export:(id) sender
{
  NSMutableDictionary* mapDescription = [NSMutableDictionary dictionary];  
  NSLog(@"%@ %@ %@",self,NSStringFromSelector(_cmd),sender);
  [mapDescription setObject:[self objectsOnLayer:@"Ground"] forKey:@"Ground"];
  [mapDescription setObject:[self objectsOnLayer:@"Water"] forKey:@"Water"];
  [mapDescription setObject:[self objectsOnLayer:@"Islands"] forKey:@"Islands"];
  [mapDescription setObject:[self objectsOnLayer:@"Buoys"] forKey:@"Buoys"];
  NSRect mapBounds = [self.document bounds] ;
  
  [mapDescription setObject:NSStringFromRect(mapBounds) forKey:@"Size"];
  NSString *errorDescription;
  NSData *output =[NSPropertyListSerialization dataFromPropertyList:mapDescription
                                                             format:NSPropertyListXMLFormat_v1_0
                                                   errorDescription:&errorDescription];

  NSSavePanel *panel = [NSSavePanel savePanel];
  int k = [panel runModalForDirectory:@"~/Desktop" file:@"Blubberlutsch.tmap"];
  if(k == NSFileHandlingPanelOKButton){
    [output writeToFile:[panel filename] atomically:NO];
  }
}

@end
