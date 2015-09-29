//
//  SignInViewController.m
//  Toaster
//
//  Created by Howon Song on 9/19/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SignInViewController.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "SessionManager.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpButtonClicked:(id)sender {
    // close the signIn modal to show signUpVC again
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginButtonClicked:(id)sender {
    NSString *email = [self.emailField text];
    NSString *password = [self.passwordField text];
    
    NSLog(@"email: %@, pw: %@", email, password);
    
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
    [manager POST:LOGIN_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // need to close its parent's presentingViewController
        [SessionManager loginAndRedirect:self sessionObj:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.emailField = nil;
        self.passwordField = nil;
        
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}




@end
