//
//  SignUpPasswordVC.h
//  Toaster
//
//  Created by Howon Song on 10/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpPasswordVC : UIViewController <UITextFieldDelegate>

@property NSString *email;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextView *subTextField;
@property (weak, nonatomic) IBOutlet UIView *spinner;
@property NSString *defaultSubText;
@property UIColor *defaultSubTextColor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintY;

@end
