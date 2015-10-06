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
    self.automaticallyAdjustsScrollViewInsets = NO;
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

- (void) viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
