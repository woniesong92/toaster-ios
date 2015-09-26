//
//  NotificationsTableViewController.h
//  Toaster
//
//  Created by Howon Song on 9/26/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface NotificationsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    AFHTTPRequestOperationManager *manager;
}

@end
