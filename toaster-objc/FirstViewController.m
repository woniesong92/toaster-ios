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

@interface FirstViewController ()
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ViewDIdLoad");
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    _webViewManager.webView.delegate = self;
    [self.view addSubview: _webViewManager.webView];
    //    _webViewManager.webView.frame.origin.y = 64;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(self.topLayoutGuide.length,
                                           0.0,
                                           self.bottomLayoutGuide.length,
                                           0.0);
    
    _webViewManager.webView.scrollView.contentInset = insets;
    
    [_webViewManager loadUrlWithString:BASE_URL];
    
    
//    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
//    _webViewManager.webView.delegate = self;
//    [self.view addSubview: _webViewManager.webView];
//    [_webViewManager loadUrlWithString:BASE_URL];
    
//    NSURL *url = [NSURL URLWithString:BASE_URL];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [tmp loadRequest:urlRequest];
    
//    [_webViewManager acquireWebView:self];
//    [_webViewManager loadUrlWithString:BASE_URL];
    
//    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//    self.webView.delegate = self;
//    [self.view addSubview: self.webView];
//    NSURL *url = [NSURL URLWithString:BASE_URL];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:urlRequest];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"ViewWillAppear");
    
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    _webViewManager.webView.delegate = self;
    [self.view addSubview: _webViewManager.webView];
//    _webViewManager.webView.frame.origin.y = 64;
    
//    UIEdgeInsets insets = UIEdgeInsetsMake(self.topLayoutGuide.length,
//                                           0.0,
//                                           self.bottomLayoutGuide.length,
//                                           0.0);
//    
//    _webViewManager.webView.scrollView.contentInset = insets;
    
//    [_webViewManager loadUrlWithString:BASE_URL];
    
//
//    CGRect tmp = _webViewManager.webView.frame;
//    tmp.origin.y = 64.0;
//    tmp.size.height = _webViewManager.webView.frame.size.height - 64.0;
//    tmp.size.height -= 64.0;
//    _webViewManager.webView.frame = tmp;
    

    
//    [_webViewManager.webVIew.goBack];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    NSLog(@"removing from firstVC");
    [_webViewManager removeWebViewFromContainer];
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
