//
//  RemoteManager.m
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 07/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import "BSSRemoteManager.h"

@implementation RemoteManager

static NSString * const USER_INTERFACE = @"userinterface";
static NSString * const REMOTE_CONTROLLER = @"remotecontroller";
static NSString * const KEY = @"key";
static NSString * const TEXT = @"text";
static NSString * const VOLUME = @"volume";

- (id) initWithBboxRestClient:(BboxRestClient *)client {
    self.client = client;
    return self;
}

- (void) sendThisKey:(NSString *)key ofThatType:(NSString *)type andThenCall:(void (^)(BOOL, NSError *))callback {
    NSDictionary * body = @{@"key" : @{@"keyName": key, @"keyType": type}};
    NSString * resource = [NSString stringWithFormat:@"%@/%@/%@", USER_INTERFACE, REMOTE_CONTROLLER, KEY];
    [self.client put:resource withBody:body thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        callback(success, error);
    }];
}

- (void) sendThisText:(NSString *)text thenCall:(void (^)(BOOL, NSError *))callback {
    NSDictionary * body = @{@"text": text};
    NSString * resource = [NSString stringWithFormat:@"%@/%@/%@", USER_INTERFACE, REMOTE_CONTROLLER, TEXT];
    [self.client post:resource withBody:body thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        callback(success, error);
    }];
}

- (void) getVolumeAndCall:(void (^)(BOOL, NSString *, NSError *))callback {
    NSString * resource = [NSString stringWithFormat:@"%@/%@", USER_INTERFACE, VOLUME];
    [self.client get:resource withParams:nil thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
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
    NSString * resource = [NSString stringWithFormat:@"%@/%@", USER_INTERFACE, VOLUME];
    [self.client post:resource withBody:body thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        callback(success, error);
    }];
}

@end
