//
//  LoadingManager.h
//  toaster-objc
//
//  Created by Howon Song on 9/5/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface LoadingManager : NSObject


+ (id)getLoadingManager: (UIViewController *) container;

@property (nonatomic) UIActivityIndicatorView *loadingView;
- (void)startLoadingIndicator: (UIViewController *) container;
- (void)stopLoadingIndicator;

@end
