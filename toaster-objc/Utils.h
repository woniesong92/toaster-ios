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
+ (NSMutableArray *)sortJSONObjsByDate: (NSArray *)objs;
+ (NSString *)stringFromDate: (NSDate *)createdAt;
+ (NSMutableArray *)sortReversedJSONObjsByDate: (NSArray *)objs;
+ (NSMutableDictionary *)transformArrToDict: (NSMutableArray *)objs keyStr:(NSString *)keyStr;
+ (NSMutableArray *)sortPostsByHotness: (NSMutableArray *)posts;

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@end


//R: 255 G: 70 B: 79
//ff464f