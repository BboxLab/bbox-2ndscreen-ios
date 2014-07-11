//
//  BboxRestClient.h
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 29/04/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface BboxRestClient : NSObject

@property NSString * ip;

- (id)initWithIp:(NSString *)ip;

- (void) get:(NSString*)url withParams:(NSDictionary*)params thenCall:(void (^)(BOOL success, NSInteger statusCode, id response, NSError *error))callback;

- (void) post:(NSString*)url withBody:(NSDictionary*)body thenCall:(void (^)(BOOL success, NSInteger statusCode, id response, NSError *error))callback;

- (void) put:(NSString*)url withBody:(NSDictionary*)body thenCall:(void (^)(BOOL success, NSInteger statusCode, id response, NSError *error))callback;

- (void) post:(NSString*)url withBody:(NSDictionary*)body thenCallWithHeaders:(void (^)(BOOL success, NSInteger statusCode, NSDictionary* headers, id response, NSError *error))callback;

- (void) del:(NSString*)url withParams:(NSDictionary*)params thenCall:(void (^)(BOOL success, NSInteger statusCode, id response, NSError *error))callback;

@end
