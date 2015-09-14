//
//  NotVerifiedViewController.h
//  toaster
//
//  Created by Howon Song on 9/13/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewManager.h"
#import "LoadingManager.h"

@interface NotVerifiedViewController : UIViewController <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate> {
    WebViewManager *_webViewManager;
    LoadingManager *_loadingManager;
}

@end
