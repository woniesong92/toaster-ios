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
#import "Utils.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    NSLog(@"set gradient");
    [Utils setGradient:self.divider fromColor:[UIColor whiteColor] toColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    [Utils setGradient:self.profileCellDivider fromColor:[UIColor whiteColor] toColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    _gradientLayer.frame = self.bounds;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)toggleSelected:(UIButton *)btn{
    if (btn.selected) {
        [btn setSelected:NO];
    } else {
        [btn setSelected:YES];
    }
}

- (IBAction)onUpvotePressed:(id)sender {
    AFHTTPRequestOperationManager *manager = [NetworkManager getNetworkManager].manager;
    
    NSDictionary *params = @{@"postId": self.postId};
    
    if (self.didIDownvote) {
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue+2]];
        self.didIDownvote = NO;
        self.didIUpvote = YES;
        [self toggleSelected:self.upvoteBtn];
        [self toggleSelected:self.downvoteBtn];
    } else if (self.didIUpvote) {
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue-1]];
        self.didIUpvote = NO;
        [self toggleSelected:self.upvoteBtn];
    } else {
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue+1]];
        self.didIUpvote = YES;
        [self toggleSelected:self.upvoteBtn];
    }
    
    [manager POST:UPVOTE_POST_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
//        Should validate one more time here?
//        NSNumber *diffVotes = responseObject[@"diffVotes"];
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
    AFHTTPRequestOperationManager *manager = [NetworkManager getNetworkManager].manager;
    
    NSDictionary *params = @{@"postId": self.postId};
    
    if (self.didIDownvote) {
        self.didIDownvote = NO;
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue+1]];
        [self toggleSelected:self.downvoteBtn];
    } else if (self.didIUpvote) {
        self.didIUpvote = NO;
        self.didIDownvote = YES;
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue-2]];
        [self toggleSelected:self.upvoteBtn];
        [self toggleSelected:self.downvoteBtn];
    } else {
        self.didIDownvote = YES;
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue-1]];
        [self toggleSelected:self.downvoteBtn]  ;
    }
    
    [manager POST:DOWNVOTE_POST_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        Should validate one more time here
        //        NSNumber *diffVotes = responseObject[@"diffVotes"];
        //        if (diffVotes.intValue == 1) {
        //            [self toggleSelected:self.upvoteBtn otherBtn:self.downvoteBtn];
        //            [self.numVotes setText:self.numVotes.text
        //        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

//gradient

- (void) setGradient {
    UIView *view = self.divider;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
}

@end
