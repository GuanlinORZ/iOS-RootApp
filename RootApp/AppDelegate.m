//
//  AppDelegate.m
//  RootApp
//
//  Created by 沈冠林 on 2022/9/9.
//

#import "AppDelegate.h"
#import "RARootViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _rootViewController = [[UINavigationController alloc] initWithRootViewController:[[RARootViewController alloc] init]];
        _window.rootViewController = _rootViewController;
        [_window makeKeyAndVisible];
    return YES;
}



@end
