//
//  SignUpPasswordVC.m
//  Toaster
//
//  Created by Howon Song on 10/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SignUpPasswordVC.h"
#import "SignUpEmailVC.h"
#import "SessionManager.h"
#import "NetworkManager.h"
#import "VerificationViewController.h"
#import "Constants.h"
#import "Utils.h"

@implementation SignUpPasswordVC


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [super viewWillAppear:animated];
    
    self.defaultSubText = self.subTextField.text;
    self.defaultSubTextColor = self.subTextField.textColor;
}

- (void)clearField {
    [self.passwordField setText:@""];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.subTextField setText:self.defaultSubText];
    [self.subTextField setTextColor:self.defaultSubTextColor];    
}

- (IBAction)connectClicked:(id)sender {
    NSString *email = self.email;
    NSString *password = [self.passwordField text];
    
    if ([password length] < 6) {
        [self clearField];
        [self.subTextField setText:@"Password is too short."];
        [self.subTextField setTextColor:ERROR_COLOR];
        return;
    }
    
    // Make a request to backend server to register id
    
    NSLog(@"fixme: show a loading wheel: verification email sent");
    
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    
    NSDictionary *params = @{@"email": email,
                             @"password": password};
    
    [Utils showLoadingWheel:self.view frame:self.spinner.frame isWhite:YES];
    
    [manager POST:SIGNUP_API_URL parameters:params success:^(NSURLSessionDataTask *task, id resp) {
        
        [SessionManager updateSession: (NSMutableDictionary *)resp];
        
        [self performSegueWithIdentifier:@"SignUpToVerificationSegue" sender:self];
        
        [Utils hideLoadingWheel:self.view];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *emailExists = @"Email already exists.";
        NSString *errMsg = [manager getErrorReason:error];
        
        if ([errMsg isEqualToString:emailExists]) {
            [self clearField];
            
            SignUpEmailVC *vc = (SignUpEmailVC *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            vc.errorMsg = emailExists;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.subTextField setText:errMsg];
            [self.subTextField setTextColor:ERROR_COLOR];
            [self clearField];
        }
        
        [Utils hideLoadingWheel:self.view];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SignUpToVerificationSegue"]) {
        VerificationViewController *vc = (VerificationViewController *)segue.destinationViewController;
        vc.email = self.email;
    }
}

@end
