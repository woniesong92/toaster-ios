//
//  ProfilePostsTableView.h
//  Toaster
//
//  Created by Howon Song on 9/27/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfilePostsTableView : UITableView <UITableViewDataSource>

@property NSMutableArray *myPosts;
@property NSMutableArray *myReplies;
@property NSMutableArray *posts;
@property NSMutableDictionary *numCommentsForMyPosts;
@property NSMutableDictionary *numCommentsForMyReplies;
@property NSMutableDictionary *numCommentsForPosts;

@end
