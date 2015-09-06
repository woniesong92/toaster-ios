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

- (void) viewWillDisappear:(BOOL)animated {
    // Overshadow my webview with an image just before the transition
    [_webViewManager replaceWebViewWithImage:self :self.parentScreenImage];
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // I get rid of the temporary screenshot that was overshadowing my webview
    [_webViewManager replaceImageWithWebView:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    if (parent == nil){
        NSLog(@"go back to profile");
        [_webViewManager useRouterWithPath:PROFILE];
    }
}

- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType
{
    return [self shouldStartDecidePolicy: request];
}

- (BOOL) shouldStartDecidePolicy: (NSURLRequest *) request
{
    NSURL *URL = [request URL];
    
    if ([[URL absoluteString] isEqualToString:@"toasterapp://notLoggedIn"]) {
        NSLog(@"Send the user to login page");
        return false;
    }
    return true;
}

@end
