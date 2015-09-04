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
    _webViewManager.webView.delegate = self;
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

    // Show Recent view next time we come back from a different tab
//    [self.navigationController popToRootViewControllerAnimated:NO];
    [super viewWillDisappear:animated];
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    if (parent == nil){
        NSLog(@"do whatever you want here");
        [_webViewManager.webView goBack];
//        [_webViewManager useRouterWithPath:RECENT];
    }
}

@end

