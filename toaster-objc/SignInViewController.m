//
//  SignInViewController.m
//  Toaster
//
//  Created by Howon Song on 9/19/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SignInViewController.h"
#import "Constants.h"
#import "SessionManager.h"
#import "NetworkManager.h"

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

- (void)clearInputFields {
    self.emailField.text = nil;
    self.passwordField.text = nil;
    [self.emailField setSelected:YES];
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
        
        [self clearInputFields];
        return;
    }
    
    // login logic
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    NSDictionary *params = @{@"email": email,
                             @"password": password};
    
    [manager POST:LOGIN_API_URL parameters:params success:^(NSURLSessionDataTask *task, id resp) {
        
        [SessionManager updateSession: (NSMutableDictionary *)resp];
        
        // check verification status
        NSDictionary *params2 = @{@"userId": resp[@"id"]};
        
        [manager POST:VERIFICATION_API_URL parameters:params2 constructingBodyWithBlock:nil success:^(NSURLSessionDataTask *task, id isVerifiedObj) {
            
            BOOL isVerified = [(NSNumber *)isVerifiedObj[@"isVerified"] boolValue];
            if (isVerified) {
                [self performSegueWithIdentifier:@"LoginToMainSegue" sender:self];
            } else {
                NSLog(@"LOGIN: user not verified. Go to verification.");
                [self performSegueWithIdentifier:@"LoginToVerificationSegue" sender:self];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self clearInputFields];
            NSLog(@"Verification Error: %@", error);
        }];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self clearInputFields];
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
    
    
//    // Make a request to backend server to register id
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    NSDictionary *params = @{@"email": email,
//                             @"password": password};
//    [manager POST:LOGIN_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        // need to close its parent's presentingViewController
//        [SessionManager updateSession:responseObject];
//        
//        // check verification status
//        NSDictionary *params2 = @{@"userId": responseObject[@"id"]};
//        
//        [manager POST:VERIFICATION_API_URL parameters:params2 success:^(AFHTTPRequestOperation *operation, id isVerifiedObj) {
//        
//            BOOL isVerified = [(NSNumber *)isVerifiedObj[@"isVerified"] boolValue];
//            
//            if (isVerified) {
//                // Pop the SignUpViewController
//                
//                [self performSegueWithIdentifier:@"LoginToMainSegue" sender:self];
//                
////                
////                NSArray *navViewControllers = [(UITabBarController *)self.presentingViewController viewControllers];
////                [(UINavigationController *)navViewControllers[0] popToRootViewControllerAnimated:NO];
////                
////                // And dismiss the login modal
////                [self dismissViewControllerAnimated:YES completion:nil];
//            } else {
//                NSLog(@"LOGIN: user not verified. Go to verification.");
//                [self performSegueWithIdentifier:@"LoginToVerificationSegue" sender:self];
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            [self clearInputFields];
//            NSLog(@"Error2: %@", error);
//        }];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        [self clearInputFields];
//        
//        // TODO: show user this error and clear all the textfields
//        NSLog(@"Error: %@", error);
//    }];
}




@end
