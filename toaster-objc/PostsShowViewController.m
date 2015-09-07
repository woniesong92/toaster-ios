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

@implementation PostsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"postsShow is the delegate");
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    [_webViewManager removeWebViewFromContainer];
    
    // Setting delegate for WKWebView
    [[_webViewManager webView] setDelegateViews: self];

    [self.view addSubview: _webViewManager.webView];
    
//    if ([WebViewManager isWKWebViewAvailable]) {
//        WKWebView *webView = (WKWebView *) _webViewManager.webView;
//        webView.scrollView.scrollEnabled = NO;
//        NSLog(@"webView scrolled %d", webView.scrollView.scrollEnabled);
//    } else {
//        UIWebView *webView = (UIWebView *) _webViewManager.webView;
//        webView.scrollView.scrollEnabled = NO;
//        NSLog(@"webView scrolled %d", webView.scrollView.scrollEnabled);
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated {
    // Overshadow my webview with an image just before the transition
    [_webViewManager replaceWebViewWithImage:self :self.parentScreenImage];
    
    [super viewWillDisappear:animated];
}


- (void) viewDidDisappear:(BOOL)animated {
    // I don't want to be a tabbar delegate anymore
    [super viewDidDisappear:animated];
    
    // I get rid of the temporary screenshot that was overshadowing my webview
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

