//
//  CustomTableViewCell.h
//  Toaster
//
//  Created by Howon Song on 9/20/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@interface CustomTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *numVotes;
@property (weak, nonatomic) IBOutlet UILabel *numComments;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UITextView *postBody;
@property (weak, nonatomic) IBOutlet UIButton *upvoteBtn;
@property (weak, nonatomic) IBOutlet UIButton *downvoteBtn;

@property BOOL didIDownvote;
@property BOOL didIUpvote;

@property NSString *postId;
@property NSInteger *rowIdx;
@property (weak, nonatomic) IBOutlet UIView *divider;

@end
