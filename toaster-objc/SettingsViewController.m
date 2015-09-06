//
//  SettingsViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/6/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constants.h"
#import "WebViewManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [_webViewManager removeWebViewFromContainer];
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    
    // Setting delegate for WKWebView
    [[_webViewManager webView] setDelegateViews: self];
    
    [self.view addSubview: _webViewManager.webView];
    
    [_webViewManager useRouterWithPath:SETTINGS_URL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    NSLog(@"parent? %@", parent);
    
    if (parent == nil){
        NSLog(@"go back to profile");
        [_webViewManager useRouterWithPath:PROFILE];
    }
}


@end
