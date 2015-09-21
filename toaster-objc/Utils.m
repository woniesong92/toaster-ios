//
//  Utils.m
//  Toaster
//
//  Created by Howon Song on 9/20/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "Utils.h"
#import "Underscore.h"
#import "NSDate+DateTools.h"
#define _ Underscore

@implementation Utils

+ (NSDate *)dateWithJSONString: (NSString *)createdAt {
    // FIXME: initializing a dateformatter everytime is inefficient
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    //should match this format: 2015-09-21T00:40:21.976Z
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:createdAt];
    return date;
}

+ (NSArray *)sortReversedJSONObjsByDate: (NSArray *)objs {
    
    NSArray *objsWithDates = _.array(objs)
    .map(^NSMutableDictionary *(NSDictionary *obj) {
        NSMutableDictionary *objCopy = [obj mutableCopy];
        NSString *createdAt = obj[@"createdAt"];
        NSDate *newDate = [Utils dateWithJSONString:createdAt];
        [objCopy setValue:newDate forKey:@"createdAt"];
        return objCopy;
    }).unwrap;
    
    NSArray *sortedObjs = [objsWithDates sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(NSDictionary *)a objectForKey:@"createdAt"];
        NSDate *second = [(NSDictionary *)b objectForKey:@"createdAt"];
        
        return [second compare:first];
    }];
    
    return sortedObjs;
}

+ (NSArray *)sortJSONObjsByDate: (NSArray *)objs {
    
    NSArray *objsWithDates = _.array(objs)
    .map(^NSMutableDictionary *(NSDictionary *obj) {
        NSMutableDictionary *objCopy = [obj mutableCopy];
        NSString *createdAt = obj[@"createdAt"];
        NSDate *newDate = [Utils dateWithJSONString:createdAt];
        [objCopy setValue:newDate forKey:@"createdAt"];
        return objCopy;
    }).unwrap;
    
    NSArray *sortedObjs = [objsWithDates sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(NSDictionary *)a objectForKey:@"createdAt"];
        NSDate *second = [(NSDictionary *)b objectForKey:@"createdAt"];
        
        return [first compare:second];
    }];
    
    return sortedObjs;
}

+ (NSString *)stringFromDate: (NSDate *)createdAt {
    return createdAt.shortTimeAgoSinceNow;
}

@end
