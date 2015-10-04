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
#import "Constants.h"

@implementation SessionManager

+ (NSString *)currentUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    // check if user is already loggedIn
    
    NSString *userId = [defaults objectForKey:@"userId"];
    
//    UIApplicationDidFinishLaunchingNotification
    
    if(userId == nil || [userId isEqualToString:@""]) {
        return @"";
    } else {
        return userId;
    }
}

+ (BOOL)isVerified {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];

    BOOL isVerified = [(NSNumber *)[defaults objectForKey:@"isVerified"] boolValue];
    return isVerified;
}

+ (void)setVerified {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"isVerified"];
    [defaults synchronize];
}

+ (void) clearSession {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"token"];
    [defaults removeObjectForKey:@"userId"];
    [defaults removeObjectForKey:@"isVerified"];
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
     
