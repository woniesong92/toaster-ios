//
//  LoadingManager.m
//  toaster-objc
//
//  Created by Howon Song on 9/5/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "LoadingManager.h"

@implementation LoadingManager

//+(UIActivityIndicatorView *) getLoadingView: (UIViewController *)container {
//    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithFrame:container.view.frame];
//    return loadingView;
//}

+ (id)getLoadingManager: (UIViewController *) container {
    static LoadingManager *loadingManager = nil;
    @synchronized(self) {
        if (loadingManager == nil) {
            loadingManager = [[self alloc] init];
            
            loadingManager.loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            loadingManager.loadingView.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
            loadingManager.loadingView.center = container.view.center;
            loadingManager.loadingView.hidden = NO;
        }
    }
    return loadingManager;
};

- (void)startLoadingIndicator: (UIViewController *) container {
//    return;
    
    // if it was attached to some other view and never ended
    if (self.loadingView.superview) {
        [self.loadingView removeFromSuperview];
    }
    
    [container.view addSubview: self.loadingView];
    [self.loadingView startAnimating];
}

- (void)stopLoadingIndicator {
//    return;
    
    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
}





@end
