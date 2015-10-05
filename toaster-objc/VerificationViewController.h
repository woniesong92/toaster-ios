//
//  VerificationViewController.h
//  Toaster
//
//  Created by Howon Song on 10/2/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationViewController : UIViewController

@property NSString *email;
@property (weak, nonatomic) IBOutlet UIView *topSpinner;
@property (weak, nonatomic) IBOutlet UIView *bottomSpinner;
@property (weak, nonatomic) IBOutlet UITextView *subTextView;
@property NSString *defaultSubText;
@property UIColor *defaultSubTextColor;


@end
