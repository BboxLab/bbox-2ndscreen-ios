//
//  BboxRestClient.h
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 29/04/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

/**
 BbowRestClient is just an abstraction of the AFNetworking library. The base url is set to directly communicate with the Bbox API.
 */
@interface BboxRestClient : NSObject

/**
 Ip of the Bbox we want to communicate with.
 */
@property NSString * ip;

/**
 Init the BboxRestClient with the bbox ip.
 @param ip The ip of the Bbox we want to communicate with
 @return an instance of BboxRestClient
 */
- (id)initWithIp:(NSString *)ip;

/**
 HTTP Get method.
 @param url The resource you want to get ex: 'applications'
 @param params url parameters
 @param callback you will get the response in it.
 */
- (void) get:(NSString*)url withParams:(NSDictionary*)params thenCall:(void (^)(BOOL success, NSInteger statusCode, id response, NSError *error))callback;

/**
 HTTP Post method.
 @param url The resource you want to post to ex: 'applications/register'
 @param body body of the request
 @param callback you will get the response in it.
 */
- (void) post:(NSString*)url withBody:(NSDictionary*)body thenCall:(void (^)(BOOL success, NSInteger statusCode, id response, NSError *error))callback;

/**
 HTTP Post method. The callback provides a NSDictionary of the reponses's headers.
 @param url The resource you want to post to ex: 'applications/register'
 @param body body of the request
 @param callback you will get the response in it.
 */
- (void) post:(NSString*)url withBody:(NSDictionary*)body thenCallWithHeaders:(void (^)(BOOL success, NSInteger statusCode, NSDictionary* headers, id response, NSError *error))callback;

/**
 HTTP Put method.
 @param url The resource you want to put to ex: '/notification/a_channel_id'
 @param body body of the request
 @param callback you will get the response in it.
 */
- (void) put:(NSString*)url withBody:(NSDictionary*)body thenCall:(void (^)(BOOL success, NSInteger statusCode, id response, NSError *error))callback;

/**
 HTTP Delete method.
 @param url The resource you want to delete ex: '/applications/run/an_app_id'
 @param params url parameters
 @param callback you will get the response in it.
 */
- (void) del:(NSString*)url withParams:(NSDictionary*)params thenCall:(void (^)(BOOL success, NSInteger statusCode, id response, NSError *error))callback;

@end
