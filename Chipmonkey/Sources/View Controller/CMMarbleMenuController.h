//
//  CMMarbleMenuController.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/14/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMMarbleMenuController : UIViewController

- (IBAction)menuAction:(UISegmentedControl*)sender;
- (IBAction) selectLevel:(id)sender;
- (IBAction) openOptions:(id) sender;
- (IBAction) resetProgress:(id)sender;
@end
