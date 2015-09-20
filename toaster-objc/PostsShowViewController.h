//
//  PostsShowViewController.h
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewManager.h"
#import "LoadingManager.h"

@interface PostsShowViewController : UIViewController <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate> {
    WebViewManager *_webViewManager;
    LoadingManager *_loadingManager;
    CGPoint _scrollViewOrigin;
    CGFloat _keyboardHeight;
    BOOL _shouldPreventScrolling;
}

@property (strong, nonatomic) UIImage *parentScreenImage;

@property (strong, nonatomic) NSDictionary *postDetail;

@end
