//
//  PostsShowViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "PostsShowViewController.h"
#import "AppDelegate.h"
//#import "Constants.h"

@implementation PostsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"PostsSHow View did load");
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [self.viewContainer addSubview: appDelegate.singleWebView];
    
    [self.view addSubview:appDelegate.singleWebView];
    
    NSLog(@"PostsSHowVIew will Appear, is Webview ready?");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
