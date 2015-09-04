//
//  TrendingViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "TrendingViewController.h"
#import "Constants.h"

@interface TrendingViewController ()

@end

@implementation TrendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    NSLog(@"trending view loaded");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"trending ViewWillAppear");
    [_webViewManager removeWebViewFromContainer];
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    
    // Setting delegate for WKWebView
    [[_webViewManager webView] setDelegateViews: self];
//    _webViewManager.webView.delegate = self;
    
    [self.view addSubview: _webViewManager.webView];
    
    if (![_webViewManager.getCurrentTab isEqualToString:TRENDING]) {
        [_webViewManager useRouterWithPath:TRENDING];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    NSLog(@"trendingVC viewWillDisappear");
//    [_webViewManager removeWebViewFromContainer];
}

@end
