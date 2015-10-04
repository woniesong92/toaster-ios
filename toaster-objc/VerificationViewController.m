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
}

- (void)shouldRedirect:(NSNotification *)notification {
    NSLog(@"going to redirect");
    [self performSegueWithIdentifier:@"VerificationToMainSegue" sender:nil];
}

@end
