//
//  Application.h
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 06/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Application : NSObject

typedef NS_ENUM(NSInteger, ApplicationStateType) {
    FOREGROUND,
    BACKGROUND,
    STOPPED,
    UNKNOW_STATE
};

@property NSString* appName;
@property NSString* logoUrl;
@property NSString* appId;
@property ApplicationStateType state;

- (id) initAppName:(NSString*)appName withAppId:(NSString*)appId logoUrl:(NSString*)logoUrl andState:(ApplicationStateType)state;



@end
