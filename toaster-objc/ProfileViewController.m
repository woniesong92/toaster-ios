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
    
    // Add Loading
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, (self.view.frame.size.height/2-25), self.view.frame.size.width, 50)];
    label.text = @"Yolk..."; //etc...
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    self.loadingText = label;
    [self.view addSubview:label];
    [self.postsTable setDataSource:self.postsTable];
    
    [Utils setGradient:self.filterDivider fromColor:[UIColor whiteColor] toColor:[UIColor colorWithRed:255.0/255.0 green:138.0/255.0 blue:0.0 alpha:1.0]];
    
    // set Tag
    [self.postsTable setTag:POSTS_I_WROTE_TABLE_TAG];
    [self.myPostsBtn setSelected:YES];
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
    } else {
        reqUrl = [NSString stringWithFormat:@"%@/%@/%@", GET_POSTS_I_COMMENTED_ON_URL, limit, skip];
    }
    
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    
    [manager GET:reqUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
            [self.loadingText removeFromSuperview];
        } else {
            self.postsTable.myReplies = [Utils sortByDate:posts isReversed:YES];
            self.postsTable.numCommentsForMyReplies = numCommentsForPosts;
        }
        
        if (doReload) {
            [self.postsTable reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProfileToDetailSegue"]) {
        NSIndexPath *indexPath = [self.postsTable indexPathForSelectedRow];
        PostsShowViewController *postsShowController = (PostsShowViewController *)segue.destinationViewController;
        postsShowController.postDetail = [self.postsTable.posts objectAtIndex:indexPath.row];
        postsShowController.cellRowIdx = [NSNumber numberWithInteger:indexPath.row];
    }
}

@end
