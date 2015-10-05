//
//  NotificationCell.h
//  Toaster
//
//  Created by Howon Song on 9/26/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *notiTypeIcon;
@property (weak, nonatomic) IBOutlet UITextView *notiContent;
@property (weak, nonatomic) IBOutlet UITextView *notiMsg;
@property (weak, nonatomic) IBOutlet UIImageView *isReadIcon;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UIView *cellDivider;

@property NSString *postId;
@property (strong, nonatomic) NSString *notiType; //upvote, downvote, comment
@property BOOL isRead;

@end
