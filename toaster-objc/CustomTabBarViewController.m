//
//  CustomTabBarViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/7/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "AppDelegate.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.delegate = appDelegate;
    appDelegate.tabBarController = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
