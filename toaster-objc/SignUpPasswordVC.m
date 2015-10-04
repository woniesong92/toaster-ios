//
//  SignUpPasswordVC.m
//  Toaster
//
//  Created by Howon Song on 10/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SignUpPasswordVC.h"
#import "SessionManager.h"
#import "NetworkManager.h"
#import "Constants.h"

@implementation SignUpPasswordVC


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
    [SessionManager clearSession];
    
    [super viewWillAppear:animated];
}

- (IBAction)connectClicked:(id)sender {
    NSString *email = self.email;
    NSString *password = [self.passwordField text];
    
    // Make a request to backend server to register id
    AFHTTPRequestOperationManager *manager = [NetworkManager getNetworkManager].manager;
    NSDictionary *params = @{@"email": email,
                             @"password": password};
    [manager POST:SIGNUP_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SessionManager updateSession:responseObject];
        
        [self performSegueWithIdentifier:@"SignUpToVerificationSegue" sender:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // TODO: show user this error and clear all the textfields
        // Go back to beginning with an error message
        
        NSLog(@"Error: %@", error);
        NSLog(@"Operation: %@", operation);
    }];
}

@end
