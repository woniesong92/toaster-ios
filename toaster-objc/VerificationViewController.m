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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *isVerified = [defaults objectForKey:@"isVerified"];
    NSLog(@"isVerified: %@", isVerified);
    
    [super viewWillAppear:animated];
}

- (void)shouldRedirect:(NSNotification *)notification {
    NSLog(@"shouldRedirect: user clicked the link! Let's redirect");
    [self performSegueWithIdentifier:@"VerificationToMainSegue" sender:nil];
}

- (IBAction)sendEmailBtnPressed:(id)sender {
    NSString *userId = [SessionManager currentUser];
    NSDictionary *params = @{@"userId": userId};
    
    
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    [manager POST:SEND_EMAIL_API_URL parameters:params success:^(NSURLSessionDataTask *task, id resp) {
        NSLog(@"email just sent to %@!", userId);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
