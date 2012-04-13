//
//  VYAppDelegate.m
//  State
//
//  Created by Vitaly Yurchenko on 13.04.12.
//  Copyright (c) 2012 Vitaly Yurchenko. All rights reserved.
//
// ********************************************************************************************************************************************************** //

#import "VYAppDelegate.h"

#import "VYStateViewController.h"

// ********************************************************************************************************************************************************** //

@implementation VYAppDelegate

@synthesize window = _window;

#pragma mark -
#pragma mark <UIApplicationDelegate>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    VYStateViewController *rootViewController = [[VYStateViewController alloc] initWithNibName:@"VYStateViewController" bundle:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = rootViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
