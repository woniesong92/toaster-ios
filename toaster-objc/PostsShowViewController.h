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
#import "AFNetworking.h"
#import "NetworkManager.h"

@interface PostsShowViewController : UIViewController <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate> {

    NetworkManager *networkManager;

}

@property (strong, nonatomic) UIImage *parentScreenImage;

@property (strong, nonatomic) NSDictionary *postDetail;
@property (weak, nonatomic) IBOutlet UITextView *postBody;
@property (weak, nonatomic) IBOutlet UILabel *numComments;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UILabel *numVotes;
@property (weak, nonatomic) IBOutlet UITableView *commentsTable;
@property (weak, nonatomic) IBOutlet UITextField *inlineCommentField;
@property (weak, nonatomic) IBOutlet UIButton *upvoteBtn;
@property (weak, nonatomic) IBOutlet UIButton *downvoteBtn;
@property (strong, nonatomic) NSString *postId;
@property (strong, nonatomic) NSDictionary *postAdditionalDetail;
@property (strong, nonatomic) NSMutableArray *comments;
@property BOOL didIUpvote;
@property BOOL didIDownvote;
@property NSNumber *cellRowIdx;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputContainerBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *commenInputContainer;

@property (weak, nonatomic) IBOutlet UIView *postDivider;
@property (weak, nonatomic) IBOutlet UIView *commentFieldDivider;


@end
