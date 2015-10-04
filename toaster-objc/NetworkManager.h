//
//  NetworkManager.h
//  Toaster
//
//  Created by Howon Song on 9/28/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkManager : AFHTTPSessionManager

//@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

+ (NetworkManager *)sharedNetworkManager;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateSerializerWithNewToken: (NSString *)token;

@end
