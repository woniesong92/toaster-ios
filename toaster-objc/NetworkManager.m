//
//  NetworkManager.m
//  Toaster
//
//  Created by Howon Song on 9/28/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "NetworkManager.h"
#import "SessionManager.h"
#import "Constants.h"

@implementation NetworkManager


+ (NetworkManager *)sharedNetworkManager {
    static NetworkManager *_sharedNetworkManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedNetworkManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return _sharedNetworkManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"token"];
//        NSString *token = defaults[@"token"];
        NSString *authorizationToken = [NSString stringWithFormat:@"Bearer %@", token];
        [self.requestSerializer setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    }
    
    NSLog(@"init with base url");
    
    return self;
}

- (void)updateSerializerWithNewToken: (NSString *)token {
    NSString *authorizationToken = [NSString stringWithFormat:@"Bearer %@", token];
    [self.requestSerializer setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
    self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
}

@end
