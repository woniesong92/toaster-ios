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
#import "SessionManager.h"

@implementation PostsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Utils setGradient:self.commentFieldDivider fromColor:[UIColor whiteColor] toColor:[UIColor colorWithRed:255.0/255.0 green:138.0/255.0 blue:0.0 alpha:1.0]];
    
    [self.view bringSubviewToFront:self.commenInputContainer];
    
    // Update the initial information
    NSDictionary *postDetail= self.postDetail;
    NSDate *date = [postDetail objectForKey:@"createdAt"];
    [self.postBody setText:[postDetail objectForKey:@"body"]];
    [self.postDate setText:[Utils stringFromDate:date]];
    self.postId = [postDetail objectForKey:@"_id"];

    self.commentsTable.delegate = self;
    
    self.postBody.textContainer.lineFragmentPadding = 0;
    
    [Utils setGradient:self.postDividerTop fromColor:[UIColor whiteColor] toColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0 alpha:1.0]];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchPostDetail];
    [self fetchComments];
    
    self.inlineCommentField.layer.cornerRadius = 6.0;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    self.inlineCommentField.leftView = paddingView;
    self.inlineCommentField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)fetchPostDetail {
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    NSString *userId = [SessionManager currentUser];
    NSString *postId = self.postDetail[@"_id"];
    NSString *reqURL = [NSString stringWithFormat:@"%@/%@", GET_POST_URL, postId];
    
    [manager GET:reqURL parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *post = responseObject[@"posts"][0];
        
        NSNumber *numVotes = post[@"numLikes"];
        NSArray *upvoters = post[@"upvoterIds"];
        NSArray *downvoters = post[@"downvoterIds"];
        
        if ([upvoters containsObject:userId]) {
            self.didIUpvote = YES;
            [self.upvoteBtn setSelected:YES];
        } else if ([downvoters containsObject:userId]) {
            self.didIDownvote = YES;
            [self.downvoteBtn setSelected:YES];
        }
        [self.numVotes setText:[NSString stringWithFormat:@"%@", numVotes]];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

- (void)shouldFetchComments:(NSNotification *)notification {
    [self fetchComments];
}

- (void)fetchComments {
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    
    NSString *postId = self.postDetail[@"_id"];
    NSString *reqURL = [NSString stringWithFormat:@"%@/%@", GET_COMMENTS_FOR_POST_URL, postId];
    
    [manager GET:reqURL parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *comments = responseObject[@"comments"];
        NSMutableArray *sortedComments = [Utils sortByDate:comments isReversed:NO];
        self.comments = sortedComments;

        [self.numComments setText:[NSString stringWithFormat:@"%lu", (unsigned long)[self.comments count]]];
        
        [self.commentsTable reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *userId = [SessionManager currentUser];
    NSString *cellId = @"CommentCell";
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *commentObj= [self.comments objectAtIndex:indexPath.row];
    
    NSString *createdAt = [Utils stringFromDate:[commentObj objectForKey:@"createdAt"]];
    
    cell.commentId = commentObj[@"_id"];
    [cell.commentBody setText:[commentObj objectForKey:@"body"]];
    [cell.commentDate setText:createdAt];
    [cell.numVotes setText:[NSString stringWithFormat:@"%@", [commentObj objectForKey:@"numLikes"]]];
    [cell.commentAuthor setText:[commentObj objectForKey:@"nameTag"]];
    
    if ([(NSArray *)commentObj[@"upvoterIds"] containsObject:userId]) {
        cell.didIUpvote = YES;
        [cell.upvoteBtn setSelected:YES];
    } else if ([(NSArray *)commentObj[@"downvoterIds"] containsObject:userId]) {
        cell.didIDownvote = YES;
        [cell.downvoteBtn setSelected:YES];
    }
    
    return cell;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
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

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    // I don't want to be a tabbar delegate anymore
    [super viewDidDisappear:animated];
}

- (void)addCommentRow:(NSMutableDictionary *)newComment {
    NSString *createdAt = (NSString *)newComment[@"createdAt"];
    [newComment setValue:[Utils dateWithJSONString:createdAt] forKey:@"createdAt"];
    [self.comments addObject:newComment];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.comments.count-1 inSection:0];
    [self.commentsTable beginUpdates];
    [self.commentsTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.commentsTable endUpdates];
}

- (IBAction)onSubmitComment:(id)sender {
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    NSString *commentBody = self.inlineCommentField.text;
    NSString *postId = self.postDetail[@"_id"];
    
    [self.inlineCommentField setText:@""];
    [self.view endEditing:YES];
    
    NSDictionary *params = @{@"commentBody": commentBody, @"postId": postId};
    [manager POST:NEW_COMMENT_API_URL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [self addCommentRow:responseObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:TABLE_SCROLL_TO_BOTTOM object:nil userInfo:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)toggleSelected:(UIButton *)btn{
    if (btn.selected) {
        [btn setSelected:NO];
    } else {
        [btn setSelected:YES];
    }
}


- (IBAction)onPostUpvote:(id)sender {
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    
    NSDictionary *params = @{@"postId": self.postId};
    
    if (self.didIDownvote) {
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue+2]];
        self.didIDownvote = NO;
        self.didIUpvote = YES;
        [self toggleSelected:self.upvoteBtn];
        [self toggleSelected:self.downvoteBtn];
    } else if (self.didIUpvote) {
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue-1]];
        self.didIUpvote = NO;
        [self toggleSelected:self.upvoteBtn];
    } else {
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue+1]];
        self.didIUpvote = YES;
        [self toggleSelected:self.upvoteBtn];
    }
    
    [manager POST:UPVOTE_POST_API_URL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger voteDiffInt = [(NSString *)responseObject[@"diffVotes"] integerValue];
        NSNumber *voteDiff = [NSNumber numberWithInteger:voteDiffInt];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UPVOTE_POST_UPDATE object:@{@"postId": self.postId, @"didIUpvote": [NSNumber numberWithBool:self.didIUpvote ], @"didIDownvote": [NSNumber numberWithBool:self.didIDownvote], @"rowIdx":self.cellRowIdx, @"voteDiff": voteDiff } userInfo:nil];
        
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
    
    NSLog(@"on post upvote");
}


- (IBAction)onPostDownvote:(id)sender {
    NetworkManager *manager = [NetworkManager sharedNetworkManager];
    
    if (self.didIDownvote) {
        self.didIDownvote = NO;
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue+1]];
        [self toggleSelected:self.downvoteBtn];
    } else if (self.didIUpvote) {
        self.didIUpvote = NO;
        self.didIDownvote = YES;
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue-2]];
        [self toggleSelected:self.upvoteBtn];
        [self toggleSelected:self.downvoteBtn];
    } else {
        self.didIDownvote = YES;
        [self.numVotes setText:[NSString stringWithFormat:@"%d", self.numVotes.text.intValue-1]];
        [self toggleSelected:self.downvoteBtn];
    }
    
    NSDictionary *params = @{@"postId": self.postId};
    
    [manager POST:DOWNVOTE_POST_API_URL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        NSInteger voteDiffInt = [(NSString *)responseObject[@"diffVotes"] integerValue];
        NSNumber *voteDiff = [NSNumber numberWithInteger:voteDiffInt];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DOWNVOTE_POST_UPDATE object:@{@"postId": self.postId, @"didIUpvote": [NSNumber numberWithBool:self.didIUpvote ], @"didIDownvote": [NSNumber numberWithBool:self.didIDownvote], @"rowIdx":self.cellRowIdx, @"voteDiff":voteDiff} userInfo:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
}

@end

