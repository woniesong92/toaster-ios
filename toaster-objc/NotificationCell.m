//
//  NotificationCell.m
//  Toaster
//
//  Created by Howon Song on 9/26/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "NotificationCell.h"
#import "Utils.h"

@implementation NotificationCell

- (void)layoutSubviews {
    [Utils setGradient:self.cellDivider fromColor:[UIColor whiteColor] toColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    
    [self setIcons];
}

- (void)setIcons {
    if (self.isRead) {
        [self.isReadIcon setImage:[UIImage imageNamed:@"small-circle"]];
    } else {
        [self.isReadIcon setImage:[UIImage imageNamed:@"small-circle-selected"]];
    }
    
    if ([self.notiType isEqualToString:@"upvote"]) {
        [self.notiTypeIcon setImage:[UIImage imageNamed:@"noti-upvote"]];
    } else if ([self.notiType isEqualToString:@"downvote"]) {
        [self.notiTypeIcon setImage:[UIImage imageNamed:@"noti-upvote"]];
    } else if ([self.notiType isEqualToString:@"comment"]) {
        [self.notiTypeIcon setImage:[UIImage imageNamed:@"noti-comment"]];
    }
}

@end

