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
#import "Utils.h"

@implementation VerificationViewController

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldRedirect:)
                                                 name:@"emailVerified"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.defaultSubText = self.subTextView.text;
    self.defaultSubTextColor = self.subTextView.textColor;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.subTextView setText:self.defaultSubText];
    [self.subTextView setTextColor:self.defaultSubTextColor];
}

- (void)shouldRedirect:(NSNotification *)notification {
    [self performSegueWithIdentifier:@"VerificationToMainSegue" sender:nil];
}

- (IBAction)sendEmailBtnPressed:(id)sender {
    NSString *userId = [SessionManager currentUser];
    NSDictionary *params = @{@"userId": userId};
    [Utils showLoadingWheel:self.view frame:self.bottomSpinner.frame isWhite:YES];
    
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    [manager POST:SEND_EMAIL_API_URL parameters:params success:^(NSURLSessionDataTask *task, id resp) {
        [Utils hideLoadingWheel:self.view];
        [self.subTextView setText:@"Email sent!"];
        [self.subTextView setTextColor: SUCCESS_COLOR];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [Utils hideLoadingWheel:self.view];
        [self.subTextView setText:@"Failed to send an email."];
        [self.subTextView setTextColor: ERROR_COLOR];
    }];
}

- (IBAction)alreadyVerifiedBtnClicked:(id)sender {
    NSString *userId = [SessionManager currentUser];
    NSDictionary *params = @{@"userId": userId};
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    
    [Utils showLoadingWheel:self.view frame:self.topSpinner.frame isWhite:YES];
    
    [manager POST:VERIFICATION_API_URL parameters:params success:^(NSURLSessionDataTask *task, id isVerifiedObj) {
        BOOL isVerified = [(NSNumber *)isVerifiedObj[@"isVerified"] boolValue];
        
        if (isVerified) {
            [SessionManager setVerified];
            [self performSegueWithIdentifier:@"VerificationToMainSegue" sender:nil];
        } else {
            [self.subTextView setText:@"You aren't verified. Please try verifying again."];
            [self.subTextView setTextColor: ERROR_COLOR];
        }
        
        [Utils hideLoadingWheel:self.view];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString* errResp = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        
        [self.subTextView setText:@"Unknown error occurred."];
        [self.subTextView setTextColor: ERROR_COLOR];
        
        [Utils hideLoadingWheel:self.view];
        
    }];

}





@end
