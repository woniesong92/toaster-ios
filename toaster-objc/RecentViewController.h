//
//  RecentViewController.h
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewManager.h"
#import "FLWebViewProvider.h"
#import "LoadingManager.h"

@interface RecentViewController : UIViewController <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate> {
    WebViewManager *_webViewManager;
    LoadingManager *_loadingManager;
}

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIImage *screenImage;

@end

