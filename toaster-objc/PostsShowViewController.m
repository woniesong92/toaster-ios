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
    UIWebView *webView = self.webView;
    webView.delegate = self;
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    UIWebView *webView = self.webView;
//    webView.delegate = self;
//    [self.view addSubview:self.webView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    UIWebView *webView = self.webView;
//    webView.delegate = self;
//    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// HOW TO PERFORM AN ACTION RIGHT BEFORE GOING BACK TO PREVIOUS PAGE?

@end
