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
#import "SessionManager.h"

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

- (IBAction)signUpButtonClicked:(id)sender {
    NSString *email = [self.emailField text];
    NSString *password = [self.passwordField text];
    NSString *passwordConfirm = [self.passwordConfirmField text];
    
    if (![password isEqualToString:passwordConfirm]) {
        // TODO: show alert that passwords dont match
        NSLog(@"password1: %@", password);
        NSLog(@"password2: %@", passwordConfirm);
        
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
        
        [SessionManager loginAndRedirect:self sessionObj:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.emailField = nil;
        self.passwordField = nil;
        self.passwordConfirmField = nil;
        
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

@end
