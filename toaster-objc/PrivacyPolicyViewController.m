//
//  PrivacyPolicyViewController.m
//  toaster
//
//  Created by Howon Song on 9/15/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "PrivacyPolicyViewController.h"
#import "Constants.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)viewWillAppear:(BOOL)animated {
    [_webViewManager removeWebViewFromContainer];
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    
    [[_webViewManager webView] setDelegateViews: self];
    
    [self.view addSubview: _webViewManager.webView];
    
    [_webViewManager routerGo:PRIVACY];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    // Overshadow my webview with an image just before the transition
    [_webViewManager replaceWebViewWithImage:self :[_webViewManager getWhiteImage]];
    
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // I get rid of the temporary screenshot that was overshadowing my webview
    [_webViewManager replaceImageWithWebView:self];
    
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    if (parent == nil){
        [_webViewManager useRouterWithPath:SETTINGS_URL];
    }
}

@end
