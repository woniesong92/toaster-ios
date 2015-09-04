//
//  WebViewManager.h
//  toaster-objc
//
//  Created by Howon Song on 9/4/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewManager : NSObject

@property (strong, nonatomic) UIWebView *webView;

+ (id)getUniqueWebViewManager: (UIViewController *)container;
- (void)loadUrlWithString: (NSString *)urlString;
- (void)removeWebViewFromContainer;
- (void)useRouterWithPath: (NSString *)pathString;

// currentTab is used to see if we should perform `Router.go()`
// because the user wants to go to a different tab
- (void)setCurrentTab: (NSString *)currentTab;
- (NSString *)getCurrentTab;

@end
