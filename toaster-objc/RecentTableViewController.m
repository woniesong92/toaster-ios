//
//  RecentTableViewController.m
//  Toaster
//
//  Created by Howon Song on 9/19/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "RecentTableViewController.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "PostsShowViewController.h"

@interface RecentTableViewController ()

@end

@implementation RecentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *authorizationToken = [NSString stringWithFormat:@"Bearer %@", token];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
    
//    NSDictionary *params = @{@"email": email, @"password": password};
    NSDictionary *params = @{};
    [manager GET:GET_RECENT_POSTS_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"RecentPosts: %@", responseObject);
        self.comments = [[NSArray alloc] initWithArray:responseObject[@"comments"]];
        self.posts = [[NSArray alloc] initWithArray:responseObject[@"posts"]];
        NSLog(@"posts: %@", self.posts);

        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.posts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *tempDictionary= [self.posts objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDictionary objectForKey:@"body"];
    cell.detailTextLabel.text = [tempDictionary objectForKey:@"createdAt"];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    PostsShowViewController *postsShowController = (PostsShowViewController *)segue.destinationViewController;
    postsShowController.postDetail = [self.posts objectAtIndex:indexPath.row];
}

@end
