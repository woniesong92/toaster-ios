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

@implementation ToastsTableView

- (void)reloadData {
    NSLog(@"reloading data!!");
    
    if (self.tag == RECENT_POSTS_TABLE_TAG) {
        self.posts = self.recentPosts;
    } else {
        self.posts = self.hotPosts;
    }
    
    [super reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numPosts: %lu", (unsigned long)self.posts.count);
    return self.posts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *userId = appDelegate.userId;
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