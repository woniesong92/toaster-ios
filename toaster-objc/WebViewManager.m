//
//  WebViewManager.m
//  toaster-objc
//
//  Created by Howon Song on 9/4/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "WebViewManager.h"
#import "Constants.h"

@implementation WebViewManager

+ (id)getUniqueWebViewManager: (UIViewController *)container {
    static WebViewManager *uniqueWebView = nil;
    @synchronized(self) {
        if (uniqueWebView == nil) {
            uniqueWebView = [[self alloc] init];
            uniqueWebView.webView = [[UIWebView alloc] initWithFrame:container.view.frame];
            uniqueWebView.didLoadUrl = false;
            
            // Resize WebView appropriately
            CGRect resizedFrame = uniqueWebView.webView.frame;
            CGFloat tabBarHeight = [[container tabBarController] tabBar].frame.size.height;
            CGFloat navBarHeight = [[container navigationController] navigationBar].frame.size.height;
            CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            resizedFrame.origin.y = navBarHeight + statusBarHeight;
            resizedFrame.size.height = container.view.frame.size.height - (tabBarHeight + navBarHeight + statusBarHeight);
            uniqueWebView.webView.frame = resizedFrame;
            
            // Load website. This is the only time that
            // loadURL should be used because ours is a single page app
            [uniqueWebView loadUrlWithString:BASE_URL];
        }
    }
    return uniqueWebView;
}

- (void)loadUrlWithString: (NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    self.didLoadUrl = true;
}

- (UIWebView *) acquireWebView: (id)container {
    UIWebView *webView = self.webView;
    webView.delegate = container;
    return webView;
}

- (void) removeWebViewFromContainer {
    self.webView.delegate = nil;
    [self.webView removeFromSuperview];
}

@end
