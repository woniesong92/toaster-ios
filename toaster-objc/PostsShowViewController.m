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

@implementation PostsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // This makes the UIWebView full size
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    _webViewManager.webView.delegate = self;
    [self.view addSubview: _webViewManager.webView];
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
        [_webViewManager.webView goBack];
    }
    [super viewWillDisappear:animated];
    NSLog(@"removing from PostsShow");
    [_webViewManager removeWebViewFromContainer];
}

@end

