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

+ (void) checkSessionAndRedirect: (NSString *)segueId sender:(UIViewController *)sender;
+ (void) clearSessionAndRedirect: (NSString *)segueId sender:(UIViewController *)sender;
+ (void) loginAndRedirect: (UIViewController *)modal sessionObj:(NSMutableDictionary *)sessionObj;

@end
