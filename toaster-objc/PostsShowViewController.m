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
#import "CommentTableViewCell.h"
#import "Utils.h"

@implementation PostsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self observeKeyboard];
    
    _loadingManager = [LoadingManager getLoadingManager:self];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSDictionary *tempDictionary= self.postDetail;
    NSString *postId = [tempDictionary objectForKey:@"_id"];
    NSDate *date = [tempDictionary objectForKey:@"createdAt"];
    
    [self.postBody setText:[tempDictionary objectForKey:@"body"]];
    [self.postDate setText:[Utils stringFromDate:date]];
    [self.numVotes setText:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"numLikes"]]];
    
    self.commentsTable.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *authorizationToken = [NSString stringWithFormat:@"Bearer %@", token];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
    

    NSDictionary *params = @{};
    NSString *reqURL = [NSString stringWithFormat:@"%@/%@", GET_COMMENTS_FOR_POST_URL, postId];
    
    [manager GET:reqURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"comments for Post: %@", responseObject);
        self.comments = (NSArray *)responseObject[@"comments"];
        [self.numComments setText:[NSString stringWithFormat:@"%lu", (unsigned long)[self.comments count]]];
        
        [self.commentsTable reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: show user this error and clear all the textfields
        NSLog(@"Error: %@", error);
    }];
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
    
//    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
//    [_webViewManager removeWebViewFromContainer];
//    
//    // Setting delegate for WKWebView
//    [[_webViewManager webView] setDelegateViews: self];
//
//    [self.view addSubview: _webViewManager.webView];
//    
//    // Replace webView with a blank image
//    UIImage *whiteImage = [_webViewManager getWhiteImage];
//    [_webViewManager replaceWebViewWithImage:self :whiteImage];
//    
//    [_loadingManager startLoadingIndicator:self];
//    
//    UIScrollView *scrollView = _webViewManager.webView.scrollView;
//    scrollView.delegate = self;
//    _keyboardHeight = 0;
//    _shouldPreventScrolling = NO;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
    
}

- (IBAction)commentSubmitPressed:(id)sender {
    NSLog(@"submit this comment");
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
    NSDictionary *tempDictionary= [self.comments objectAtIndex:indexPath.row];
    
    [cell.commentBody setText:[tempDictionary objectForKey:@"body"]];
    [cell.commentDate setText:[tempDictionary objectForKey:@"createdAt"]];
    [cell.commentNumVotes setText:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"numLikes"]]];
    [cell.commentAuthor setText:[tempDictionary objectForKey:@"nameTag"]];
    
    return cell;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    CGFloat height = keyboardFrame.size.height;
    
    NSLog(@"Updating constraints.");
    // Because the "space" is actually the difference between the bottom lines of the 2 views,
    // we need to set a negative constant value here.
//    self.keyboardHeight.constant = -height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}


//- (void)keyboardWillShow: (NSNotification *)notification {
//    if (_keyboardHeight == 0) {
//        NSDictionary* keyboardInfo = [notification userInfo];
//        NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
//        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
//        _keyboardHeight = keyboardFrameBeginRect.size.height;
//        _scrollViewOrigin = _webViewManager.webView.scrollView.contentOffset;
//    }
//    
//    _shouldPreventScrolling = YES;
//    NSString *js = [NSString stringWithFormat:@"Template.postsShow.MoveUpCommentInput(%f);", _keyboardHeight];
//    [[_webViewManager webView] evaluateJavaScript:js completionHandler:nil];
//}

//- (void)keyboardWillHide: (NSNotification *)notification {
//    NSString *js = @"Template.postsShow.MoveDownCommentInput();";
//    [[_webViewManager webView] evaluateJavaScript:js completionHandler:nil];
//    _shouldPreventScrolling = NO;
//}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
//    self.keyboardHeight.constant = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)keyboardDidShow: (NSNotification *)notification {
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_webViewManager.webView.scrollView setContentOffset:_scrollViewOrigin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated {
    // Overshadow my webview with an image just before the transition
    UIImage *whiteImage = [_webViewManager getWhiteImage];
    [_webViewManager replaceWebViewWithImage:self :whiteImage];
    
    _webViewManager.webView.scrollView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}


- (void) viewDidDisappear:(BOOL)animated {
    // I don't want to be a tabbar delegate anymore
    [super viewDidDisappear:animated];
    
    // I get rid of the temporary screenshot that was overshadowing my webview
    [_webViewManager replaceImageWithWebView:self];
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    if (parent == nil){
        [[_webViewManager webView] goBack];
    }
}

#pragma mark - Shared Delegate Methods

/*
 * This is called whenever the web view wants to navigate.
 */
- (BOOL) shouldStartDecidePolicy: (NSURLRequest *) request
{
    // Determine whether or not navigation should be allowed.
    // Return YES if it should, NO if not.
    
    NSURL *URL = [request URL];
    
    NSString *urlString = [URL absoluteString];
    
//    NSLog([NSString stringWithFormat:@"%@ -- %@", @"POSTS-SHOW", urlString]);
    
    if ([urlString isEqualToString:@"toasterapp://loadingEnd"]) {
        [_loadingManager stopLoadingIndicator];
        [_webViewManager replaceImageWithWebView:self];
        return false;
    }
    
    return true;
}

/*
 * This is called whenever the web view has started navigating.
 */
- (void) didStartNavigation
{
    // Update things like loading indicators here.
}

/*
 * This is called when navigation failed.
 */
- (void) failLoadOrNavigation: (NSURLRequest *) request withError: (NSError *) error
{
    // Notify the user that navigation failed, provide information on the error, and so on.
}

/*
 * This is called when navigation succeeds and is complete.
 */
- (void) finishLoadOrNavigation: (NSURLRequest *) request
{
    // Remove the loading indicator, maybe update the navigation bar's title if you have one.
}

#pragma mark - UIWebView Delegate Methods

/*
 * Called on iOS devices that do not have WKWebView when the UIWebView requests to start loading a URL request.
 * Note that it just calls shouldStartDecidePolicy, which is a shared delegate method.
 * Returning YES here would allow the request to complete, returning NO would stop it.
 */
- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType: (UIWebViewNavigationType) navigationType
{
    return [self shouldStartDecidePolicy: request];
}

/*
 * Called on iOS devices that do not have WKWebView when the UIWebView starts loading a URL request.
 * Note that it just calls didStartNavigation, which is a shared delegate method.
 */
- (void) webViewDidStartLoad: (UIWebView *) webView
{
    [self didStartNavigation];
}

/*
 * Called on iOS devices that do not have WKWebView when a URL request load failed.
 * Note that it just calls failLoadOrNavigation, which is a shared delegate method.
 */
- (void) webView: (UIWebView *) webView didFailLoadWithError: (NSError *) error
{
    [self failLoadOrNavigation: [webView request] withError: error];
}

/*
 * Called on iOS devices that do not have WKWebView when the UIWebView finishes loading a URL request.
 * Note that it just calls finishLoadOrNavigation, which is a shared delegate method.
 */
- (void) webViewDidFinishLoad: (UIWebView *) webView
{
    [self finishLoadOrNavigation: [webView request]];
}

#pragma mark - WKWebView Delegate Methods

/*
 * Called on iOS devices that have WKWebView when the web view wants to start navigation.
 * Note that it calls shouldStartDecidePolicy, which is a shared delegate method,
 * but it's essentially passing the result of that method into decisionHandler, which is a block.
 */
- (void) webView: (WKWebView *) webView decidePolicyForNavigationAction: (WKNavigationAction *) navigationAction decisionHandler: (void (^)(WKNavigationActionPolicy)) decisionHandler
{
    decisionHandler([self shouldStartDecidePolicy: [navigationAction request]]);
}

/*
 * Called on iOS devices that have WKWebView when the web view starts loading a URL request.
 * Note that it just calls didStartNavigation, which is a shared delegate method.
 */
- (void) webView: (WKWebView *) webView didStartProvisionalNavigation: (WKNavigation *) navigation
{
    [self didStartNavigation];
}

/*
 * Called on iOS devices that have WKWebView when the web view fails to load a URL request.
 * Note that it just calls failLoadOrNavigation, which is a shared delegate method,
 * but it has to retrieve the active request from the web view as WKNavigation doesn't contain a reference to it.
 */
- (void) webView:(WKWebView *) webView didFailProvisionalNavigation: (WKNavigation *) navigation withError: (NSError *) error
{
    //    [self failLoadOrNavigation: [webView request] withError: error];
}

/*
 * Called on iOS devices that have WKWebView when the web view begins loading a URL request.
 * This could call some sort of shared delegate method, but is unused currently.
 */
- (void) webView: (WKWebView *) webView didCommitNavigation: (WKNavigation *) navigation
{
    // do nothing
}

/*
 * Called on iOS devices that have WKWebView when the web view fails to load a URL request.
 * Note that it just calls failLoadOrNavigation, which is a shared delegate method.
 */
- (void) webView: (WKWebView *) webView didFailNavigation: (WKNavigation *) navigation withError: (NSError *) error
{
    //    [self failLoadOrNavigation: [webView.request] withError: error];
}

/*
 * Called on iOS devices that have WKWebView when the web view finishes loading a URL request.
 * Note that it just calls finishLoadOrNavigation, which is a shared delegate method.
 */
- (void) webView: (WKWebView *) webView didFinishNavigation: (WKNavigation *) navigation
{
    //    [self finishLoadOrNavigation: [webView request]];
}


@end

