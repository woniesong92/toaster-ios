//
//  RecentTableViewController.h
//  Toaster
//
//  Created by Howon Song on 9/19/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "ToastsTableView.h"

@interface RecentTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    AFHTTPRequestOperationManager *manager;
}

//@property NSMutableArray *comments;
@property UIButton *recentBtn;
@property UIButton *hotBtn;
@property (strong, nonatomic) IBOutlet ToastsTableView *postsTable;

@end
