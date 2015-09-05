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
    
    NSLog(@"PostsShowViewWillAppear");
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    [_webViewManager removeWebViewFromContainer];
    
    // Setting delegate for WKWebView
    [[_webViewManager webView] setDelegateViews: self];
    [self.view addSubview: _webViewManager.webView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        // "Back" button was pressed from Navigation bar
        // We have to make webview go back one page
//        NSLog(@"will call goback");
//        [_webViewManager useRouterWithPath:RECENT];
//        [_webViewManager.webView goBack];
    }

    [super viewWillDisappear:animated];
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

