//
//  SignUpEmailVC.h
//  Toaster
//
//  Created by Howon Song on 10/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpEmailVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextView *subTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintY;

@property NSString *errorMsg;
@property NSString *defaultSubText;
@property UIColor *defaultSubTextColor;

@end
