//
//  AppDelegate.m
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "SessionManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)onVerified {
    [SessionManager setVerified];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"emailVerified" object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self initParse:application launchOptions:launchOptions];
    
    return YES;
}

- (void)initParse: (UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"nGWY63hAKCyyMHS41xmjNiL4mCIqsJ0TBGWAG4vy"
                  clientKey:@"w1ps0nxnPNfpJvIGnw52wCl5Og5eOLgiwiuXHn6i"];
    
    // Track opening app
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"Toaster" ];
    self.pushInstallationId = currentInstallation.objectId;

    [currentInstallation saveInBackground];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"url: %@, souce: %@, annot: %@", url, sourceApplication, annotation);
    NSString *urlStr = [url absoluteString];
    if ([urlStr containsString:@"yolk://verified"]) {
        [self onVerified];
    }
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil userInfo:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    NSLog(@"app will entre foreground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



// AppDelegate is the delegate for TabBarController for a reason. Don't move this code to elsewhere
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    NSUInteger tabIndex = [tabBarController.viewControllers indexOfObject:viewController];
    
    if (tabIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ASK_TO_FETCH_POSTS object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:TABLE_SCROLL_TO_TOP object:nil userInfo:nil];
    }
    
    if (tabIndex == NOTIFICATION_TAB_INDEX) {
        [[tabBarController.tabBar.items objectAtIndex:NOTIFICATION_TAB_INDEX] setBadgeValue:0];
    }

    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (UINavigationController*) viewController;
        [navigation popToRootViewControllerAnimated:NO];
    }
}


@end
