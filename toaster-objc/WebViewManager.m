//
//  WebViewManager.m
//  toaster-objc
//
//  Created by Howon Song on 9/4/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "WebViewManager.h"
#import "Constants.h"
#import "UIWebView+FLUIWebView.h"
#import "WKWebView+FLWKWebView.h"

@implementation WebViewManager {
    NSString *currentTab;
}

+ (BOOL)isWKWebViewAvailable {
    if (NSClassFromString(@"WKWebView")) {
        return true;
    } else {
        return false;
    }
}

+ (id)getUniqueWebViewManager: (UIViewController *)container {
    static WebViewManager *uniqueWebView = nil;
    @synchronized(self) {
        if (uniqueWebView == nil) {
            uniqueWebView = [[self alloc] init];
            
            if ([self isWKWebViewAvailable]) {
                uniqueWebView.webView = [[WKWebView alloc] initWithFrame:container.view.frame];
            } else {
                uniqueWebView.webView = [[UIWebView alloc] initWithFrame:container.view.frame];
            }
            
            // Resize WebView appropriately
            CGRect resizedFrame = uniqueWebView.webView.frame;
            CGFloat tabBarHeight = [[container tabBarController] tabBar].frame.size.height;
            CGFloat navBarHeight = [[container navigationController] navigationBar].frame.size.height;
            CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            resizedFrame.origin.y = navBarHeight + statusBarHeight;
            resizedFrame.size.height = container.view.frame.size.height - (tabBarHeight + navBarHeight + statusBarHeight);
            uniqueWebView.webView.frame = resizedFrame;
            
            // Load website. This is the only time that
            // loadURL should be used because ours is a single page app
            // For tab navigtaion, do it with useRouterWithPath so we can avoid
            // full page refresh
            [uniqueWebView loadUrlWithString:BASE_URL];
            [uniqueWebView setCurrentTab:RECENT];
        }
    }
    return uniqueWebView;
}


- (void)loadUrlWithString: (NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)useRouterWithPath: (NSString *)pathString {
    NSString *js = [NSString stringWithFormat:@"%@%@%@", @"Router.go(\"", pathString, @"\")"];
    [self setCurrentTab:pathString];
    [[self webView] evaluateJavaScript:js completionHandler:nil];
}

- (void)removeWebViewFromContainer {
//    self.webView.delegate = nil;
    [self.webView removeFromSuperview];
}

- (void)setCurrentTab:(NSString *)tabName {
    currentTab = tabName;
}

- (NSString *)getCurrentTab {
    return currentTab;
}

- (UIImage *)screencapture:(UIViewController *)viewController {
    UIGraphicsBeginImageContextWithOptions(viewController.view.bounds.size, NO, [UIScreen mainScreen].scale);
    [viewController.view drawViewHierarchyInRect:viewController.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)getWhiteImage {
    return [self imageWithColor:[UIColor whiteColor]];
}

- (void)replaceWebViewWithImage:(UIViewController *)containerVC :(UIImage *)image {
//    UIImage *image = [self _screencapture:containerVC];
    
    if (image == nil) {
        NSLog(@"can't replace webview with image: image is null");
        return;
    }
    
    UIView *imageContainer = [[UIView alloc] initWithFrame:[containerVC view].frame];
    [imageContainer setTag:IMAGE_CONTAINER_TAG];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = imageContainer.bounds;
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imageView setTintColor:[UIColor redColor]];
    
    [imageContainer addSubview:imageView];
    [[containerVC view] addSubview:imageContainer];
}

- (void)replaceImageWithWebView:(UIViewController *)containerVC {
    UIView *imageContainer = [[containerVC view] viewWithTag:IMAGE_CONTAINER_TAG];
    if (imageContainer != nil) {
        [imageContainer removeFromSuperview];
    }
}

@end
