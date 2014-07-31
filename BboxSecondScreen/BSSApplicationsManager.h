//
//  ApplicationsManager.h
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 06/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSSBboxRestClient.h"
#import "BSSApplication.h"

/**
 The ApplicationsManager allow to easily manage all the applications on the Bbox.
 */
@interface ApplicationsManager : NSObject

/**
 Init the BboxRestClient with the bbox ip.
 @param ip The ip of the Bbox we want to communicate with
 */
@property BboxRestClient* client;

/**
 Init the ApplicationsManager with a BboxRestClient
 @return an instance of ApplicationsManager
 */
- (id) initWith:(BboxRestClient*)bboxRestClient;

/**
 Get all the applications installed on the Bbox.
 @param callback You will get the reponse in it.
 */
- (void) getApplicationsThenCall:(void (^)(BOOL success, NSMutableArray *applications, NSError *error))callback;

/**
 Get a specific application with a packageName.
 @param name packageName of the application you want
 @param callback You will get the reponse in it.
 */
- (void) getApplicationWithThatPackageName:(NSString*)name ThenCall:(void (^)(BOOL success, Application *application, NSError *error))callback;

/**
 Start the provided application on the Bbox
 @param application The application you want to start
 */
- (void) startApplication:(Application*)application;

/**
 Start the application with the provided packageName
 @param name The application package name you want to start
 */
- (void) startApplicationWithThatPackageName:(NSString *)name;

/**
 Start the provided application on the Bbox. Add a callback to know if there is an error.
 @param application The application you want to start
 @callback callback Call after the request is done and indicate if the operation is a success
 */
- (void) startApplication:(Application *)application thenCall:(void (^)(BOOL success, NSError *error))callback;

/**
 Start the application with the provided packageName. Add a callback to know if there is an error.
 @param name The application package name you want to start
 @callback callback Call after the request is done and indicate if the operation is a success
 */
- (void) startApplicationWithThatPackageName:(NSString *)name thenCall:(void (^)(BOOL success, NSError *error))callback;

/**
 Stop the provided application
 @param application The application you want to stop.
 */
- (void) stopApplication:(Application*)application;

/**
 Stop the application with the provided appId
 @param appId The appId of the application you want to stop
 */
- (void) stopApplicationWithThatAppId:(NSString *)appId;

/**
 Stop the provided application. Add a callback to know if there is an error.
 @param application The application you want to stop.
 @callback callback Call after the request is done and indicate if the operation is a success
 */
- (void) stopApplication:(Application *)application thenCall:(void (^)(BOOL success, NSError *error))callback;

/**
 Stop the application with the provided appId. Add a callback to know if there is an error.
 @param appId The appId of the application you want to stop
 @callback callback Call after the request is done and indicate if the operation is a success
 */
- (void) stopApplicationWithThatAppId:(NSString *)appId thenCall:(void (^)(BOOL success, NSError *error))callback;

/**
 Use that method to get your appId.
 @param appName You secondscreen appName. It can be randomly generated.
 @param callback Call after the resquest is done with you appId for parameters.
 @warning This method is made to get id of secondscreen application. To get id of a Bbox application you should use ‘getApplicationWithThatPackageName‘.
 */
- (void) getMyAppIdWithMyAppName:(NSString *)appName andThenCall:(void (^)(BOOL success, NSString * appId, NSError *error))callback;

@end
