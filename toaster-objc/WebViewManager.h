//
//  WebViewManager.h
//  toaster-objc
//
//  Created by Howon Song on 9/4/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "FLWebViewProvider.h"
#import "UIWebView+FLUIWebView.h"
#import "WKWebView+FLWKWebView.h"

@interface WebViewManager : NSObject <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate>

//@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic) UIView <FLWebViewProvider> *webView;

+ (id)getUniqueWebViewManager: (UIViewController *)container;
- (void)loadUrlWithString: (NSString *)urlString;
- (void)removeWebViewFromContainer;
- (void)useRouterWithPath: (NSString *)pathString;
- (void)routerGo: (NSString *)pathString;

// currentTab is used to see if we should perform `Router.go()`
// because the user wants to go to a different tab
- (void)setCurrentTab: (NSString *)currentTab;
- (NSString *)getCurrentTab;

+ (BOOL)isWKWebViewAvailable;

//- (void)replaceWebViewWithImage:(UIViewController *)containerVC;
- (void)replaceWebViewWithImage:(UIViewController *)containerVC :(UIImage *)image;
- (void)replaceImageWithWebView:(UIViewController *)containerVC;
- (UIImage *)screencapture:(UIViewController *)viewController;

- (UIImage *)getWhiteImage;

@end
