//
//  SignUpViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/6/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SignUpViewController.h"
#import "RecentViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isVerified:) name:@"emailVerified" object:nil];
}

- (void)isVerified:(NSNotification *)notification {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
//
//- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType
//{
//    return [self shouldStartDecidePolicy: request];
//}
//
//- (void) webView: (WKWebView *) webView decidePolicyForNavigationAction: (WKNavigationAction *) navigationAction decisionHandler: (void (^)(WKNavigationActionPolicy)) decisionHandler
//{
//    decisionHandler([self shouldStartDecidePolicy: [navigationAction request]]);
//}
//
//- (BOOL) shouldStartDecidePolicy: (NSURLRequest *) request
//{
//    NSURL *URL = [request URL];
//    NSString *urlString =[URL absoluteString];
//    
////    NSLog([NSString stringWithFormat:@"%@ -- %@", @"SIGNUP", urlString]);
//    
//    if ([urlString containsString:LOGGEDIN_SCHEME]) {
//        
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        
//        NSString *installationId = appDelegate.pushInstallationId;
//        NSString *js = [NSString stringWithFormat:@"Meteor.call(\"registerUserIdToParse\", \"%@\")", installationId];
//        
//        [[_webViewManager webView] evaluateJavaScript:js completionHandler:nil];
//        
//        
//        [appDelegate.tabBarController setSelectedIndex:RECENT_TAB_INDEX];
//        
//        [_webViewManager useRouterWithPath:RECENT];
//        
//        // Only close the modal if the logged in user is an verified user.
//        if ([urlString containsString:@"verified"]) {
//            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//        }
//
//        return false;
//    }
//    
//    if ([urlString isEqualToString:SIGNIN_SCHEME]) {
//        self.navigationItem.title = @"Login";
//        return true;
//    }
//    
//    if ([urlString isEqualToString:SIGNUP_SCHEME]) {
//        self.navigationItem.title = @"Sign up";
//        return true;
//    }
//    
//    if ([urlString isEqualToString:NOT_VERIFIED_SCHEME]) {
//        self.navigationItem.title = @"Verification";
//        return true;
//    }
//    
//    return true;
//}

@end
