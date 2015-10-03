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



- (void)awakeFromNib {
    // Initialization code
    
    [Utils setGradient:self.cellDivider fromColor:[UIColor whiteColor] toColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
}

@end
