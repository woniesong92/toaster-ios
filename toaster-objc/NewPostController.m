//
//  NewPostController.m
//  toaster-objc
//
//  Created by Howon Song on 9/5/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "NewPostController.h"
#import "Constants.h"
//#import "WebViewManager.h"

@interface NewPostController ()

@end

@implementation NewPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.postInputField becomeFirstResponder];
    
    CGFloat frameWidth = self.postInputField.frame.size.width;
    textViewPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, frameWidth, 200)];
    textViewPlaceholder.text = POST_PLACEHOLDER;
    textViewPlaceholder.textColor = [UIColor lightGrayColor];
    [self.view addSubview:textViewPlaceholder];
    
    [super viewWillAppear:animated];
}

- (void)textViewDidChange:(UITextView *)textView {
//    if (textView.text.length == 0) {
//        [self.view addSubview:textViewPlaceholder];
//        [textViewPlaceholder removeFromSuperview];
//    }
    
    [textViewPlaceholder removeFromSuperview];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(id)sender {
    
//    NSString *js = @"Template.newPost.submitNewPost();";
//    [[_webViewManager webView] evaluateJavaScript:js completionHandler:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
//    Dismiss the keyboard when modal is closed
    [self.view endEditing:YES];
    
    [super viewWillDisappear:NO];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
