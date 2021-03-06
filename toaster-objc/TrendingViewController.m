//
//  TrendingViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "TrendingViewController.h"
#import "PostsShowViewController.h"
#import "Constants.h"
#import "SignUpViewController.h"

@interface TrendingViewController ()

@end

@implementation TrendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _loadingManager = [LoadingManager getLoadingManager:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"trending ViewWillAppear");
    [_webViewManager removeWebViewFromContainer];
    _webViewManager = [WebViewManager getUniqueWebViewManager:self];
    
    // Setting delegate for WKWebView
    [[_webViewManager webView] setDelegateViews: self];
    
    [self.view addSubview: _webViewManager.webView];
    
    // Replace webView with screenImage to make the user believe
    // that the webview is loaded already
    [_webViewManager replaceWebViewWithImage:self :[_webViewManager getWhiteImage]];
    
    if (![_webViewManager.getCurrentTab isEqualToString:TRENDING]) {
        [_webViewManager useRouterWithPath:TRENDING];
    }
    
    // scrollToTop
    [_webViewManager.webView evaluateJavaScript:@"$('.overflow-scroll').scrollTop(0,0)" completionHandler:nil];
    
    [_loadingManager startLoadingIndicator:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
//    [_webViewManager removeWebViewFromContainer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.identifier isEqualToString:@"postsShowSegue2"]) {
//        PostsShowViewController *postsShowVC = (PostsShowViewController *)segue.destinationViewController;
//        self.screenImage = [_webViewManager screencapture:self];
//        
//        self.screenImage = [_webViewManager getWhiteImage];
//        postsShowVC.parentScreenImage = self.screenImage;
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
    
//    NSLog([NSString stringWithFormat:@"%@ -- %@", TRENDING, urlString]);
    
    if ([urlString isEqualToString:@"toasterapp://postsShow"]) {
        [self performSegueWithIdentifier:@"postsShowSegue2" sender:self];
        return false;
    }
    
    if ([urlString isEqualToString:@"toasterapp://loadingEnd"]) {
        [_webViewManager replaceImageWithWebView:self];
        [_loadingManager stopLoadingIndicator];
        return false;
    }
    
    if ([urlString isEqualToString:@"toasterapp://recent"]) {
        [[self tabBarController] setSelectedIndex:RECENT_TAB_INDEX];
        return false;
    }
    
    // FIXME: CODE IS REPEATED.
    if ([[URL absoluteString] isEqualToString:SIGNUP_SCHEME]) {
        SignUpViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpNavVC"];
        [self presentViewController:vc animated:YES completion:nil];
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
