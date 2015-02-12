//
//  ApplicationsManager.m
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 06/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import "BSSApplicationsManager.h"
#import "BSSApplication.h"
#import "BBSConstants.h"

@implementation ApplicationsManager

@synthesize client;

- (id) initWith:(BboxRestClient *)bboxRestClient {
    self.client = bboxRestClient;
    return self;
}

- (void) getApplicationsThenCall:(void (^)(BOOL, NSMutableArray *, NSError *))callback {
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * header = [[NSMutableDictionary alloc] init];
    [header setObject:[userDefaults objectForKey:Session_userDefaults_Key]  forKey:SessionId_Header_Key];
    
        
    [client get:Applications_Key withParams:nil withHeader:header thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        if (success) {
            NSArray* res = response;
            NSMutableArray* apps = [[NSMutableArray alloc] init];
            for(NSDictionary* app in res) {
                NSString *appName = [app objectForKey:AppName_Key];
                NSString *logoUrl = [app objectForKey:LogoUrl_Key];
                NSString *packageName = [app objectForKey:PackageName_Key];
                NSString *appId = [app objectForKey:AppId_Key];
                
                ApplicationStateType state;
                if ([[app objectForKey:AppState_Key] isEqual: Foreground_Key]) {
                    state = FOREGROUND;
                } else if ([[app objectForKey:AppState_Key] isEqual: Background_Key]) {
                    state = BACKGROUND;
                } else {
                    state = STOPPED;
                }
                Application * newApp = [[Application alloc] initAppName:appName withAppId:appId withPackageName:packageName logoUrl:logoUrl andState:state];
                [apps addObject:newApp];
            }
            callback(true, apps, nil);
        } else {
            callback(false, nil, error);
        }
    }];
};

- (void) getApplicationWithThatPackageName:(NSString *)name ThenCall:(void (^)(BOOL, Application *, NSError *))callback {
    assert(name != nil && @"name must not be nil");
    [self getApplicationsThenCall:^(BOOL success, NSMutableArray *applications, NSError *error) {
        if (success) {
            Application * appFound = nil;
            for (Application *app in applications) {
                if ([app.packageName isEqualToString:name]) {
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

- (void) startApplicationWithThatPackageName:(NSString *)name thenCall:(void (^)(BOOL, NSError *))callback {
    assert(name != nil && @"packageName must not be nil");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * header = [[NSMutableDictionary alloc] init];
    [header setObject:[userDefaults objectForKey:Session_userDefaults_Key]  forKey:SessionId_Header_Key];
    

    [client post:[NSString stringWithFormat:@"applications/%@", name] withBody:nil withHeader:header  thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        if (callback != nil) {
            callback(success, error);
        }
    }];
}

- (void) startApplicationWithThatPackageName:(NSString *)name {
    [self startApplicationWithThatPackageName:name thenCall:nil];
}

- (void) startApplication:(Application *)application thenCall:(void (^)(BOOL, NSError *))callback {
    assert(application != nil && @"application must not be nil");
    [self startApplicationWithThatPackageName:application.packageName thenCall:callback];
}

- (void) startApplication:(Application *)application {
    [self startApplication:application thenCall:nil];
}

- (void) stopApplicationWithThatAppId:(NSString *)appId thenCall:(void (^)(BOOL, NSError *))callback {
    assert(appId != nil && @"appId must not be nil");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * header = [[NSMutableDictionary alloc] init];
    [header setObject:[userDefaults objectForKey:Session_userDefaults_Key]  forKey:SessionId_Header_Key];
    

    [client del:[NSString stringWithFormat:@"applications/run/%@", appId] withParams:nil withHeader:header  thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
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
    [self getApplicationWithThatPackageName:application.packageName ThenCall:^(BOOL success, Application *applicationRet, NSError *error) {
        if (success) {
            if (applicationRet.state != STOPPED) {
                [self stopApplicationWithThatAppId:applicationRet.appId thenCall:callback];
            }
        } else if (callback != nil) {
            callback(false, nil);
        }
    }];
}

- (void)getMyAppIdWithMyAppName:(NSString *)appName andThenCall:(void (^)(BOOL, NSString *, NSError *))callback {
     NSMutableDictionary * body = [[NSMutableDictionary alloc]
                                 initWithObjectsAndKeys:appName,AppName_Key,
                                 nil];
    
  
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * header = [[NSMutableDictionary alloc] init];
    [header setObject:[userDefaults objectForKey:Session_userDefaults_Key]  forKey:SessionId_Header_Key];
    

    
    
    [client post:@"applications/register" withBody:body withHeader:header  thenCallWithHeaders:^(BOOL success, NSInteger statusCode, NSDictionary *headers, id response, NSError *error) {
        if (success) {
            NSArray * urlArray = [[headers objectForKey:Location_Key] componentsSeparatedByString:@"/"];
            callback(success, [urlArray objectAtIndex:[urlArray count]-1], error);
        } else {
            callback(success, nil, error);
        }
    }];
    
}

@end
