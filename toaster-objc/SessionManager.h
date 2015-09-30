//
//  SessionManager.h
//  Toaster
//
//  Created by Howon Song on 9/27/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SessionManager : NSObject

//+ (BOOL) checkSessionAndRedirect: (NSString *)segueId sender:(UIViewController *)sender;
+ (void) clearSession;
+ (void) updateSession:(NSMutableDictionary *)sessionObj;
+ (NSString *)currentUser;

@end
