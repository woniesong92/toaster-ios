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
#import "NetworkManager.h"

@interface RecentTableViewController : UIViewController <UITableViewDelegate, UIScrollViewDelegate> {
    NetworkManager *networkManager;
}

@property (weak, nonatomic) IBOutlet UIButton *recentFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *hotFilterBtn;
@property (weak, nonatomic) IBOutlet ToastsTableView *postsTable;
@end
