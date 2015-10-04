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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldRedirect:)
                                                 name:@"emailVerified"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)shouldRedirect:(NSNotification *)notification {
    NSLog(@"shouldRedirect: user clicked the link! Let's redirect");
    [self performSegueWithIdentifier:@"VerificationToMainSegue" sender:nil];
}

- (IBAction)sendEmailBtnPressed:(id)sender {
    NSString *email = self.email;
    NSDictionary *params = @{@"email": email};
    [[NetworkManager getNetworkManager].manager POST:SEND_EMAIL_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"email just sent to %@!", self.email);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"failed to send an email");
    }];
    

}


@end
