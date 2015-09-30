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
#import "PostsShowViewController.h"

@implementation NotificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    networkManager = [NetworkManager getNetworkManager];
    
    NSLog(@"NOTIFICATION LOADED");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"view will appear");
    
    [self fetchNotifications:@100 skip:@0];
}


- (void)fetchNotifications: (NSNumber *)limit skip:(NSNumber *)skip {
    
    NSString *reqUrl = [NSString stringWithFormat:@"%@/%@/%@", GET_NOTIFICATIONS_URL, limit, skip];
    
    AFHTTPRequestOperationManager *manager = networkManager.manager;
    
    [manager GET:reqUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
  
        NSMutableArray *notifications = responseObject[@"notifications"];
        
        NSMutableArray *posts = responseObject[@"posts"];
        NSMutableArray *comments = responseObject[@"comments"];
        
        self.postsDict = [Utils transformArrToDict:posts keyStr:@"_id"];
        self.commentsDict = [Utils transformArrToDict:comments keyStr:@"_id"];
        
        for (NSMutableDictionary *noti in notifications) {
            NSString *postId = noti[@"postId"];
            NSString *commentId = noti[@"commentId"];
            if (![commentId isEqual:[NSNull null]]) {
                NSMutableDictionary *comment = self.commentsDict[commentId];
                [noti setValue:comment[@"body"] forKey: @"content"];
            } else {
                NSMutableDictionary *post = self.postsDict[postId];
                [noti setValue:post[@"body"] forKey: @"content"];
            }
        }
        
        self.notifications = [Utils sortByDate:notifications isReversed:YES];
        
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

    NSString *cellId = @"NotiCell";
    
    NotificationCell *cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *notiObj = [self.notifications objectAtIndex:indexPath.row];
    
    NSString *postId = notiObj[@"postId"];
    NSString *notiBody = notiObj[@"body"];
    NSString *createdAt = [Utils stringFromDate:[notiObj objectForKey:@"createdAt"]];
    BOOL isRead = [(NSNumber *)notiObj[@"isRead"] boolValue];
    NSString *notiType = notiObj[@"type"];
    NSString *content = notiObj[@"content"];
    
//    more keys: fromUserId, toUserId, commentId, icon
    
    cell.postId = postId;
    cell.isRead = isRead;
    [cell.notiContent setText:[NSString stringWithFormat:@"\"%@\"", content]];
    [cell.notiMsg setText:notiBody];
    [cell.createdAt setText:createdAt];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select:%@", indexPath);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepare");
    
    if ([segue.identifier isEqualToString:@"NotisToDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PostsShowViewController *postsShowController = (PostsShowViewController *)segue.destinationViewController;

        NSMutableDictionary *noti = self.notifications[indexPath.row];
        NSString *postId = noti[@"postId"];
        NSMutableDictionary *post = self.postsDict[postId];
        NSString *createdAt = post[@"createdAt"];
        
        [post setValue:[Utils dateWithJSONString:createdAt] forKey:@"createdAt"];
        
        postsShowController.postDetail = post;
        
//        postsShowController.cellRowIdx = [NSNumber numberWithInteger:indexPath.row];
    }
}


@end
