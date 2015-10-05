//
//  SettingsViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/6/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constants.h"
#import "SessionManager.h"
#import "NetworkManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    
    [manager POST:GET_NETWORK_API_URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        NSString *networkName = responseObject[@"network"];
        [self.networkLabel setText:networkName];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)onLogoutClicked:(id)sender {
    NSLog(@"logging out this kid");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"token"];
    [defaults removeObjectForKey:@"userId"];
    [defaults synchronize];
    
    [SessionManager clearSession];
    
    [self performSegueWithIdentifier:@"SettingsToLoginSegue" sender:self];
}

@end