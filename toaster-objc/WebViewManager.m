//
//  WebViewManager.m
//  toaster-objc
//
//  Created by Howon Song on 9/4/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "WebViewManager.h"

@implementation WebViewManager

+ (id)getUniqueWebViewManager: (UIViewController *)container {
    static WebViewManager *uniqueWebView = nil;
    @synchronized(self) {
        if (uniqueWebView == nil) {
            uniqueWebView = [[self alloc] init];
            uniqueWebView.webView = [[UIWebView alloc] initWithFrame:container.view.frame];
        }
    }
    return uniqueWebView;
}

- (void)loadUrlWithString: (NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (UIWebView *) acquireWebView: (id)container {
    UIWebView *webView = self.webView;
    webView.delegate = container;
    return webView;
}

- (void) removeWebViewFromContainer: (id)container {
    self.webView.delegate = nil;
    [self.webView removeFromSuperview];
}

@end
