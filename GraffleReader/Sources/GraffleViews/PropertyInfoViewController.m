//
//  PropertyInfoView.m
//  GraffleReader
//
//  Created by Carsten Müller on 19/01/2009.
//  Copyright 2009 T42 Networking. All rights reserved.
//

#import "PropertyInfoViewController.h"


@implementation PropertyInfoViewController


- (void) awakeFromNib
{
  NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
}

- (NSString*) nibName
{
  return @"PropertyInfoView";
}
@end
