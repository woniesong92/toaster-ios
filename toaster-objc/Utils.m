//
//  Utils.m
//  Toaster
//
//  Created by Howon Song on 9/20/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSDate*)dateWithJSONString: (NSString *)createdAt
{
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:createdAt];
    return date;        
}

@end
