//
//  SignUp1VC.m
//  Toaster
//
//  Created by Howon Song on 10/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SignUp1VC.h"

@implementation SignUp1VC


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
//    [SessionManager clearSession];
    
    [super viewWillAppear:animated];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if (self.showVerification) {
//        [self performSegueWithIdentifier:@"SignUpToVerificationSegue" sender:self];
//    }
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self.navigationController.navigationBar setHidden:NO];
//    [self.tabBarController.tabBar setHidden:NO];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (IBAction)signUpButtonClicked:(id)sender {
//    NSString *email = [self.emailField text];
//    NSString *password = [self.passwordField text];
//    NSString *passwordConfirm = [self.passwordConfirmField text];
//    
//    if (![password isEqualToString:passwordConfirm]) {
//        // TODO: show alert that passwords dont match
//        NSLog(@"password1: %@", password);
//        NSLog(@"password2: %@", passwordConfirm);
//        
//        NSLog(@"passwords dont match");
//        return;
//    }
//    
//    NSString *emailRegex = @"[A-Z0-9a-z]+([._%+-]{1}[A-Z0-9a-z]+)*@[A-Z0-9a-z]+([.-]{1}[A-Z0-9a-z]+)*(\\.[A-Za-z]{2,4}){0,1}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    if (![emailTest evaluateWithObject:email]) {
//        // TODO: show alert that email is invalid
//        NSLog(@"invalid email format");
//        return;
//    }
//    
//    // Make a request to backend server to register id
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *params = @{@"email": email,
//                             @"password": password};
//    [manager POST:SIGNUP_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [SessionManager updateSession:responseObject];
//        
//        
//        //        [self performSegueWithIdentifier:@"SignUpToMainSegue" sender:self];
//        
//        [self performSegueWithIdentifier:@"SignUpToVerificationSegue" sender:self];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        self.emailField.text = nil;
//        self.passwordField.text = nil;
//        self.passwordConfirmField.text = nil;
//        
//        // TODO: show user this error and clear all the textfields
//        NSLog(@"Error: %@", error);
//    }];
//}
//- (IBAction)loginClicked:(id)sender {
//    NSLog(@"SignUpToLoginSegue");
//    [self performSegueWithIdentifier:@"SignUpToLoginSegue" sender:self];
//}

@end
