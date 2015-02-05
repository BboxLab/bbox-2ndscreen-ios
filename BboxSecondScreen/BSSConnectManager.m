//
//  BSSConnectManager.m
//  Pods
//
//  Created by Nicolas Jaouen on 04/02/2015.
//
//

#import "BSSConnectManager.h"
#import "BBSConstants.h"

@implementation ConnectManager


- (id) initWithBboxRestClient:(BboxRestClient *)client {
    self.client = client;
    return self;
}

- (void) getToken:(void (^)(BOOL success, NSError * error))callback {
    
    NSMutableDictionary * body = [[NSMutableDictionary alloc] init];
    
    [body setObject:App_ID forKey:AppId_Key];
    [body setObject:App_Secret forKey:AppSecret_Key];
    
    [_client post:URL_Token withBody:body thenCallWithHeaders:^(BOOL success, NSInteger statusCode, NSDictionary *headers, id response, NSError *error) {
        if (success) {
            NSLog(@"%@",response);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:response forKey:Token_userDefaults_Key];
            [userDefaults synchronize];
            
        }
        callback(success, error);
    }];
    
}

- (void) getSession:(void (^)(BOOL success, NSError * error))callback {
    
    NSMutableDictionary * body = [[NSMutableDictionary alloc] init];
    
    [body setObject:App_ID forKey:Token_Key];
    
    [_client post:URL_Session withBody:body thenCallWithHeaders:^(BOOL success, NSInteger statusCode, NSDictionary *headers, id response, NSError *error) {
        if (success) {
            NSLog(@"%@",response);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:response forKey:Session_userDefaults_Key];
            [userDefaults synchronize];
        }
        callback(success, error);
    }];
    
}


@end

