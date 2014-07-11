//
//  RemoteManager.m
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 07/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import "BSSRemoteManager.h"

@implementation RemoteManager

- (id) initWithBboxRestClient:(BboxRestClient *)client {
    self.client = client;
    return self;
}

- (void) sendThisKey:(NSString *)key ofThatType:(NSString *)type andThenCall:(void (^)(BOOL, NSError *))callback {
    
    NSDictionary * body = @{@"key" : @{@"keyName": key, @"keyType": type}};
    
    [self.client put:@"UserInterface/RemoteController/Key" withBody:body thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        callback(success, error);
    }];
}

- (void) sendThisText:(NSString *)text thenCall:(void (^)(BOOL, NSError *))callback {
    NSDictionary * body = @{@"text": text};
    
    [self.client post:@"/UserInterface/RemoteController/Text" withBody:body thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        callback(success, error);
    }];
}

- (void) getVolumeAndCall:(void (^)(BOOL, NSString *, NSError *))callback {
    
    [self.client get:@"/UserInterface/Volume" withParams:nil thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        if (success) {
            NSDictionary * result = response;
            callback(success, [result objectForKey:@"volume"], nil);
        } else {
            callback(success, nil, error);
        }
        
    }];
}

- (void) setVolumeTo:(NSString *)volume andCall:(void (^)(BOOL, NSError *))callback {
    
    NSDictionary * body = @{@"volume": volume};
    
    [self.client post:@"/UserInterface/Volume" withBody:body thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        callback(success, error);
    }];
    
}

@end
