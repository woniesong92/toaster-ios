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
    NSInteger rowIdxToStartFetchingRecentPosts;
    NSInteger rowIdxToStartFetchingHotPosts;
}

@end

@implementation RecentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // top margin for table
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat navbarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat filterBtnsContainerHeight = 36.0;
    CGFloat insetTopMargin = navbarHeight + statusHeight + filterBtnsContainerHeight;
    [self.recentPostsTable setContentInset:UIEdgeInsetsMake(insetTopMargin,0,tabBarHeight,0)];
    
    // Add buttons
    [self addFilterBtns:filterBtnsContainerHeight];
    
    // initialize the starting point to fetch the next batch of posts
    rowIdxToStartFetchingRecentPosts = NUM_RECENT_POSTS_IN_ONE_BATCH - 5;
    rowIdxToStartFetchingHotPosts = NUM_HOT_POSTS_IN_ONE_BATCH - 5;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    manager = appDelegate.networkManager;
    
//    // second view controller
//    HotTableViewController *hotTableVC = [[HotTableViewController alloc] init];
//    [hotTableVC.tableView setDataSource:hotTableVC];
//    [hotTableVC.tableView setDelegate:hotTableVC];
//    self.hotTableVC = hotTableVC;
//    self.hotPostsTable = hotTableVC.tableView;
//
    
//    Set up Recent Posts Table
    [self.recentPostsTable setDelegate:self];
    [self.recentPostsTable setDataSource:self];
    [self.recentPostsTable setTag:0];
    
//    Set up hot Posts Table
    UITableView *hotPostsTable = [[UITableView alloc] initWithFrame:self.recentPostsTable.frame style:self.recentPostsTable.style];
    [hotPostsTable setDelegate:self];
    [hotPostsTable setDataSource:self];
    [hotPostsTable setTag:1];
    self.hotPostsTable = hotPostsTable;
    
    [self fetchPosts:RECENT_POSTS_TABLE_TAG limit:[NSNumber numberWithInteger:NUM_RECENT_POSTS_IN_ONE_BATCH] skip:@0];
    [self fetchPosts:HOT_POSTS_TABLE_TAG limit:[NSNumber numberWithInteger:NUM_HOT_POSTS_IN_ONE_BATCH] skip:@0];
    
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

- (void)addFilterBtns: (CGFloat)height {
    CGFloat width = self.view.frame.size.width;
    CGFloat widthBtn = width / 2.0;
    CGRect newRect = CGRectMake(0.0f, -height, widthBtn, height);
    CGRect hotRect = CGRectMake(widthBtn, -height, widthBtn, height);
    UIColor *disabledColor = [UIColor colorWithRed:255/255.0 green:70/255.0 blue:79/255.0 alpha:0.3];
    UIColor *dividerColor = [UIColor colorWithRed:255/255.0 green:70/255.0 blue:79/255.0 alpha:1.0];
    UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:70/255.0 blue:79/255.0 alpha:1.0];
    
    UIButton *recentBtn = [[UIButton alloc] initWithFrame:newRect];
    UIButton *hotBtn = [[UIButton alloc] initWithFrame:hotRect];
    [recentBtn setSelected:YES];
    self.hotBtn = hotBtn;
    self.recentBtn = recentBtn;
    
    [recentBtn setTitle:@"New" forState:UIControlStateNormal];
    [hotBtn setTitle:@"Hot" forState:UIControlStateNormal];
    
    [recentBtn setTitleColor:disabledColor forState:UIControlStateNormal];
    [recentBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    [hotBtn setTitleColor:disabledColor forState:UIControlStateNormal];
    [hotBtn setTitleColor:selectedColor forState:UIControlStateSelected];
    
    [recentBtn addTarget:self
               action:@selector(recentBtnSelected:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [hotBtn addTarget:self
               action:@selector(hotBtnSelected:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:recentBtn];
    [self.view addSubview:hotBtn];
    
//    Add a horizontal divider
    CGRect dividerFrame = CGRectMake(0, 0, width, 2);
    UIView *divider = [[UIView alloc] initWithFrame:dividerFrame];
    [divider setBackgroundColor:dividerColor];
    [self.view addSubview:divider];
}

- (void)recentBtnSelected: (UIButton *)btn {
    NSLog(@"new btn selected");
    [self.recentBtn setSelected:YES];
    [self.hotBtn setSelected:NO];

    NSLog(@"change to recentPostsTable!");
    self.tableView = self.recentPostsTable;
}

- (void)hotBtnSelected: (UIButton *)btn {
    NSLog(@"hot btn selected");
    [self.hotBtn setSelected:YES];
    [self.recentBtn setSelected:NO];
    
    NSLog(@"change to hotPostsTable!");
    self.tableView = self.hotPostsTable;
}


- (void)fetchPosts: (NSInteger *)postsTableTag limit:(NSNumber *)limit skip:(NSNumber *)skip {
    
    NSString *reqUrl;
    
    if (postsTableTag == RECENT_POSTS_TABLE_TAG) {
        reqUrl = [NSString stringWithFormat:@"%@/%@/%@", GET_RECENT_POSTS_URL, limit, skip];
        NSLog(@"fetching recent table posts");
    } else {
        reqUrl = [NSString stringWithFormat:@"%@/%@/%@", GET_HOT_POSTS_URL, limit, skip];
        NSLog(@"fetching hot table posts");
    }
    
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
        
        if (postsTableTag == RECENT_POSTS_TABLE_TAG) {
            self.recentPosts = [Utils sortReversedJSONObjsByDate:posts];
            self.numCommentsForRecentPosts = numCommentsForPosts;
            self.currentPosts = self.recentPosts;
            self.numCommentsForCurrentPosts = numCommentsForPosts;
        } else {
            
            self.hotPosts = [Utils sortReversedJSONObjsByDate:posts];
            self.currentPosts = self.hotPosts;
            self.numCommentsForHotPosts = numCommentsForPosts;
            self.numCommentsForCurrentPosts = numCommentsForPosts;
        }
        
        NSLog(@"gonna call reloadData");
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

- (void)addPostRow:(NSMutableDictionary *)newPost {
    NSString *createdAt = (NSString *)newPost[@"createdAt"];
    [newPost setValue:[Utils dateWithJSONString:createdAt] forKey:@"createdAt"];
    [self.currentPosts insertObject:newPost atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
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
    NSLog(@"should fetch more posts called");
//    [self fetchPosts:@0 skip:@0];
}

- (void)shouldScrollTop:(NSNotification *)notification {
//    [self.postsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)onUpdateVoteState:(NSNotification *)notification {
    NSInteger rowIdx = [(NSNumber *) notification.object[@"rowIdx"] intValue];
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:rowIdx inSection:0];
    CustomTableViewCell *cell = (CustomTableViewCell *)[self.recentPostsTable cellForRowAtIndexPath:idxPath];
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
    if (tableView.tag == RECENT_POSTS_TABLE_TAG) {
        NSLog(@"recent post count %lu", (unsigned long)[self.recentPosts count]);
        return [self.recentPosts count];
    } else {
        NSLog(@"hot post count %lu", (unsigned long)[self.hotPosts count]);
        return [self.hotPosts count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *userId = appDelegate.userId;
    NSString *cellId = @"Cell";
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *postObj;
    
    if (tableView.tag == RECENT_POSTS_TABLE_TAG) {
        postObj= [self.recentPosts objectAtIndex:indexPath.row];
    } else {
        postObj= [self.hotPosts objectAtIndex:indexPath.row];
    }
    
    NSString *postId = postObj[@"_id"];
    NSString *createdAt = [Utils stringFromDate:[postObj objectForKey:@"createdAt"]];
    NSNumber *numComments = [self.numCommentsForCurrentPosts objectForKey:postId];
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
    
    if (tableView.tag == RECENT_POSTS_TABLE_TAG) {
        if (indexPath.row == rowIdxToStartFetchingRecentPosts) {
            [self fetchPosts:RECENT_POSTS_TABLE_TAG limit:[NSNumber numberWithInteger:self.recentPosts.count+NUM_RECENT_POSTS_IN_ONE_BATCH] skip:[NSNumber numberWithInteger:self.recentPosts.count]];
            rowIdxToStartFetchingRecentPosts += NUM_RECENT_POSTS_IN_ONE_BATCH;
        }
    } else {
        if (indexPath.row == rowIdxToStartFetchingHotPosts) {
            [self fetchPosts:HOT_POSTS_TABLE_TAG limit:[NSNumber numberWithInteger:self.hotPosts.count+NUM_HOT_POSTS_IN_ONE_BATCH] skip:[NSNumber numberWithInteger:self.hotPosts.count]];
            rowIdxToStartFetchingHotPosts += NUM_HOT_POSTS_IN_ONE_BATCH;
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"postsShowSegue1"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PostsShowViewController *postsShowController = (PostsShowViewController *)segue.destinationViewController;
        postsShowController.postDetail = [self.currentPosts objectAtIndex:indexPath.row];
        postsShowController.cellRowIdx = [NSNumber numberWithInteger:indexPath.row];
    }
}

@end
