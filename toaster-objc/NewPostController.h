//
//  NewPostController.h
//  toaster-objc
//
//  Created by Howon Song on 9/5/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewManager.h"

@interface NewPostController : UIViewController {
    WebViewManager *_webViewManager;
    UILabel *textViewPlaceholder;
}

@property (strong, nonatomic) UIImage *parentScreenImage;
@property (weak, nonatomic) IBOutlet UITextView *postInputField;

@end
