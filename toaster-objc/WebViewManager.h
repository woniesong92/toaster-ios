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
@property BOOL didLoadUrl;

+ (id)getUniqueWebViewManager: (UIViewController *)container;
- (void)loadUrlWithString: (NSString *)urlString;
- (void) removeWebViewFromContainer;

@end
