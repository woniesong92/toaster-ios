//
//  NewPostController.h
//  toaster-objc
//
//  Created by Howon Song on 9/5/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@interface NewPostController : UIViewController <UITextViewDelegate> {
    UILabel *textViewPlaceholder;
}

@property (weak, nonatomic) IBOutlet UITextView *postInputField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomFieldConstraint;
@property (weak, nonatomic) IBOutlet UILabel *numCharsField;

@end
