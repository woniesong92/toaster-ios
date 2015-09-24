//
//  Utils.h
//  Toaster
//
//  Created by Howon Song on 9/20/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSDate*)dateWithJSONString: (NSString *)createdAt;
+ (NSArray *)sortJSONObjsByDate: (NSArray *)objs;
+ (NSString *)stringFromDate: (NSDate *)createdAt;
+ (NSArray *)sortReversedJSONObjsByDate: (NSArray *)objs;

@end