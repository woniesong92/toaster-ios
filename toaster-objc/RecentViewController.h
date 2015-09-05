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

@interface RecentViewController : UIViewController <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate> {
    WebViewManager *_webViewManager;
}

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIImage *screenImage;

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *newPostBUtton;

//- (IBAction)newPostAction:(id)sender;

@end

