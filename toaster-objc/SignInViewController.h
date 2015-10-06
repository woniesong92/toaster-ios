//
//  SignInViewController.h
//  Toaster
//
//  Created by Howon Song on 9/19/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UILabel *errorField;
@property (weak, nonatomic) IBOutlet UIView *spinner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintY;

@end
