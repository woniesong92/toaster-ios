//
//  NotVerifiedViewController.m
//  toaster
//
//  Created by Howon Song on 9/13/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "NotVerifiedViewController.h"
#import "RecentViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface NotVerifiedViewController ()

@end

@implementation NotVerifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isVerified:) name:@"emailVerified" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)isVerified:(NSNotification *)notification {
    [_webViewManager routerGo:RECENT];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_webViewManager removeWebViewFromContainer];
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    
    // Setting delegate for WKWebView
    [[_webViewManager webView] setDelegateViews: self];
    
    // Add webView as subView
    [self.view addSubview: _webViewManager.webView];
    
    [_webViewManager routerGo:NOT_VERIFIED];
}

- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType
{
    return [self shouldStartDecidePolicy: request];
}

- (void) webView: (WKWebView *) webView decidePolicyForNavigationAction: (WKNavigationAction *) navigationAction decisionHandler: (void (^)(WKNavigationActionPolicy)) decisionHandler
{
    decisionHandler([self shouldStartDecidePolicy: [navigationAction request]]);
}

- (BOOL) shouldStartDecidePolicy: (NSURLRequest *) request
{
//    NSURL *URL = [request URL];
//    NSString *urlString =[URL absoluteString];
//    
//    NSLog([NSString stringWithFormat:@"%@ -- %@", @"NOT VERIFIED", urlString]);

    return true;
}

@end
