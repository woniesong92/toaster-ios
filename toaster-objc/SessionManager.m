//
//  SessionManager.m
//  Toaster
//
//  Created by Howon Song on 9/27/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SessionManager.h"
#import "AppDelegate.h"
#import "NetworkManager.h"

@implementation SessionManager

//+ (BOOL) checkSessionAndRedirect: (NSString *)segueId sender:(UIViewController *)sender {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//
//    // check if user is already loggedIn
//    if([defaults objectForKey:@"token"] == nil ||
//       [[defaults objectForKey:@"token"] isEqualToString:@""]) {
//        
//        return false;
//    } else {
//        return true;
//    }
//}

+ (NSString *)currentUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // check if user is already loggedIn
    
    NSString *userId = [defaults objectForKey:@"userId"];
    
    if(userId == nil || [userId isEqualToString:@""]) {
        return @"";
    } else {
        return userId;
    }
}

+ (void) clearSession {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"token"];
    [defaults removeObjectForKey:@"userId"];
    [defaults synchronize];
}

+ (void) updateSession:(NSMutableDictionary *)sessionObj {
    
    NSString *token = sessionObj[@"token"];
    NSString *userId = sessionObj[@"id"];
    NSString *tokenExpires = sessionObj[@"tokenExpires"];
    
    NSLog(@"JSON: %@", sessionObj);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"token"];
    [defaults setObject:userId forKey:@"userId"];
    [defaults setObject:tokenExpires forKey:@"tokenExpires"];
    [defaults synchronize];
    

    NetworkManager *networkManager = [NetworkManager getNetworkManager];
    [networkManager updateSerializerWithNewToken:token];
}

@end
