//
//  ProfileViewController.m
//  Toaster
//
//  Created by Howon Song on 9/27/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "ProfileViewController.h"
#import "Constants.h"
#import "PostsShowViewController.h"
#import "CustomTableViewCell.h"
#import "Utils.h"
#import "AppDelegate.h"

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // top margin for table
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    CGFloat navbarHeight = self.navigationController.navigationBar.frame.size.height;
//    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
//    CGFloat filterBtnsContainerHeight = 36.0;
//    CGFloat insetTopMargin = navbarHeight + statusHeight + filterBtnsContainerHeight;
//    [self.postsTable setContentInset:UIEdgeInsetsMake(insetTopMargin,0,tabBarHeight,0)];
//    

    
    
    // Add buttons
//    [self addFilterBtns:filterBtnsContainerHeight];
    
    // initialize the starting point to fetch the next batch of posts
//    rowIdxToStartFetchingRecentPosts = NUM_RECENT_POSTS_IN_ONE_BATCH - 5;
//    rowIdxToStartFetchingHotPosts = NUM_HOT_POSTS_IN_ONE_BATCH - 5;
//
    
    [self.postsTable setDataSource:self.postsTable];
    
    networkManager = [NetworkManager getNetworkManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchPosts:POSTS_I_WROTE_TABLE_TAG limit:@100 skip:@0 doReload:YES];
    [self fetchPosts:POSTS_I_COMMENTED_ON_TABLE_TAG limit:@100 skip:@0 doReload:NO];
}

- (void)fetchPosts: (NSInteger)postsTableTag limit:(NSNumber *)limit skip:(NSNumber *)skip doReload:(BOOL)doReload {
    
    NSString *reqUrl;
    
    if (postsTableTag == POSTS_I_WROTE_TABLE_TAG) {
        reqUrl = [NSString stringWithFormat:@"%@/%@/%@", GET_POSTS_I_WROTE_URL, limit, skip];
        NSLog(@"fetching the posts I wrote");
    } else {
        reqUrl = [NSString stringWithFormat:@"%@/%@/%@", GET_POSTS_I_COMMENTED_ON_URL, limit, skip];
        NSLog(@"fetching my replies");
    }
    
    AFHTTPRequestOperationManager *manager = networkManager.manager;
    
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
        
        if (postsTableTag == POSTS_I_WROTE_TABLE_TAG) {
            self.postsTable.myPosts = [Utils sortByDate:posts isReversed:YES];
            self.postsTable.numCommentsForMyPosts = numCommentsForPosts;
        } else {
            self.postsTable.myReplies = [Utils sortByDate:posts isReversed:YES];
            self.postsTable.numCommentsForMyReplies = numCommentsForPosts;
        }
        
        if (doReload) {
            [self.postsTable reloadData];
        } else {
            NSLog(@"dont reload");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)myRepliesSelected:(id)sender {
    [self.myPostsBtn setSelected:NO];
    [self.myRepliesBtn setSelected:YES];
    [self.postsTable setTag:POSTS_I_COMMENTED_ON_TABLE_TAG];
    [self.postsTable reloadData];
}

- (IBAction)myPostsSelected:(id)sender {
    [self.myPostsBtn setSelected:YES];
    [self.myRepliesBtn setSelected:NO];
    [self.postsTable setTag:POSTS_I_WROTE_TABLE_TAG];
    [self.postsTable reloadData];
}

#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"ToastsToDetailSegue"]) {
//        NSIndexPath *indexPath = [self.postsTable indexPathForSelectedRow];
//        PostsShowViewController *postsShowController = (PostsShowViewController *)segue.destinationViewController;
//        postsShowController.postDetail = [self.postsTable.posts objectAtIndex:indexPath.row];
//        postsShowController.cellRowIdx = [NSNumber numberWithInteger:indexPath.row];
//    }
//}



@end
