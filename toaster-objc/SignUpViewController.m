//
//  SignUpViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/6/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SignUpViewController.h"
#import "RecentViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    
    // Add webView as subView
    [self.view addSubview: _webViewManager.webView];
    
    [_webViewManager useRouterWithPath:SIGN_UP];
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
    NSURL *URL = [request URL];
    NSString *urlString =[URL absoluteString];
    
    NSLog([NSString stringWithFormat:@"%@ -- %@", @"SIGNUP", urlString]);
    
    if ([urlString isEqualToString:LOGGEDIN_SCHEME]) {
        NSLog(@"setting tab selected index");
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate.tabBarController setSelectedIndex:RECENT_TAB_INDEX];
        
//        
//        [self.tabBarController.delegate tabBarController:self.tabBarController didSelectViewController:[self.tabBarController.viewControllers objectAtIndex:RECENT_TAB_INDEX]];
//        
        
        [_webViewManager useRouterWithPath:RECENT];
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return false;
    }
    
    if ([urlString isEqualToString:SIGNIN_SCHEME]) {
        self.navigationItem.title = @"Login";
        return true;
    } else if ([urlString isEqualToString:SIGNUP_SCHEME]) {
        self.navigationItem.title = @"Sign up";
        return true;
    }
    
    return true;
}

@end
