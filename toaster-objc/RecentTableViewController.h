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
@property NSMutableArray *posts;
@property NSMutableDictionary *numCommentsForPosts;
@property (strong, nonatomic) IBOutlet UITableView *postsTable;

@end
