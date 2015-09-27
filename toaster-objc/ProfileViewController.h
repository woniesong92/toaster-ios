//
//  ProfileViewController.h
//  Toaster
//
//  Created by Howon Song on 9/27/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "ProfilePostsTableView.h"

@interface ProfileViewController : UIViewController <UITableViewDelegate, UIScrollViewDelegate> {
    AFHTTPRequestOperationManager *manager;
}

@property (weak, nonatomic) IBOutlet ProfilePostsTableView *postsTable;
@property (weak, nonatomic) IBOutlet UIButton *myRepliesBtn;
@property (weak, nonatomic) IBOutlet UIButton *myPostsBtn;

@end
