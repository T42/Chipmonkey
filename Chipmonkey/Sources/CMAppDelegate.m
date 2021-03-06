//
//  ATAppDelegate.m
//  Chipmonkey
//
//  Created by Carsten Müller on 6/8/12.
//  Copyright (c) 2012 Carsten Müller. All rights reserved.
//

#import "CMAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CMMarbleGameController.h"
#import "CMMarbleLevelSet.h"
#import "ObjectAL.h"

@interface CMAppDelegate ()
@property (retain, nonatomic) CMMarbleLevelSet * currentLevelSet;
@end

@implementation CMAppDelegate
@synthesize currentLevelSet;
@synthesize window = _window;
@synthesize viewController = _viewController;

- (void) setupAudio
{
	[OALSimpleAudio sharedInstance].allowIpod = NO;
	[OALSimpleAudio sharedInstance].honorSilentSwitch = YES;
}

- (void)dealloc
{
	[_window release];
	[_viewController release];
	[currentLevelSet release];
	self->currentLevelSet = nil;
	[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// find the current Levelset - this time we only search for the 
	NSBundle *myBundle = [NSBundle mainBundle];
	NSURL *levelSetURL  = [myBundle URLForResource:@"DummyLevels" withExtension:@"levelset"]; 
	CMMarbleLevelSet *levelSet = [[[CMMarbleLevelSet alloc] initWithURL:levelSetURL]autorelease];
	self.currentLevelSet = levelSet;

	
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	// Override point for customization after application launch.
	self.viewController = [[[CMMarbleGameController alloc] initWithNibName:@"CMMarbleGameController" bundle:nil] autorelease];
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	[self setupAudio];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (NSObject<CMGameControllerProtocol>*) currentGamecontroller
{
	return self.viewController;
}



@end
