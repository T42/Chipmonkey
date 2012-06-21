//
//  ATAppDelegate.h
//  Chipmonkey
//
//  Created by Carsten Müller on 6/8/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMGameControllerProtocol.h"



@class CMMarbleGameController, CMMarbleLevelSet;

@interface CMAppDelegate : UIResponder <UIApplicationDelegate>
{
	CMMarbleLevelSet *currentLevelSet;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CMMarbleGameController *viewController;

@property(readonly,nonatomic) NSObject<CMGameControllerProtocol> *currentGamecontroller;

-(CMMarbleLevelSet*) currentLevelSet;

@end
