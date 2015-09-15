//
//  PrivacyPolicyViewController.h
//  toaster
//
//  Created by Howon Song on 9/15/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewManager.h"

@interface PrivacyPolicyViewController : UIViewController <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate> {
    WebViewManager *_webViewManager;
}
@end
