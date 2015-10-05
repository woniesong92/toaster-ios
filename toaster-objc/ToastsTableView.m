//
//  ToastsTableView.m
//  Toaster
//
//  Created by Howon Song on 9/26/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "ToastsTableView.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "CustomTableViewCell.h"
#import "Utils.h"
#import "SessionManager.h"

@implementation ToastsTableView

- (void)reloadData {
    NSLog(@"reloading data!!");
    
    if (self.tag == RECENT_POSTS_TABLE_TAG) {
        self.posts = self.recentPosts;
        self.numCommentsForPosts = self.numCommentsForRecentPosts;
    } else {
        self.posts = self.hotPosts;
        self.numCommentsForPosts = self.numCommentsForHotPosts;
    }
    
    [super reloadData];
}

- (void)awakeFromNib {
    self.posts = [[NSMutableArray alloc] init];
    self.hotPosts = [[NSMutableArray alloc] init];
    self.recentPosts = [[NSMutableArray alloc] init];
    self.numCommentsForPosts = [[NSMutableDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAddPostRow:)
                                                 name:ASK_TO_ADD_POST_ROW
                                               object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numPosts: %lu", (unsigned long)self.posts.count);
    return self.posts.count;
}

- (void)onAddPostRow:(NSNotification *)notification {
    NSMutableDictionary *addedPost = (NSMutableDictionary *)notification.object;
    
    NSString *createdAt = (NSString *)addedPost[@"createdAt"];
    [addedPost setValue:[Utils dateWithJSONString:createdAt] forKey:@"createdAt"];
    
    [self.posts insertObject:addedPost atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self beginUpdates];
    [self insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *userId = [SessionManager currentUser];
    NSString *cellId = @"Cell";
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *postObj = [self.posts objectAtIndex:indexPath.row];
    
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

@end
