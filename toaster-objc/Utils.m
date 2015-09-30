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

+ (NSMutableArray *)sortByDate: (NSMutableArray *)objs isReversed:(BOOL)isReversed {
    
    for (NSMutableDictionary *obj in objs) {
        NSDate *createdAt = [Utils dateWithJSONString:obj[@"createdAt"]];
        [obj setValue:createdAt forKey:@"createdAt"];
    }
    
    NSArray *sortedObjs = (NSMutableArray *)[objs sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(NSDictionary *)a objectForKey:@"createdAt"];
        NSDate *second = [(NSDictionary *)b objectForKey:@"createdAt"];
        
        if (isReversed) {
            return [second compare:first];
        } else {
            return [first compare:second];
        }
    }];
    
    return [sortedObjs mutableCopy];
}

+ (NSMutableArray *)sortPostsByHotness: (NSMutableArray *)posts {
    for (NSMutableDictionary *post in posts) {
        NSDate *createdAt = [Utils dateWithJSONString:post[@"createdAt"]];
        
        // calculate hotness
        float hoursPast = [[[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:createdAt toDate:[NSDate date] options:0] hour];
        float numVotes = [(NSNumber *)post[@"numLikes"] floatValue];
        
        float gravity = 1.8;
        float hotness = numVotes / pow((hoursPast + 2), gravity);
        
        
        NSLog(@"hotness: %f", hotness);
        
        [post setValue:[NSNumber numberWithFloat:hotness] forKey:@"hotness"];
        [post setValue:createdAt forKey:@"createdAt"];
    }
    
    NSArray *sortedPosts = (NSMutableArray *)[posts sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        
        NSDate *first = [(NSDictionary *)a objectForKey:@"hotness"];
        NSDate *second = [(NSDictionary *)b objectForKey:@"hotness"];

        return [second compare:first];
    }];
    
    NSLog(@"sortedPosts: %@", sortedPosts);
    
    return [sortedPosts mutableCopy];
}

+ (NSString *)stringFromDate: (NSDate *)createdAt {
    return createdAt.shortTimeAgoSinceNow;
}

+ (NSMutableDictionary *)transformArrToDict: (NSMutableArray *)objs keyStr:(NSString *)keyStr {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:objs.count];
    
    for (NSMutableDictionary *obj in objs) {
        // keyStr = @"_id", @"postId" or @"commentId"
        NSString *key = obj[keyStr];
        [result setValue:obj forKey:key];
    }
    
    return result;
}

@end
