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
}

- (void)showLoading {
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat topBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat centerHeight = [UIScreen mainScreen].bounds.size.height / 2.0 - (statusHeight + topBarHeight);
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, (centerHeight-25), self.view.frame.size.width, 50)];
    label.text = @"Yolk..."; //etc...
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    self.loadingText = label;
    [self.view addSubview:label];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showLoading];
    [self fetchNotifications:@100 skip:@0];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)markAllNotificationsRead {
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    [manager POST:READ_NOTIFICATION_API_URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // TODO: show user this error and clear all the textfields
    }];
}

- (void)showZeroNotification {
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat topBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat centerHeight = [UIScreen mainScreen].bounds.size.height / 2.0 - (statusHeight + topBarHeight);
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, centerHeight-25, self.view.frame.size.width, 50.0)];
    label.text = @"You don't have any notification yet."; //etc...
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    self.zeroNotificationText = label;
    [self.view addSubview:label];
}


- (void)fetchNotifications: (NSNumber *)limit skip:(NSNumber *)skip {
    
    NSString *reqUrl = [NSString stringWithFormat:@"%@/%@/%@", GET_NOTIFICATIONS_URL, limit, skip];
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    
    [manager GET:reqUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
  
        NSMutableArray *notifications = responseObject[@"notifications"];
        NSMutableArray *posts = responseObject[@"posts"];
        NSMutableArray *comments = responseObject[@"comments"];
        
        self.postsDict = [Utils transformArrToDict:posts keyStr:@"_id"];
        self.commentsDict = [Utils transformArrToDict:comments keyStr:@"_id"];
        
        for (NSMutableDictionary *noti in notifications) {
            NSString *postId = noti[@"postId"];
            NSString *commentId = noti[@"commentId"];
            if (!(commentId == nil) && ![commentId isEqual:[NSNull null]]) {
                NSMutableDictionary *comment = self.commentsDict[commentId];
                [noti setValue:comment[@"body"] forKey: @"content"];
            } else {
                NSMutableDictionary *post = self.postsDict[postId];
                [noti setValue:post[@"body"] forKey: @"content"];
            }
        }
        
        self.notifications = [Utils sortByDate:notifications isReversed:YES];
        if (self.notifications.count == 0) {
            [self showZeroNotification];
        } else {
            [self.zeroNotificationText removeFromSuperview];
        }
        
        [self.loadingText removeFromSuperview];
        [self.tableView reloadData];
        [self markAllNotificationsRead];

        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
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
    cell.notiType = notiType;
    
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
    if ([segue.identifier isEqualToString:@"NotisToDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PostsShowViewController *postsShowController = (PostsShowViewController *)segue.destinationViewController;

        NSMutableDictionary *noti = self.notifications[indexPath.row];
        NSString *postId = noti[@"postId"];
        NSMutableDictionary *post = self.postsDict[postId];
        NSString *createdAt = post[@"createdAt"];
        
        [post setValue:[Utils dateWithJSONString:createdAt] forKey:@"createdAt"];
        postsShowController.postDetail = post;
    }
}


@end
