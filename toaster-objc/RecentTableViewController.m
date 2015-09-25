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
#import "CustomTableViewCell.h"
#import "SignUpViewController.h"
#import "Utils.h"
#import "Underscore.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#define _ Underscore


@interface RecentTableViewController ()

@end

@implementation RecentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchPosts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldFetchPosts:)
                                                 name:ASK_TO_FETCH_POSTS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldScrollTop:)
                                                 name:TABLE_SCROLL_TO_TOP
                                               object:nil];
}


- (void)fetchPosts {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPRequestOperationManager *manager = appDelegate.networkManager;
    
    NSDictionary *params = @{};
    
    [manager GET:GET_RECENT_POSTS_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSArray *posts = responseObject[@"posts"];
        
        NSArray *comments = responseObject[@"comments"];
        NSMutableDictionary *numCommentsForPosts = [[NSMutableDictionary alloc] init];
        
        for (NSDictionary *comment in comments) {
            NSString *key = comment[@"postId"];
            NSNumber *numComments = [numCommentsForPosts objectForKey:key];
            if (numComments) {
                NSNumber *newNumComments = [NSNumber numberWithInt: (numComments.intValue + 1)];
                [numCommentsForPosts setValue:newNumComments forKey:key];
            } else {
                [numCommentsForPosts setValue:[NSNumber numberWithInt:1] forKey:key];
            }
        }
        
        NSArray *sortedPosts = [Utils sortReversedJSONObjsByDate:posts];
        self.posts = sortedPosts;
        self.numCommentsForPosts = numCommentsForPosts;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

//
//- (void)fetchPosts {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:@"token"];
//    NSString *authorizationToken = [NSString stringWithFormat:@"Bearer %@", token];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
//    
//    NSDictionary *params = @{};
//    [manager GET:GET_RECENT_POSTS_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        NSArray *posts = responseObject[@"posts"];
//
//        NSArray *comments = responseObject[@"comments"];
//        NSMutableDictionary *numCommentsForPosts = [[NSMutableDictionary alloc] init];
//        
//        for (NSDictionary *comment in comments) {
//            NSString *key = comment[@"postId"];
//            NSNumber *numComments = [numCommentsForPosts objectForKey:key];
//            if (numComments) {
//                NSNumber *newNumComments = [NSNumber numberWithInt: (numComments.intValue + 1)];
//                [numCommentsForPosts setValue:newNumComments forKey:key];
//            } else {
//                [numCommentsForPosts setValue:[NSNumber numberWithInt:1] forKey:key];
//            }
//        }
//        
//        NSArray *sortedPosts = [Utils sortReversedJSONObjsByDate:posts];
//        self.posts = sortedPosts;
//        self.numCommentsForPosts = numCommentsForPosts;
//        [self.tableView reloadData];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        // TODO: show user this error and clear all the textfields
//        NSLog(@"Error: %@", error);
//    }];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)shouldFetchPosts:(NSNotification *)notification {
    [self fetchPosts];
}

- (void)shouldScrollTop:(NSNotification *)notification {
    [self.postsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *postObj= [self.posts objectAtIndex:indexPath.row];
    NSString *postId = postObj[@"_id"];
    NSString *createdAt = [Utils stringFromDate:[postObj objectForKey:@"createdAt"]];
    NSNumber *numComments = [self.numCommentsForPosts objectForKey:postId];
    if (!numComments) {
        numComments = [NSNumber numberWithInt:0];
    }

    cell.postId = postId;
    [cell.postBody setText:[postObj objectForKey:@"body"]];
    [cell.postDate setText:createdAt];
    [cell.numComments setText:[NSString stringWithFormat:@"%@", numComments]];
    [cell.numVotes setText:[NSString stringWithFormat:@"%@", [postObj objectForKey:@"numLikes"]]];

    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"postsShowSegue1"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PostsShowViewController *postsShowController = (PostsShowViewController *)segue.destinationViewController;
        postsShowController.postDetail = [self.posts objectAtIndex:indexPath.row];
    }
}

@end
