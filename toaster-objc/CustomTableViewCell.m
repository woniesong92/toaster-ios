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
- (IBAction)onUpvotePressed:(id)sender {
    NSLog(@"post upvote");
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPRequestOperationManager *manager = appDelegate.networkManager;
    
    NSDictionary *params = @{@"postId": self.postId};
    
    NSLog(@"params %@", params);
    
    [manager GET:UPVOTE_POST_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObj %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)onDownvotePressed:(id)sender {
}

@end
