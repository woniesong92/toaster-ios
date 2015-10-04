//
//  LoadingVC.m
//  Toaster
//
//  Created by Howon Song on 10/4/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "LoadingVC.h"
#import "SessionManager.h"

@implementation LoadingVC


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[SessionManager currentUser] isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"LoadingToSignUpSegue" sender:self];
    } else if (![SessionManager isVerified]) {
        [self performSegueWithIdentifier:@"LoadingToVerificationSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"LoadingToMainSegue" sender:self];
    }
}

@end
