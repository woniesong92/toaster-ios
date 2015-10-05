//
//  SignUpPasswordVC.m
//  Toaster
//
//  Created by Howon Song on 10/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SignUpPasswordVC.h"
#import "SignUpEmailVC.h"
#import "SessionManager.h"
#import "NetworkManager.h"
#import "VerificationViewController.h"
#import "Constants.h"
#import "Utils.h"

@implementation SignUpPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self observeKeyboard];
}

-(void)dismissKeyboard {
    [self.passwordField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [super viewWillAppear:animated];
    self.defaultSubText = self.subTextField.text;
    self.defaultSubTextColor = self.subTextField.textColor;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];    
    [self.passwordField becomeFirstResponder];
    [self.passwordField setSelected:YES];

}

- (void)clearField {
    [self.passwordField setText:@""];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.subTextField setText:self.defaultSubText];
    [self.subTextField setTextColor:self.defaultSubTextColor];
}

- (IBAction)connectClicked:(id)sender {
    NSString *email = self.email;
    NSString *password = [self.passwordField text];
    
    if ([password length] < 6) {
        [self clearField];
        [self.subTextField setText:@"Password is too short."];
        [self.subTextField setTextColor:ERROR_COLOR];
        return;
    }
    
    // Make a request to backend server to register id
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    
    NSDictionary *params = @{@"email": email,
                             @"password": password};
    
    [Utils showLoadingWheel:self.view frame:self.spinner.frame isWhite:YES];
    
    [manager POST:SIGNUP_API_URL parameters:params success:^(NSURLSessionDataTask *task, id resp) {
        
        [SessionManager updateSession: (NSMutableDictionary *)resp];
        
        [self performSegueWithIdentifier:@"SignUpToVerificationSegue" sender:self];
        
        [Utils hideLoadingWheel:self.view];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSString *emailExists = @"Email already exists.";
        NSString *errMsg = [manager getErrorReason:error];
        
        if ([errMsg isEqualToString:emailExists]) {
            [self clearField];
            SignUpEmailVC *vc = (SignUpEmailVC *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            vc.errorMsg = emailExists;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.subTextField setText:errMsg];
            [self.subTextField setTextColor:ERROR_COLOR];
            [self clearField];
        }
        
        [Utils hideLoadingWheel:self.view];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SignUpToVerificationSegue"]) {
        VerificationViewController *vc = (VerificationViewController *)segue.destinationViewController;
        vc.email = self.email;
    }
}


- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    self.constraintY.constant = (height/2.0 - 20.0) + self.constraintY.constant;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.constraintY.constant = 90.0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
