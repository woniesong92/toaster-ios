//
//  CommentTableViewCell.m
//  Toaster
//
//  Created by Howon Song on 9/20/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.commentBody.textContainer.lineFragmentPadding = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onCommentUpvote:(id)sender {
    AFHTTPRequestOperationManager *manager = [NetworkManager getNetworkManager].manager;
    
    NSDictionary *params = @{@"commentId": self.commentId};
    
    if (self.didIDownvote) {
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue+2]];
        self.didIDownvote = NO;
        self.didIUpvote = YES;
        [self.upvoteBtn setSelected:self.didIUpvote];
        [self.downvoteBtn setSelected:self.didIDownvote];
    } else if (self.didIUpvote) {
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue-1]];
        self.didIUpvote = NO;
        [self.upvoteBtn setSelected:self.didIUpvote];
    } else {
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue+1]];
        self.didIUpvote = YES;
        [self.upvoteBtn setSelected:self.didIUpvote];
    }
    
    [manager POST:UPVOTE_COMMENT_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];

    
    NSLog(@"on comment upvote");
}

- (IBAction)onCommentDownvote:(id)sender {
    NSLog(@"on comment downvote");
    AFHTTPRequestOperationManager *manager = [NetworkManager getNetworkManager].manager;
    
    NSDictionary *params = @{@"commentId": self.commentId};
    
    if (self.didIDownvote) {
        self.didIDownvote = NO;
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue+1]];
        [self.downvoteBtn setSelected:self.didIDownvote];
    } else if (self.didIUpvote) {
        self.didIUpvote = NO;
        self.didIDownvote = YES;
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue-2]];
        [self.downvoteBtn setSelected:self.didIDownvote];
        [self.upvoteBtn setSelected:self.didIUpvote];
    } else {
        self.didIDownvote = YES;
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue-1]];
        [self.downvoteBtn setSelected:self.downvoteBtn];
    }
    
    [manager POST:DOWNVOTE_COMMENT_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

@end
