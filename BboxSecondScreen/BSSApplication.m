//
//  Application.m
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 06/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import "BSSApplication.h"

@implementation Application

@synthesize appId;
@synthesize appName;
@synthesize packageName;
@synthesize logoUrl;
@synthesize state;

- (id) initAppName:(NSString *)initialAppName withAppId:(NSString *)initialAppId withPackageName:(NSString *)initialPackageName logoUrl:(NSString *)initialLogoUrl andState:(ApplicationStateType)initialState {
    self.appName = initialAppName;
    self.appId = initialAppId;
    self.logoUrl = initialLogoUrl;
    self.state = initialState;
    self.packageName = initialPackageName;
    return self;
}

@end
