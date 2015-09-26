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
#define _ Underscore


@interface RecentTableViewController () {
    NSInteger rowIdxToStartFetchingPosts;
}

@end

@implementation RecentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.postsTable.delegate = self;
    
    // initialize the starting point to fetch the next batch of posts
    rowIdxToStartFetchingPosts = NUM_POSTS_IN_ONE_BATCH - 5;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    manager = appDelegate.networkManager;
    
    [self fetchPosts:[NSNumber numberWithInteger:NUM_POSTS_IN_ONE_BATCH] skip:@0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldFetchPosts:)
                                                 name:ASK_TO_FETCH_POSTS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAddPostRow:)
                                                 name:ASK_TO_ADD_POST_ROW
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldScrollTop:)
                                                 name:TABLE_SCROLL_TO_TOP
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUpdateVoteState:)
                                                 name:UPVOTE_POST_UPDATE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUpdateVoteState:)
                                                 name:DOWNVOTE_POST_UPDATE
                                               object:nil];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat actualPosition = scrollView.contentOffset.y + navBarHeight + statusBarHeight + tabBarHeight;
//    CGFloat contentHeight = scrollView.contentSize.height;
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    cellHeight = [self.postsTable rectForRowAtIndexPath:indexPath].size.height;
//    
//    
//    NSLog(@"contentHeight %f, actual %f cellHeight %f", contentHeight, actualPosition, cellHeight);
//    if (actualPosition >= contentHeight) {
//        NSLog(@"must reload here");
////        [self.newsFeedData_ addObjectsFromArray:self.newsFeedData_];
////        [self.tableView reloadData];
//    }
//}

- (void)fetchPosts: (NSNumber *)limit skip:(NSNumber *)skip {
    
//    NSDictionary *params = @{@"limit":@20, @"skip":@1};
//        NSDictionary *params = @{};
    
    NSString *reqUrl = [NSString stringWithFormat:@"%@/%@/%@", GET_RECENT_POSTS_URL, limit, skip];
    
    [manager GET:reqUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"req url: %@", operation.request.URL);
        
        NSMutableArray *posts = responseObject[@"posts"];
        NSMutableArray *comments = responseObject[@"comments"];
        
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
        
        self.posts = [Utils sortReversedJSONObjsByDate:posts];
        self.numCommentsForPosts = numCommentsForPosts;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

- (void)addPostRow:(NSMutableDictionary *)newPost {
    NSString *createdAt = (NSString *)newPost[@"createdAt"];
    [newPost setValue:[Utils dateWithJSONString:createdAt] forKey:@"createdAt"];
    [self.posts insertObject:newPost atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.postsTable beginUpdates];
    [self.postsTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.postsTable endUpdates];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)onAddPostRow:(NSNotification *)notification {
    [self addPostRow:(NSMutableDictionary *)notification.object];
}

- (void)shouldFetchPosts:(NSNotification *)notification {
    [self fetchPosts:@0 skip:@0];
}

- (void)shouldScrollTop:(NSNotification *)notification {
    [self.postsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)onUpdateVoteState:(NSNotification *)notification {
    NSInteger rowIdx = [(NSNumber *) notification.object[@"rowIdx"] intValue];
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:rowIdx inSection:0];
    CustomTableViewCell *cell = (CustomTableViewCell *)[self.postsTable cellForRowAtIndexPath:idxPath];
    cell.didIDownvote = [(NSNumber *)notification.object[@"didIDownvote"] boolValue];
    cell.didIUpvote = [(NSNumber *)notification.object[@"didIUpvote"] boolValue];
    if (cell.didIUpvote) {
        [cell.downvoteBtn setSelected:NO];
        [cell.upvoteBtn setSelected:YES];
    } else if (cell.didIDownvote) {
        [cell.upvoteBtn setSelected:NO];
        [cell.downvoteBtn setSelected:YES];
    } else {
        [cell.upvoteBtn setSelected:NO];
        [cell.downvoteBtn setSelected:NO];
    }
    
    NSInteger voteDiff = [(NSNumber *) notification.object[@"voteDiff"] integerValue];
    cell.numVotes.text = [NSString stringWithFormat:@"%ld", cell.numVotes.text.integerValue + voteDiff];
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *userId = appDelegate.userId;
    NSString *cellId = @"Cell";
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *postObj= [self.posts objectAtIndex:indexPath.row];
    NSString *postId = postObj[@"_id"];
    NSString *createdAt = [Utils stringFromDate:[postObj objectForKey:@"createdAt"]];
    NSNumber *numComments = [self.numCommentsForPosts objectForKey:postId];
    if (!numComments) {
        numComments = [NSNumber numberWithInt:0];
    }
    
    if ([postObj[@"upvoterIds"] containsObject:userId]) {
        cell.didIUpvote = YES;
        [cell.upvoteBtn setSelected:YES];
    } else if ([postObj[@"downvoterIds"] containsObject:userId]) {
        cell.didIDownvote = YES;
        [cell.downvoteBtn setSelected:YES];
    } else {
        cell.didIUpvote = NO;
        cell.didIDownvote = NO;
        [cell.upvoteBtn setSelected:NO];
        [cell.downvoteBtn setSelected:NO];
    }

    cell.postId = postId;
    [cell.postBody setText:[postObj objectForKey:@"body"]];
    [cell.postDate setText:createdAt];
    [cell.numComments setText:[NSString stringWithFormat:@"%@", numComments]];
    [cell.numVotes setText:[NSString stringWithFormat:@"%@", [postObj objectForKey:@"numLikes"]]];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == rowIdxToStartFetchingPosts) {
        [self fetchPosts:[NSNumber numberWithInteger:self.posts.count+NUM_POSTS_IN_ONE_BATCH] skip:[NSNumber numberWithInteger:self.posts.count]];
        rowIdxToStartFetchingPosts += NUM_POSTS_IN_ONE_BATCH;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"postsShowSegue1"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PostsShowViewController *postsShowController = (PostsShowViewController *)segue.destinationViewController;
        postsShowController.postDetail = [self.posts objectAtIndex:indexPath.row];
        postsShowController.cellRowIdx = [NSNumber numberWithInteger:indexPath.row];
    }
}

@end
