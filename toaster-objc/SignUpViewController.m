//
//  SignUpViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/6/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SignUpViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:@"token"];
//    NSString *userId = [defaults objectForKey:@"userId"];
//    NSString *tokenExpires = [defaults objectForKey:@"tokenExpires"];
//    
//    // check if user is already loggedIn
//    if([defaults objectForKey:@"token"]!=nil &&
//       ![[defaults objectForKey:@"token"] isEqualToString:@""]) {
//
//        // FIXME: check if the token has expired. Then the user has to log in again
//        NSLog(@"user already logged in! %@, %@", token, userId);
//        
//        // Redirected
//        [self performSegueWithIdentifier:@"goToTabBarVC" sender:self];
//    }
    

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

- (IBAction)signUpButtonClicked:(id)sender {
    NSString *email = [self.emailField text];
    NSString *password = [self.passwordField text];
    NSString *passwordConfirm = [self.passwordConfirmField text];
    
    if (![password isEqualToString:passwordConfirm]) {
        // TODO: show alert that passwords dont match
        NSLog(@"passwords dont match");
        return;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z]+([._%+-]{1}[A-Z0-9a-z]+)*@[A-Z0-9a-z]+([.-]{1}[A-Z0-9a-z]+)*(\\.[A-Za-z]{2,4}){0,1}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:email]) {
        // TODO: show alert that email is invalid
        NSLog(@"invalid email format");
        return;
    }
    
    // Make a request to backend server to register id
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"email": email,
                             @"password": password};
    [manager POST:SIGNUP_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *token = responseObject[@"token"];
        NSString *userId = responseObject[@"id"];
        NSString *tokenExpires = responseObject[@"tokenExpires"];
        
        NSLog(@"JSON: %@", responseObject);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:token forKey:@"token"];
        [defaults setObject:userId forKey:@"userId"];
        [defaults setObject:tokenExpires forKey:@"tokenExpires"];
        [defaults synchronize];
        
//        [self performSegueWithIdentifier:@"goToTabBarVC" sender:self];
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.emailField = nil;
        self.passwordField = nil;
        self.passwordConfirmField = nil;
        
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
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
