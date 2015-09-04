//
//  PostsShowViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "PostsShowViewController.h"
#import "FirstViewController.h"
#import "AppDelegate.h"
#import "WebViewManager.h"
//#import "Constants.h"

@implementation PostsShowViewController

WebViewManager *webViewManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // This makes the UIWebView full size
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    webViewManager = [WebViewManager getUniqueWebViewManager:self];
    [self.view addSubview: webViewManager.webView];
    webViewManager.webView.delegate = self;
    
//    [webViewManager loadUrlWithString:BASE_URL];
    
//    self.webView.delegate = self;
//    [self.view addSubview:self.webView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // Navigation button was pressed. Do some stuff
        NSLog(@"navigation pressed");

    }
    [super viewWillDisappear:animated];
}

@end

