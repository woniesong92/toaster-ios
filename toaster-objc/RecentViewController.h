//
//  RecentViewController.h
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewManager.h"

@interface RecentViewController : UIViewController <UIWebViewDelegate> {
    WebViewManager *_webViewManager;
}

@property (strong, nonatomic) UIWebView *webView;


@end

