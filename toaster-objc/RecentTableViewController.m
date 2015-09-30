//
//  RecentTableViewController.m
//  Toaster
//
//  Created by Howon Song on 9/19/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "RecentTableViewController.h"
#import "Constants.h"
#import "PostsShowViewController.h"
#import "CustomTableViewCell.h"
#import "SignUpViewController.h"
#import "Utils.h"
#import "Underscore.h"
#import "AppDelegate.h"
#import "SessionManager.h"


#define _ Underscore


@interface RecentTableViewController () {
    NSInteger rowIdxToStartFetchingRecentPosts;
    NSInteger rowIdxToStartFetchingHotPosts;
}

@end

@implementation RecentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize the starting point to fetch the next batch of posts
    rowIdxToStartFetchingRecentPosts = NUM_RECENT_POSTS_IN_ONE_BATCH - 5;
    rowIdxToStartFetchingHotPosts = NUM_HOT_POSTS_IN_ONE_BATCH - 5;
    
    networkManager = [NetworkManager getNetworkManager];

//    Set up Recent Posts Table
    [self.postsTable setDelegate:self];
    [self.postsTable setDataSource:self.postsTable];
    [self.postsTable setTag:0];
    [self.recentFilterBtn setSelected:YES];
    
    // Add Loading
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, (self.view.frame.size.height/2-25), self.view.frame.size.width, 50)];
    label.text = @"Yolk..."; //etc...
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    self.loadingText = label;
    [self.view addSubview:label];
    
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


- (IBAction)newFilterSelected:(id)sender {
    NSLog(@"new btn selected");
    [self.recentFilterBtn setSelected:YES];
    [self.hotFilterBtn setSelected:NO];
    [self.postsTable setTag:RECENT_POSTS_TABLE_TAG];
    [self.postsTable reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:TABLE_SCROLL_TO_TOP object:nil userInfo:nil];
}

- (IBAction)hotFilterSelected:(id)sender {
    NSLog(@"hot btn selected");
    [self.hotFilterBtn setSelected:YES];
    [self.recentFilterBtn setSelected:NO];
    [self.postsTable setTag:HOT_POSTS_TABLE_TAG];
    [self.postsTable reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:TABLE_SCROLL_TO_TOP object:nil userInfo:nil];
}




////    Add a horizontal divider
//    CGRect dividerFrame = CGRectMake(0, 0, width, 2);
//    UIView *divider = [[UIView alloc] initWithFrame:dividerFrame];
//    [divider setBackgroundColor:dividerColor];
//    [self.view addSubview:divider];
//}


- (void)fetchPosts: (NSInteger)postsTableTag limit:(NSNumber *)limit skip:(NSNumber *)skip doReload:(BOOL)doReload {
    
    if ([[SessionManager currentUser] isEqualToString:@""]) {
        return;
    }
    
    AFHTTPRequestOperationManager *manager = networkManager.manager;
    
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
            self.postsTable.recentPosts = [Utils sortByDate:posts isReversed:YES];
            self.postsTable.numCommentsForRecentPosts = numCommentsForPosts;
            [self.loadingText removeFromSuperview];
        } else {
            self.postsTable.hotPosts = [Utils sortPostsByHotness:posts];
            self.postsTable.numCommentsForHotPosts = numCommentsForPosts;
        }
        
        if (doReload) {
            [self.postsTable reloadData];
            NSLog(@"loading ended");
        } else {
            NSLog(@"dont reload");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

- (void)addPostRow:(NSMutableDictionary *)newPost {
    NSString *createdAt = (NSString *)newPost[@"createdAt"];
    [newPost setValue:[Utils dateWithJSONString:createdAt] forKey:@"createdAt"];
    
    [(NSMutableArray *)self.postsTable.posts insertObject:newPost atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.postsTable beginUpdates];
    [self.postsTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.postsTable endUpdates];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"recent posts view will appear");
    
    [super viewWillAppear:animated];
    
    if (![[SessionManager currentUser] isEqualToString:@""] && self.postsTable.posts.count == 0) {
        [self fetchPosts:HOT_POSTS_TABLE_TAG limit:[NSNumber numberWithInteger:NUM_HOT_POSTS_IN_ONE_BATCH] skip:@0 doReload:NO];
        [self fetchPosts:RECENT_POSTS_TABLE_TAG limit:[NSNumber numberWithInteger:NUM_RECENT_POSTS_IN_ONE_BATCH] skip:@0 doReload:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[SessionManager currentUser] isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"PostsToSignUpSegue" sender:self];
    }
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

// HOWON: Turn this on if we want to do dynamic loading
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    ToastsTableView *postsTable = (ToastsTableView *)tableView;
//    
//    if (tableView.tag == RECENT_POSTS_TABLE_TAG) {
//        if (indexPath.row == rowIdxToStartFetchingRecentPosts) {
//            NSLog(@"fetch more recent posts");
//            [self fetchPosts:RECENT_POSTS_TABLE_TAG limit:[NSNumber numberWithInteger:postsTable.posts.count+NUM_RECENT_POSTS_IN_ONE_BATCH] skip:[NSNumber numberWithInteger:postsTable.posts.count] doReload:YES];
//            rowIdxToStartFetchingRecentPosts += NUM_RECENT_POSTS_IN_ONE_BATCH;
//        }
//    } else {
//        if (indexPath.row == rowIdxToStartFetchingHotPosts) {
//            NSLog(@"fetch more hot posts");
//            [self fetchPosts:HOT_POSTS_TABLE_TAG limit:[NSNumber numberWithInteger:postsTable.posts.count+NUM_HOT_POSTS_IN_ONE_BATCH] skip:[NSNumber numberWithInteger:postsTable.posts.count] doReload:YES];
//            rowIdxToStartFetchingHotPosts += NUM_HOT_POSTS_IN_ONE_BATCH;
//        }
//    }
//}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PostsToDetailSegue"]) {
        NSIndexPath *indexPath = [self.postsTable indexPathForSelectedRow];
        PostsShowViewController *postsShowController = (PostsShowViewController *)segue.destinationViewController;
        postsShowController.postDetail = [self.postsTable.posts objectAtIndex:indexPath.row];
        postsShowController.cellRowIdx = [NSNumber numberWithInteger:indexPath.row];
    }
}

@end
