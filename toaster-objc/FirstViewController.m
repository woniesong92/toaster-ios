//
//  FirstViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "FirstViewController.h"
#import "PostsShowViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "WebViewManager.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

WebViewManager *webViewManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webViewManager = [WebViewManager getUniqueWebViewManager:self];
    [self.view addSubview: webViewManager.webView];
    [webViewManager loadUrlWithString:BASE_URL];
    
//    
//    NSURL *url = [NSURL URLWithString:BASE_URL];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [tmp loadRequest:urlRequest];
    
//    [webViewManager acquireWebView:self];
//    [webViewManager loadUrlWithString:BASE_URL];
    
//    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//    self.webView.delegate = self;
//    [self.view addSubview: self.webView];
//    NSURL *url = [NSURL URLWithString:BASE_URL];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:urlRequest];
    

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    NSLog(@"removing from firstVC");
    [webViewManager removeWebViewFromContainer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = [request URL];

    if ([[URL absoluteString] isEqualToString:@"toasterapp://postsShow"]) {
        [self performSegueWithIdentifier:@"postsShowSegue" sender:self];
        return false;
    }
    return true;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"postsShowSegue"]) {
//        PostsShowViewController *postsShowVC = (PostsShowViewController *)segue.destinationViewController;
//        postsShowVC.webView = self.webView;
//        [self.webView removeFromSuperview];
//        self.webView = nil;
//        self.webView.delegate = nil;
    }
}

@end
