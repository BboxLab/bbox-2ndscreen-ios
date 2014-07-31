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

@interface ApplicationsManager : NSObject

@property BboxRestClient* client;

- (id) initWith:(BboxRestClient*)bboxRestClient;

- (void) getApplicationsThenCall:(void (^)(BOOL success, NSMutableArray *applications, NSError *error))callback;

- (void) getApplicationWithThatPackageName:(NSString*)name ThenCall:(void (^)(BOOL success, Application *application, NSError *error))callback;

- (void) startApplication:(Application*)application;

- (void) startApplicationWithThatPackageName:(NSString *)name;

- (void) startApplication:(Application *)application thenCall:(void (^)(BOOL success, NSError *error))callback;

- (void) startApplicationWithThatPackageName:(NSString *)name thenCall:(void (^)(BOOL success, NSError *error))callback;

- (void) stopApplication:(Application*)application;

- (void) stopApplicationWithThatAppId:(NSString *)appId;

- (void) stopApplication:(Application *)application thenCall:(void (^)(BOOL success, NSError *error))callback;

- (void) stopApplicationWithThatAppId:(NSString *)appId thenCall:(void (^)(BOOL success, NSError *error))callback;

- (void) getMyAppIdWithMyAppName:(NSString *)appName andThenCall:(void (^)(BOOL success, NSString * appId, NSError *error))callback;

@end
