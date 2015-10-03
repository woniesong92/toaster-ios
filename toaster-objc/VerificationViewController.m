//
//  VerificationViewController.m
//  Toaster
//
//  Created by Howon Song on 10/2/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "VerificationViewController.h"
#import "Constants.h"
#import "NetworkManager.h"
#import "SessionManager.h"

@implementation VerificationViewController

- (void)viewDidLoad {
    NSLog(@"did you get the email?");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldRedirect:)
                                                 name:@"emailVerified"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    NSDictionary *params = @{@"userId": [SessionManager currentUser]};
//    
//    [[NetworkManager getNetworkManager].manager POST:VERIFICATION_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id isVerifiedObj) {
//        
//        BOOL isVerified = [(NSNumber *)isVerifiedObj[@"isVerified"] boolValue];
//        if (isVerified) {
//            NSLog(@"yay is verified");
//            [self performSegueWithIdentifier:@"VerificationToMainSegue" sender:self];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        // fail to verify
//        NSLog(@"Error: %@", error);
//        [self performSegueWithIdentifier:@"VerificationToSignUpSegue" sender:self];
//    }];
}

- (void)shouldRedirect:(NSNotification *)notification {
    NSLog(@"going to redirect");
    [self performSegueWithIdentifier:@"VerificationToMainSegue" sender:nil];
}

@end
