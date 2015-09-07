//
//  CustomTabBarViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/7/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "CustomTabBarViewController.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"tabbar controller initiated");
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (UINavigationController*) viewController;
        [navigation popToRootViewControllerAnimated:NO];
    }
}


@end
