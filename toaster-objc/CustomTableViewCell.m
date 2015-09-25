//
//  CustomTableViewCell.m
//  Toaster
//
//  Created by Howon Song on 9/20/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "AppDelegate.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)toggleSelected:(UIButton *)btn otherBtn:(UIButton *)otherBtn {
    if (btn.selected) {
        [btn setSelected:NO];
    } else {
        [btn setSelected:YES];
    }
    
    if (otherBtn.selected) {
        [otherBtn setSelected:NO];
    }
}

- (IBAction)onUpvotePressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPRequestOperationManager *manager = appDelegate.networkManager;
    
    NSDictionary *params = @{@"postId": self.postId};
    
    [manager POST:UPVOTE_POST_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSNumber *diffVotes = responseObject[@"diffVotes"];
        
//        
//        if (diffVotes.intValue == 1) {
//            [self toggleSelected:self.upvoteBtn otherBtn:self.downvoteBtn];
//            [self.numVotes setText:self.numVotes.text
//        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)onDownvotePressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPRequestOperationManager *manager = appDelegate.networkManager;
    
    NSDictionary *params = @{@"postId": self.postId};
    
    [manager POST:DOWNVOTE_POST_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self toggleSelected:self.downvoteBtn otherBtn:self.upvoteBtn];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

@end
