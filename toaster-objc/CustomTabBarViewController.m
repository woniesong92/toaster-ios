//
//  CustomTabBarViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/7/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "SignUpViewController.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.delegate = appDelegate;
    appDelegate.tabBarController = self;
    
    
//    NSArray *navVCs = [self.navigationController viewControllers];
//    for (UIViewController *vc in navVCs) {
//        if ([vc isKindOfClass:[SignUpViewController class]]) {
//            [vc removeFromParentViewController];
//        }
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationReceived:) name:@"pushNotification" object:nil];
}

- (void) myNotificationReceived:(NSNotification *) notification
{

    NSNumber *count = [[notification.userInfo objectForKey:@"aps"] objectForKey:@"badge"];
    NSString *badgeCount = [NSString stringWithFormat:@"%@", count];
    
    [[self.tabBar.items objectAtIndex:NOTIFICATION_TAB_INDEX] setBadgeValue:badgeCount];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
