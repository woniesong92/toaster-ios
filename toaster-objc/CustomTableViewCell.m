//
//  CustomTableViewCell.m
//  Toaster
//
//  Created by Howon Song on 9/20/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"init view?");
    
//    CGRect tmpFrame = self.frame;
//    tmpFrame.size.height = 150;
//    self.frame = tmpFrame;
}

//- (void)didMoveToSuperview {
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
