//
//  RRAppDelegate.m
//  Streams
//
//  Created by James Reichley on 3/1/14.
//  Copyright (c) 2014 RadReichley Inc. All rights reserved.
//

#import "RRAppDelegate.h"

#import "RRMainViewController.h"

@implementation RRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
  UIViewController *mainVC = [RRMainViewController new];
  UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:mainVC];
  self.window.rootViewController = navCont;
  
  [self.window makeKeyAndVisible];
  return YES;
}

@end
