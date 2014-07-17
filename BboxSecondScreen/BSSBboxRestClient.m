//
//  BboxRestClient.m
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 29/04/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import "BSSBboxRestClient.h"

@implementation BboxRestClient

@synthesize ip;

static NSString * const API_URL = @":8080/api.bbox.lan/v0/";
static NSString * baseUrl;
static AFHTTPRequestOperationManager * manager = nil;

- (id)initWithIp:(NSString *)initialIp {
    self.ip = initialIp;
    baseUrl = [NSString stringWithFormat:@"%@%@%@", @"http://", ip, API_URL];
    [self initManager];
    return self;
}

- (void) initManager {
    NSURL *baseNSURL = [NSURL URLWithString:baseUrl];
    manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:baseNSURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
}

- (void) get:(NSString *)url withParams:(NSDictionary *)params thenCall:(void (^)(BOOL, NSInteger, id, NSError *))callback {
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(true, [operation.response statusCode], responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(false, [operation.response statusCode], nil, error);
    }];
}

- (void) post:(NSString *)url withBody:(NSDictionary *)body thenCall:(void (^)(BOOL, NSInteger, id, NSError *))callback {
    [manager POST:url parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(true, [operation.response statusCode], responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(false, [operation.response statusCode], nil, error);
    }];
}

- (void) put:(NSString *)url withBody:(NSDictionary *)body thenCall:(void (^)(BOOL, NSInteger, id, NSError *))callback {
    [manager PUT:url parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(true, [operation.response statusCode], responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(false, [operation.response statusCode], nil, error);
    }];
}

- (void) del:(NSString *)url withParams:(NSDictionary *)params thenCall:(void (^)(BOOL, NSInteger, id, NSError *))callback {
    [manager DELETE:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(true, [operation.response statusCode], responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(false, [operation.response statusCode], nil, error);
    }];
}

- (void)post:(NSString *)url withBody:(NSDictionary *)body thenCallWithHeaders:(void (^)(BOOL, NSInteger, NSDictionary *, id, NSError *))callback {
    [manager POST:url parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(true, [operation.response statusCode], [[operation response] allHeaderFields],responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(false, [operation.response statusCode], [[operation response] allHeaderFields], nil, error);
    }];
}

@end
