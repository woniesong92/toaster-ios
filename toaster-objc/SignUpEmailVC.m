//
//  SignUpEmailVC.m
//  Toaster
//
//  Created by Howon Song on 10/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "SignUpEmailVC.h"
#import "SignUpPasswordVC.h"

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
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [self.emailField setSelected:YES];
}

- (IBAction)continueClicked:(id)sender {
    NSString *email = [self.emailField text];
    NSString *emailRegex = @"[A-Z0-9a-z]+([._%+-]{1}[A-Z0-9a-z]+)*@[A-Z0-9a-z]+([.-]{1}[A-Z0-9a-z]+)*(\\.[A-Za-z]{2,4}){0,1}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:email]) {
        // TODO: show alert that email is invalid
        NSLog(@"invalid email format");
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
