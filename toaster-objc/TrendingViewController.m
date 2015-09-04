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
    NSLog(@"trending view loaded");
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"trending ViewWillAppear");
    
//    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
//    _webViewManager.webView.delegate = self;
//    [self.view addSubview: _webViewManager.webView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    NSLog(@"removing from firstVC");
    [_webViewManager removeWebViewFromContainer];
}

@end
