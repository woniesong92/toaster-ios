//
//  SessionManager.m
//  Toaster
//
//  Created by Howon Song on 9/27/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager

+ (void) checkSessionAndRedirect: (NSString *)segueId sender:(UIViewController *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *userId = [defaults objectForKey:@"userId"];
    NSString *tokenExpires = [defaults objectForKey:@"tokenExpires"];
    
    // check if user is already loggedIn
    if([defaults objectForKey:@"token"] == nil ||
       [[defaults objectForKey:@"token"] isEqualToString:@""]) {
        
        // FIXME: check if the token has expired. Then the user has to log in again
        NSLog(@"user not logged in! %@, %@", token, userId);
        
        // Redirected
//        [self performSegueWithIdentifier:@"TabBarToSignUpSegue" sender:self];
        [sender performSegueWithIdentifier:segueId sender:sender];
    }
}

+ (void) clearSessionAndRedirect: (NSString *)segueId sender:(UIViewController *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"token"];
    [defaults removeObjectForKey:@"userId"];
    [defaults synchronize];
    
    [sender performSegueWithIdentifier:segueId sender:sender];
}

+ (void) loginAndRedirect: (UIViewController *)modal sessionObj:(NSMutableDictionary *)sessionObj {
    
    NSString *token = sessionObj[@"token"];
    NSString *userId = sessionObj[@"id"];
    NSString *tokenExpires = sessionObj[@"tokenExpires"];
    
    NSLog(@"JSON: %@", sessionObj);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"token"];
    [defaults setObject:userId forKey:@"userId"];
    [defaults setObject:tokenExpires forKey:@"tokenExpires"];
    [defaults synchronize];
    
    [modal.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
