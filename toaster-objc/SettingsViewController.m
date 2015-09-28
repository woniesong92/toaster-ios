//
//  SettingsViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/6/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constants.h"
#import "SignUpViewController.h"
#import "SessionManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onLogoutClicked:(id)sender {
    NSLog(@"logging out this kid");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"token"];
    [defaults removeObjectForKey:@"userId"];
    [defaults synchronize];
    
    [SessionManager clearSessionAndRedirect:@"SettingsToSignUpSegue" sender:self];
}

@end