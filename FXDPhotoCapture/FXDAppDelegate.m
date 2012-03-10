//
//  FXDAppDelegate.m
//  FXDPhotoCapture
//
//  Created by Peter SHINe on 3/7/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDAppDelegate.h"

@implementation FXDAppDelegate

@synthesize window = _window;

@synthesize captureInterface = _captureInterface;

- (void)dealloc
{
	[_window release];
	[_captureInterface release];
	
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
	
	self.captureInterface = [[[FXDinterfaceCapture alloc] initWithNibName:nil bundle:nil] autorelease];
	
	[self.window setRootViewController:self.captureInterface];
	
    [self.window makeKeyAndVisible];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
}


@end
