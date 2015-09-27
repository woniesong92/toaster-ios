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
#import "Utils.h"
#import "NotificationCell.h"

@implementation NotificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    manager = appDelegate.networkManager;
    
    NSLog(@"NOTIFICATION LOADED");
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"view will appear");
    
    [self fetchNotifications:@100 skip:@0];
}


- (void)fetchNotifications: (NSNumber *)limit skip:(NSNumber *)skip {
    
    NSString *reqUrl = [NSString stringWithFormat:@"%@/%@/%@", GET_NOTIFICATIONS_URL, limit, skip];
    
    [manager GET:reqUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
  
        NSMutableArray *notifications = responseObject[@"notifications"];
        self.notifications = [Utils sortReversedJSONObjsByDate:notifications];
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *userId = appDelegate.userId;
    NSString *cellId = @"NotiCell";
    NotificationCell *cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *notiObj = [self.notifications objectAtIndex:indexPath.row];
    
    NSString *postId = notiObj[@"postId"];
    NSString *notiBody = notiObj[@"body"];
    NSString *createdAt = [Utils stringFromDate:[notiObj objectForKey:@"createdAt"]];
    BOOL isRead = [(NSNumber *)notiObj[@"isRead"] boolValue];
    NSString *notiType = notiObj[@"type"];
    
//    more keys: fromUserId, toUserId, commentId, icon
    
    cell.postId = postId;
    cell.isRead = isRead;
    [cell.notiContent setText:notiBody];
    [cell.notiMsg setText:notiBody];
    [cell.createdAt setText:createdAt];
    return cell;
}


@end
