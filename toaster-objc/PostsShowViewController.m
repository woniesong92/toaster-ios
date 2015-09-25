//
//  PostsShowViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "PostsShowViewController.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "CommentTableViewCell.h"
#import "Utils.h"

@implementation PostsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    manager = appDelegate.networkManager;
    NSString *userId = appDelegate.userId;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSDictionary *postDetail= self.postDetail;
    NSDate *date = [postDetail objectForKey:@"createdAt"];
    
    [self.postBody setText:[postDetail objectForKey:@"body"]];
    [self.postDate setText:[Utils stringFromDate:date]];
    
    [self fetchPostDetail];
    
    self.commentsTable.delegate = self;
    
    [self fetchComments];
    
    [self observeKeyboard];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldFetchComments:)
                                                 name:ASK_TO_FETCH_COMMENTS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldScrollBottom:)
                                                 name:TABLE_SCROLL_TO_BOTTOM
                                               object:nil];
}

- (void)fetchPostDetail {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    manager = appDelegate.networkManager;
    NSString *userId = appDelegate.userId;
    
    NSString *postId = self.postDetail[@"_id"];
    NSString *reqURL = [NSString stringWithFormat:@"%@/%@", GET_POST_URL, postId];
    NSDictionary *params = @{};
    
    [manager GET:reqURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *post = responseObject[@"posts"][0];
        
        NSNumber *numVotes = post[@"numLikes"];
        NSArray *upvoters = post[@"upvoterIds"];
        NSArray *downvoters = post[@"downvoterIds"];
        
        if ([upvoters containsObject:userId]) {
            self.didUpvote = YES;
            [self.upvoteBtn setSelected:YES];
        } else if ([downvoters containsObject:userId]) {
            self.didDownvote = YES;
            [self.downvoteBtn setSelected:YES];
        }
        [self.numVotes setText:[NSString stringWithFormat:@"%@", numVotes]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];

}

- (void)shouldFetchComments:(NSNotification *)notification {
    [self fetchComments];
}

- (void)fetchComments {
    NSString *postId = self.postDetail[@"_id"];
    NSString *reqURL = [NSString stringWithFormat:@"%@/%@", GET_COMMENTS_FOR_POST_URL, postId];
    NSDictionary *params = @{};
    
    [manager GET:reqURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *comments = responseObject[@"comments"];
        NSArray *sortedComments = [Utils sortJSONObjsByDate:comments];
        self.comments = sortedComments;

        [self.numComments setText:[NSString stringWithFormat:@"%lu", (unsigned long)[self.comments count]]];
        [self.commentsTable reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

-(void)dismissKeyboard {
    [self.inlineCommentField resignFirstResponder];
}

- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.inlineCommentField.layer.cornerRadius = 6.0;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    self.inlineCommentField.leftView = paddingView;
    self.inlineCommentField.leftViewMode = UITextFieldViewModeAlways;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.comments count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"CommentCell";
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *commentObj= [self.comments objectAtIndex:indexPath.row];
    NSString *createdAt = [Utils stringFromDate:[commentObj objectForKey:@"createdAt"]];
    
    [cell.commentBody setText:[commentObj objectForKey:@"body"]];
    [cell.commentDate setText:createdAt];
    [cell.commentNumVotes setText:[NSString stringWithFormat:@"%@", [commentObj objectForKey:@"numLikes"]]];
    [cell.commentAuthor setText:[commentObj objectForKey:@"nameTag"]];
    
    return cell;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;

    // Because the "space" is actually the difference between the bottom lines of the 2 views,
    // we need to set a negative constant value here.
    self.inputContainerBottomConstraint.constant = height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)shouldScrollBottom:(NSNotification *)notification {
    NSLog(@"scrolling bottom");
    NSInteger numberOfRows = [self.commentsTable numberOfRowsInSection:0];
    if (numberOfRows) {
        [self.commentsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRows-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.inputContainerBottomConstraint.constant = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}


- (void) viewDidDisappear:(BOOL)animated {
    // I don't want to be a tabbar delegate anymore
    [super viewDidDisappear:animated];
}

- (IBAction)onSubmitComment:(id)sender {
    NSString *commentBody = self.inlineCommentField.text;
    NSString *postId = self.postDetail[@"_id"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPRequestOperationManager *manager = appDelegate.networkManager;
    
    NSDictionary *params = @{@"commentBody": commentBody, @"postId": postId};
    [manager POST:NEW_COMMENT_API_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ASK_TO_FETCH_COMMENTS object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:TABLE_SCROLL_TO_BOTTOM object:nil userInfo:nil];
        [self.inlineCommentField setText:@""];
        [self.view endEditing:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
    
}


- (IBAction)onPostUpvote:(id)sender {
    NSLog(@"on post upvote");
}


- (IBAction)onPostDownvote:(id)sender {
}


- (void)willMoveToParentViewController:(UIViewController *)parent{
    if (parent == nil){
//        [[_webViewManager webView] goBack];
    }
}

@end

