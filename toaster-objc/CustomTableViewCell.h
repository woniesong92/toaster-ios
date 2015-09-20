//
//  CustomTableViewCell.h
//  Toaster
//
//  Created by Howon Song on 9/20/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *upvoteButton;

@property (weak, nonatomic) IBOutlet UIImageView *downvoteButton;
@property (weak, nonatomic) IBOutlet UILabel *numVotes;
@property (weak, nonatomic) IBOutlet UILabel *numComments;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UILabel *postBody;

@end
