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
#import "SessionManager.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Register tabbar controller
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.delegate = appDelegate;
    appDelegate.tabBarController = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationReceived:) name:@"pushNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"view did appear");

    // Check if the user is logged in
//    [SessionManager checkSessionAndRedirect:@"TabBarToSignUpSegue" sender:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"tabbarcontroller view will appear");
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
