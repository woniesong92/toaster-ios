//
//  PostsShowViewController.h
//  toaster-objc
//
//  Created by Howon Song on 9/3/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewManager.h"
#import "LoadingManager.h"

@interface PostsShowViewController : UIViewController <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    WebViewManager *_webViewManager;
    LoadingManager *_loadingManager;
    CGPoint _scrollViewOrigin;
    BOOL _shouldPreventScrolling;
}

@property (strong, nonatomic) UIImage *parentScreenImage;

@property (strong, nonatomic) NSDictionary *postDetail;
@property (weak, nonatomic) IBOutlet UITextView *postBody;
@property (weak, nonatomic) IBOutlet UILabel *numComments;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UILabel *numVotes;
@property (strong, nonatomic) NSArray *comments;
@property (weak, nonatomic) IBOutlet UITableView *commentsTable;
@property (weak, nonatomic) IBOutlet UITextField *inlineCommentField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;
@end
