//
//  NewPostController.m
//  toaster-objc
//
//  Created by Howon Song on 9/5/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "NewPostController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface NewPostController ()

@end

@implementation NewPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.postInputField setDelegate:self];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    NSUInteger length = range.length;
    
    NSUInteger textLength = [[textView text] length] + [text length] - range.length;
    
    if (textLength <= 140) {
        [self.numCharsField setText:[NSString stringWithFormat:@"%lu", (unsigned long)textLength]];
    }
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self doneButtonPressed:self];
        return NO;
    }
    
    return (textLength <= 140);
}

- (void)viewWillAppear:(BOOL)animated {
    [self.postInputField becomeFirstResponder];
    
    CGFloat frameWidth = self.postInputField.frame.size.width;
    textViewPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(7, -18, frameWidth, 200)];
    textViewPlaceholder.text = POST_PLACEHOLDER;
    [textViewPlaceholder setFont:[UIFont systemFontOfSize:16]];
    textViewPlaceholder.textColor = [UIColor lightGrayColor];
    [self.view addSubview:textViewPlaceholder];
    
    [super viewWillAppear:animated];
    
    [self observeKeyboard];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        [self.view addSubview:textViewPlaceholder];
    } else {
        [textViewPlaceholder removeFromSuperview];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(id)sender {
    NSString *postBody = self.postInputField.text;
    
    if ((postBody.length < 2) || (postBody.length > 500)) {
        NSLog(@"too long or too short");
        return;
    }
    
    NSDictionary *params = @{@"postBody": postBody};
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    
    [manager POST:NEW_POST_API_URL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ASK_TO_ADD_POST_ROW object:responseObject userInfo:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
    [self dismissViewControllerAnimated:YES completion:^{
        // Consider adding a fake post object for optimization
        [[NSNotificationCenter defaultCenter] postNotificationName:TABLE_SCROLL_TO_TOP object:nil userInfo:nil];
    }];
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
    self.bottomFieldConstraint.constant = height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.bottomFieldConstraint.constant = 0.0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
