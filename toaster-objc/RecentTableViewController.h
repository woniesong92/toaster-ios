//
//  RecentTableViewController.h
//  Toaster
//
//  Created by Howon Song on 9/19/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface RecentTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    AFHTTPRequestOperationManager *manager;
}

@property NSMutableArray *comments;
@property NSMutableArray *recentPosts;
@property NSMutableArray *hotPosts;
@property NSMutableArray *currentPosts;
@property NSMutableDictionary *numCommentsForCurrentPosts;
@property NSMutableDictionary *numCommentsForRecentPosts;
@property NSMutableDictionary *numCommentsForHotPosts;
@property (strong, nonatomic) IBOutlet UITableView *recentPostsTable;
@property UIButton *recentBtn;
@property UIButton *hotBtn;
//@property (strong, nonatomic) HotTableViewController *hotTableVC;
@property (strong, nonatomic) UITableView *hotPostsTable;
//@property (strong, nonatomic) UITableView *currentPostsTable;

@end
