//
//  CMMarbleLevelStartController.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/21/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopoverContentController.h"
@interface CMMarbleLevelStartController : CMPopoverContentController
{
  UILabel *title;
  UILabel *levelname;
}
@property (retain,nonatomic) IBOutlet UILabel* title;
@property (retain,nonatomic) IBOutlet UILabel *levelname;

- (IBAction)playLevel:(id)sender;
@end
