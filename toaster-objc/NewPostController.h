//
//  NewPostController.h
//  toaster-objc
//
//  Created by Howon Song on 9/5/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"

@interface NewPostController : UIViewController {
    UILabel *textViewPlaceholder;
}

@property (weak, nonatomic) IBOutlet UITextView *postInputField;

@end
