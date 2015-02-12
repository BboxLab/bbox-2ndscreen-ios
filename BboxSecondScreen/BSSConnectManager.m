//
//  BSSConnectManager.m
//  BboxSecondScreen
//
//  Created by Nicolas Jaouen on 29/01/2015.
//  Copyright (c) 2015 Bouygues Telecom. All rights reserved.
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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL_Token parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {        NSDictionary *headerData = [[operation response] allHeaderFields];
        if ([headerData objectForKey:Token_Header_Key] != nil){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[headerData objectForKey:Token_Header_Key] forKey:Token_userDefaults_Key];
            [userDefaults synchronize];
        }
        callback(1, 0);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        callback(0, error);
    }];
}




- (void) getSession:(void (^)(BOOL success, NSError * error))callback {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * body = [[NSMutableDictionary alloc] init];
    
    [body setObject:[userDefaults objectForKey:Token_userDefaults_Key]  forKey:Token_Key];

    [_client post:URL_Session withBody:body thenCallWithHeaders:^(BOOL success, NSInteger statusCode, NSDictionary *headers, id response, NSError *error) {
        if (success) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[headers objectForKey:SessionId_Header_Key] forKey:Session_userDefaults_Key];
            NSLog(@"Session_userDefaults_Key : %@",[userDefaults objectForKey:Session_userDefaults_Key]);
            
            [userDefaults synchronize];
        }
        callback(success, error);
    }];
    
}


@end

