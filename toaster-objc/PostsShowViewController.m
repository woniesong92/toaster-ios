//
//  PostsShowViewController.m
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "PostsShowViewController.h"
#import "AppDelegate.h"
//#import "Constants.h"

@implementation PostsShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"PostsSHow View did load");
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////    [self.viewContainer addSubview: appDelegate.singleWebView];
////    
////    CGRect screenRect = [[UIScreen mainScreen] bounds];
////    UIWebView *tmpWebView = appDelegate.singleWebView;
////    tmpWebView.frame = screenRect;
////    
////    [self.view addSubview:tmpWebView];
////
//    UIWebView *webView = appDelegate.singleWebView;
//    webView.frame = [self view].frame;
//    webView.delegate = self;
//    [[self view] addSubview:webView];
    
//    
//    UIWebView *tmp = [[UIWebView alloc] initWithFrame:[self view].frame];
//    tmp.delegate = self;
//    [[self view] addSubview:tmp];
//    
//    NSURL *url = [NSURL URLWithString:@"http://google.com"];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [tmp loadRequest:urlRequest];
    
    
    NSLog(@"PostsSHowVIew will Appear, is Webview ready?");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    [self.viewContainer addSubview: appDelegate.singleWebView];
    //
    //    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //    UIWebView *tmpWebView = appDelegate.singleWebView;
    //    tmpWebView.frame = screenRect;
    //
    //    [self.view addSubview:tmpWebView];
    //
    UIWebView *webView = appDelegate.singleWebView;
    webView.frame = [self view].frame;
    webView.delegate = self;
    [[self view] addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
