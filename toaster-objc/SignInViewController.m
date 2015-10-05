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
#import "Utils.h"

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
        [self.errorField setText:@"Invalid email format"];
        [self clearInputFields];
        return;
    }
    
    // login logic
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    NSDictionary *params = @{@"email": email,
                             @"password": password};
    
    
    [Utils showLoadingWheel:self.view frame:self.spinner.frame isWhite:YES];
    
    [manager POST:LOGIN_API_URL parameters:params success:^(NSURLSessionDataTask *task, id resp) {
        
        [SessionManager updateSession: (NSMutableDictionary *)resp];
        
        // check verification status
        NSDictionary *params2 = @{@"userId": resp[@"id"]};
        
        [manager POST:VERIFICATION_API_URL parameters:params2 success:^(NSURLSessionDataTask *task, id isVerifiedObj) {
            
            BOOL isVerified = [(NSNumber *)isVerifiedObj[@"isVerified"] boolValue];
            if (isVerified) {
                [SessionManager setVerified];
                [self performSegueWithIdentifier:@"LoginToMainSegue" sender:self];
            } else {
                NSLog(@"LOGIN: user not verified. Go to verification.");
                [self performSegueWithIdentifier:@"LoginToVerificationSegue" sender:self];
            }
            
            [Utils hideLoadingWheel:self.view];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self clearInputFields];
            NSLog(@"Verification Error: %@", error);
            NSString* errResp = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSLog(@"respErr: %@", errResp);
            
            [Utils hideLoadingWheel:self.view];
            
        }];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self clearInputFields];
        [self.emailField setSelected:YES];
        
        NSData *errData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSString *errReason = @"";
        NSString *errType = @"";
        
        if (errData) {
            NSMutableDictionary *errObj = [NSJSONSerialization JSONObjectWithData:errData options:0 error:nil];
            errType = errObj[@"error"];
            errReason = errObj[@"reason"];
        }
        
        if ([errType isEqual:@"not-found"]) {
            [self.errorField setText:@"The email address is not registered."];
        } else {
            [self.errorField setText:errReason];
        }
        
        [Utils hideLoadingWheel:self.view];

    }];

}




@end
