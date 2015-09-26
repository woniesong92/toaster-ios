//
//  NotificationsTableViewController.m
//  Toaster
//
//  Created by Howon Song on 9/26/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "NotificationsTableViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation NotificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)fetchPosts: (NSInteger)postsTableTag limit:(NSNumber *)limit skip:(NSNumber *)skip doReload:(BOOL)doReload {
    
    NSString *reqUrl;
    
    if (postsTableTag == RECENT_POSTS_TABLE_TAG) {
        reqUrl = [NSString stringWithFormat:@"%@/%@/%@", GET_RECENT_POSTS_URL, limit, skip];
        NSLog(@"fetching recent table posts");
    } else {
        reqUrl = [NSString stringWithFormat:@"%@/%@/%@", GET_HOT_POSTS_URL, limit, skip];
        NSLog(@"fetching hot table posts");
    }
    
    [manager GET:reqUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"req url: %@", operation.request.URL);
        
        NSMutableArray *posts = responseObject[@"posts"];
        NSMutableArray *comments = responseObject[@"comments"];
        NSMutableDictionary *numCommentsForPosts = [[NSMutableDictionary alloc] init];
        
        for (NSDictionary *comment in comments) {
            NSString *key = comment[@"postId"];
            NSNumber *numComments = [numCommentsForPosts objectForKey:key];
            if (numComments) {
                NSNumber *newNumComments = [NSNumber numberWithInt: (numComments.intValue + 1)];
                [numCommentsForPosts setValue:newNumComments forKey:key];
            } else {
                [numCommentsForPosts setValue:[NSNumber numberWithInt:1] forKey:key];
            }
        }
        
        if (postsTableTag == RECENT_POSTS_TABLE_TAG) {
            self.postsTable.recentPosts = [Utils sortReversedJSONObjsByDate:posts];
            self.postsTable.numCommentsForRecentPosts = numCommentsForPosts;
        } else {
            self.postsTable.hotPosts = [Utils sortReversedJSONObjsByDate:posts];
            self.postsTable.numCommentsForHotPosts = numCommentsForPosts;
        }
        
        if (doReload) {
            [self.postsTable reloadData];
        } else {
            NSLog(@"dont reload");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

@end
