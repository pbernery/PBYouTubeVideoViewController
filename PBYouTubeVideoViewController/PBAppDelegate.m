//
//  PBAppDelegate.m
//  PBYouTubeVideoViewController
//
//  Created by Philippe Bernery on 08/02/13.
//  Copyright (c) 2013 Philippe Bernery. All rights reserved.
//

#import "PBAppDelegate.h"
#import "PBYouTubeVideoViewController.h"

@implementation PBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];

    PBYouTubeVideoViewController *viewController = [[PBYouTubeVideoViewController alloc] initWithVideoId:@"9bZkp7q19f0"];
    self.window.rootViewController = viewController;

    [self.window makeKeyAndVisible];
    return YES;
}

@end
