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
    
//  TODO: why is this position happening?
    CGFloat frameWidth = self.postInputField.frame.size.width;
    textViewPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(4, -16, frameWidth, 200)];
//    textViewPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frameWidth, 200)];
    textViewPlaceholder.text = POST_PLACEHOLDER;
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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPRequestOperationManager *manager = appDelegate.networkManager;
    
    NSString *postBody = self.postInputField.text;
    
    NSDictionary *params = @{@"postBody": postBody};
    [manager POST:NEW_POST_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self dismissViewControllerAnimated:YES completion:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:ASK_TO_FETCH_POSTS object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ASK_TO_ADD_POST_ROW object:responseObject userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:TABLE_SCROLL_TO_TOP object:nil userInfo:nil];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
    

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
