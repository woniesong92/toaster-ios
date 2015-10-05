//
//  SignUpEmailVC.m
//  Toaster
//
//  Created by Howon Song on 10/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SignUpEmailVC.h"
#import "SignUpPasswordVC.h"
#import "SessionManager.h"
#import "Constants.h"

@implementation SignUpEmailVC

- (void)viewDidLoad {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.emailField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [self.emailField setSelected:YES];
    [SessionManager clearSession];
    
    self.defaultSubText = self.subTextField.text;
    self.defaultSubTextColor = self.subTextField.textColor;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.subTextField setText:self.defaultSubText];
    [self.subTextField setTextColor:self.defaultSubTextColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.errorMsg) {
        [self clearField];
        [self.subTextField setText:self.errorMsg];
        [self.subTextField setTextColor:ERROR_COLOR];
        self.errorMsg = nil;
    }
}

- (void)clearField {
    [self.emailField setText:@""];
}

- (IBAction)continueClicked:(id)sender {
    NSString *email = [self.emailField text];
    NSString *emailRegex = @"[A-Z0-9a-z]+([._%+-]{1}[A-Z0-9a-z]+)*@[A-Z0-9a-z]+([.-]{1}[A-Z0-9a-z]+)*(\\.[A-Za-z]{2,4}){0,1}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:email]) {
        [self clearField];
        [self.subTextField setText:@"Invalid email format"];
        [self.subTextField setTextColor:ERROR_COLOR];
        return;
    }
    
    [self performSegueWithIdentifier:@"EmailToPasswordSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EmailToPasswordSegue"]) {
        SignUpPasswordVC *vc = (SignUpPasswordVC *)segue.destinationViewController;
        vc.email = [self.emailField text];
    }
}

@end
