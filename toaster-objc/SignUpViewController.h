//
//  SignUpViewController.h
//  toaster-objc
//
//  Created by Howon Song on 9/6/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingManager.h"

@interface SignUpViewController : UIViewController <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate> {
}

@property (strong, nonatomic) UITabBarController *tabBarCtr;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmField;

@property BOOL showVerification;

@end
