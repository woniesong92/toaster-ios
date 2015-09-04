//
//  RecentViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "RecentViewController.h"
#import "PostsShowViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface RecentViewController ()
@end

@implementation RecentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ViewDidLoad");
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"RecentViewWillAppear");
    [_webViewManager removeWebViewFromContainer];
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    _webViewManager.webView.delegate = self;
    [self.view addSubview: _webViewManager.webView];
    
    if (![[_webViewManager getCurrentTab] isEqual:RECENT]) {
        [_webViewManager useRouterWithPath:RECENT];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if( [segue.identifier isEqualToString:@"postsShowSegue"]) {
//        PostsShowViewController *postsShowVC = (PostsShowViewController *)segue.destinationViewController;
//        postsShowVC.webView = self.webView;
//        [self.webView removeFromSuperview];
//        self.webView = nil;
//        self.webView.delegate = nil;
//    }
//}

@end
