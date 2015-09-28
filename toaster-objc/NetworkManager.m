//
//  NetworkManager.m
//  Toaster
//
//  Created by Howon Song on 9/28/15.
//  Copyright (c) 2015 honeyjamstudio. All rights reserved.
//

#import "NetworkManager.h"
#import "SessionManager.h"

@implementation NetworkManager

+ (NetworkManager *)getNetworkManager {
    static NetworkManager *networkManager = nil;
    
//    static WebViewManager *uniqueWebView = nil;

    @synchronized(self) {
        if (networkManager == nil) {
            networkManager = [[self alloc] init];
            networkManager.manager = [AFHTTPRequestOperationManager manager];
            
            if (![[SessionManager currentUser] isEqualToString:@""]) {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *token = [defaults objectForKey:@"token"];
                [networkManager updateSerializerWithNewToken:token];
            }
            
        }
    }
    
    return networkManager;
}

- (void)updateSerializerWithNewToken: (NSString *)token {
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *authorizationToken = [NSString stringWithFormat:@"Bearer %@", token];
    [self.manager.requestSerializer setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
}


@end
