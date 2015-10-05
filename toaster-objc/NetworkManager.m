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
        _sharedNetworkManager = [[self alloc] init];
    });
    
    return _sharedNetworkManager;
}

- (NSString *)getErrorReason: (NSError *)error {
    NSData *errData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSString *errReason = @"";
    
    if (errData) {
        NSMutableDictionary *errObj = [NSJSONSerialization JSONObjectWithData:errData options:0 error:nil];
        errReason = errObj[@"reason"];
    }
    
    return errReason;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"token"];
        NSString *authorizationToken = [NSString stringWithFormat:@"Bearer %@", token];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    }
    
    return self;
}

- (void)updateSerializerWithNewToken: (NSString *)token {
    NSString *authorizationToken = [NSString stringWithFormat:@"Bearer %@", token];
    [self.requestSerializer setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
    
}

@end
