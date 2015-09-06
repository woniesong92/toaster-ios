//
//  PostsShowViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "PostsShowViewController.h"
#import "RecentViewController.h"
#import "Constants.h"
#import "WebViewManager.h"

@implementation PostsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    [_webViewManager removeWebViewFromContainer];
    
    // Setting delegate for WKWebView
    [[_webViewManager webView] setDelegateViews: self];

    [self.view addSubview: _webViewManager.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated {

    [_webViewManager replaceWebViewWithImage:self :self.parentScreenImage];

    [super viewWillDisappear:animated];
}


- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [_webViewManager replaceImageWithWebView:self];
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    
    if (parent == nil){
        // Decide where to go back to
        
        NSString *currentTab = [_webViewManager getCurrentTab];
        if ([currentTab isEqualToString:RECENT]) {
            [_webViewManager useRouterWithPath:RECENT];
        } else if ([currentTab isEqualToString:TRENDING]) {
            [_webViewManager useRouterWithPath:TRENDING];
        } else if ([currentTab isEqualToString:NOTIFICATIONS]) {
            [_webViewManager useRouterWithPath:NOTIFICATIONS];
        } else if ([currentTab isEqualToString:PROFILE]) {
            [_webViewManager useRouterWithPath:PROFILE];
        } else {
            NSLog(@"ERR: unspecified currentTab");
        }

    }
}

@end

