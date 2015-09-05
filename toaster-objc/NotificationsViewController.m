//
//  NotificationsViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/4/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "NotificationsViewController.h"
#import "Constants.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_webViewManager removeWebViewFromContainer];
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    
    // Setting delegate for WKWebView
    [[_webViewManager webView] setDelegateViews: self];
    
    [self.view addSubview: _webViewManager.webView];
    
    if (![_webViewManager.getCurrentTab isEqualToString:NOTIFICATIONS]) {
        [_webViewManager useRouterWithPath:NOTIFICATIONS];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}


@end
