//
//  ApplicationsManager.m
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 06/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import "BSSApplicationsManager.h"
#import "BSSApplication.h"

@implementation ApplicationsManager

@synthesize client;

- (id) initWith:(BboxRestClient *)bboxRestClient {
    self.client = bboxRestClient;
    return self;
}

- (void) getApplicationsThenCall:(void (^)(BOOL, NSMutableArray *, NSError *))callback {
    
    [client get:@"applications" withParams:nil thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        if (success) {
            NSArray* res = response;
            NSMutableArray* apps = [[NSMutableArray alloc] init];
            for(NSDictionary* app in res) {
                NSString *appName = [app objectForKey:@"appName"];
                NSString *logoUrl = [app objectForKey:@"icon"];
                NSArray *appInstance = [app objectForKey:@"appInstances"];
                ApplicationStateType state;
                NSString *appId = nil;
                if ([appInstance count] == 0) {
                    state = STOPPED;
                } else {
                    NSDictionary* instance = [appInstance objectAtIndex:0];
                    appId = [instance objectForKey:@"appId"];
                    instance = [instance objectForKey:@"appState"];
                    if ([[instance objectForKey:@"visible"]  isEqual: @YES]) {
                        state = FOREGROUND;
                    } else {
                        state = BACKGROUND;
                    }
                }
                Application * newApp = [[Application alloc] initAppName:appName withAppId:appId logoUrl:logoUrl andState:state];
                [apps addObject:newApp];
            }
            callback(true, apps, nil);
        } else {
            callback(false, nil, error);
        }
    }];
};

- (void) getApplicationWithThatAppName:(NSString *)name ThenCall:(void (^)(BOOL, Application *, NSError *))callback {
    assert(name != nil && @"name must not be nil");
    [self getApplicationsThenCall:^(BOOL success, NSMutableArray *applications, NSError *error) {
        if (success) {
            Application * appFound = nil;
            for (Application *app in applications) {
                if ([app.appName isEqualToString:name]) {
                    appFound = app;
                    break;
                }
            }
            if (appFound != nil) {
                callback(true, appFound, nil);
            } else {
                //TODO créer NSError pour appName qui n'existe pas.
                callback(false, nil, nil);
            }
        } else {
            callback(false, nil, error);
        }
    }];
}

- (void) startApplicationWithThatAppName:(NSString *)name thenCall:(void (^)(BOOL, NSError *))callback {
    assert(name != nil && @"appName must not be nil");
    [client post:[NSString stringWithFormat:@"Applications/%@", name] withBody:nil thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        if (callback != nil) {
            callback(success, error);
        }
    }];
}

- (void) startApplicationWithThatAppName:(NSString *)name {
    [self startApplicationWithThatAppName:name thenCall:nil];
}

- (void) startApplication:(Application *)application thenCall:(void (^)(BOOL, NSError *))callback {
    assert(application != nil && @"application must not be nil");
    [self startApplicationWithThatAppName:application.appName thenCall:callback];
}

- (void) startApplication:(Application *)application {
    [self startApplication:application thenCall:nil];
}

- (void) stopApplicationWithThatAppId:(NSString *)appId thenCall:(void (^)(BOOL, NSError *))callback {
    assert(appId != nil && @"appId must not be nil");
    [client del:[NSString stringWithFormat:@"Applications/Run/%@", appId] withParams:nil thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        if (callback != nil) {
            callback(success, error);
        }
    }];
}

- (void) stopApplicationWithThatAppId:(NSString *)appId {
    [self stopApplicationWithThatAppId:appId thenCall:nil];
}

- (void) stopApplication:(Application *)application thenCall:(void (^)(BOOL, NSError *))callback {
    assert(application != nil && @"application must not be nil");
    [self getApplicationWithThatAppName:application.appName ThenCall:^(BOOL success, Application *applicationRet, NSError *error) {
        if (success) {
            if (applicationRet.state != STOPPED) {
                [self stopApplicationWithThatAppId:applicationRet.appId thenCall:callback];
            }
        } else if (callback != nil) {
            callback(false, nil);
        }
    }];
}

- (void) stopApplication:(Application *)application {
    [self stopApplication:application thenCall:nil];
}

- (void)getMyAppIdWithMyAppName:(NSString *)appName andThenCall:(void (^)(BOOL, NSString *, NSError *))callback {
    
    NSDictionary * body = @{@"appName": appName};
    
    [client post:@"applications/register" withBody:body thenCallWithHeaders:^(BOOL success, NSInteger statusCode, NSDictionary *headers, id response, NSError *error) {
        if (success) {
            NSArray * urlArray = [[headers objectForKey:@"Location"] componentsSeparatedByString:@"/"];
            callback(success, [urlArray objectAtIndex:[urlArray count]-1], error);
        } else {
            callback(success, nil, error);
        }
    }];
}

@end
