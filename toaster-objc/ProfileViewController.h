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
#import "NetworkManager.h"

@interface ProfileViewController : UIViewController <UITableViewDelegate, UIScrollViewDelegate> {
    NetworkManager *networkManager;
}

@property (weak, nonatomic) IBOutlet ProfilePostsTableView *postsTable;
@property (weak, nonatomic) IBOutlet UIButton *myRepliesBtn;
@property (weak, nonatomic) IBOutlet UIButton *myPostsBtn;
@property UILabel *loadingText;

@end
