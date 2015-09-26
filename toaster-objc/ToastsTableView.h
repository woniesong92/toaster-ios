//
//  ToastsTableView.h
//  Toaster
//
//  Created by Howon Song on 9/26/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastsTableView : UITableView <UITableViewDataSource>

@property NSMutableArray *comments;
@property NSMutableArray *posts;
@property NSMutableArray *hotPosts;
@property NSMutableArray *recentPosts;
@property NSMutableDictionary *numCommentsForPosts;
@property NSMutableDictionary *numCommentsForRecentPosts;
@property NSMutableDictionary *numCommentsForHotPosts;

@end
