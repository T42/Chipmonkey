//
//  GraffleWindowController.h
//  GraffleReader
//
//  Created by Carsten Müller on 19/01/2009.
//  Copyright 2009 T42 Networking. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GraffleWindowController : NSWindowController {
  IBOutlet NSView         * _targetView;
  NSViewController        * _currentViewController;
  IBOutlet NSPopUpButton  * _viewSelector;
}

@property (retain) NSViewController *currentViewController;
@property (assign) NSView *targetView;
@property (assign) NSPopUpButton *viewSelector;

- (IBAction) switchContentView:(id) sender;
- (IBAction) analyseGraffleData:(id) sender;
- (IBAction) export:(id) sender;
@end
