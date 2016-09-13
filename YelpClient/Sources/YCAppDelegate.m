//
//  AppDelegate.m
//  YelpClient
//
//  Created by Brian Kayfitz on 2016-09-09.
//  Copyright © 2016 Brian Kayfitz. All rights reserved.
//

#import "YCAppDelegate.h"
#import "YCSearchController.h"

@implementation YCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    YCSearchController *searchController = [[YCSearchController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self stylizeNavigationController:navController];

    [self.window setRootViewController:navController];

    return YES;
}

- (void) stylizeNavigationController:(UINavigationController *)navController {
    [navController.navigationBar setBarTintColor:[UIColor colorWithRed:202.0/255.0 green:37.0/255.0 blue:42.0/255.0 alpha:1.0]];
    [navController.navigationBar setTintColor:[UIColor whiteColor]];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    // Makes the Status Bar white
    [navController.navigationBar setBarStyle:UIBarStyleBlack];
}


@end
