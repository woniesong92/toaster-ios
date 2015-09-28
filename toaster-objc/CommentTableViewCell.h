//
//  CommentTableViewCell.h
//  Toaster
//
//  Created by Howon Song on 9/20/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@interface CommentTableViewCell : UITableViewCell {
    NetworkManager *networkManager;
}


@property (weak, nonatomic) IBOutlet UILabel *commentDate;
@property (weak, nonatomic) IBOutlet UILabel *commentAuthor;
@property (weak, nonatomic) IBOutlet UILabel *numVotes;
@property (weak, nonatomic) IBOutlet UITextView *commentBody;
@property NSString *commentId;
@property BOOL didIDownvote;
@property BOOL didIUpvote;
@property (weak, nonatomic) IBOutlet UIButton *upvoteBtn;
@property (weak, nonatomic) IBOutlet UIButton *downvoteBtn;

@end
