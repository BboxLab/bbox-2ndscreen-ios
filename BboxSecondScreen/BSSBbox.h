//
//  Bbox.h
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 20/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BSSRemoteManager.h"
#import "BSSApplicationsManager.h"
#import "BSSBboxRestClient.h"
#import "BSSNotificationsManager.h"

@interface Bbox : NSObject

@property RemoteManager * remoteManager;
@property ApplicationsManager * applicationsManager;
@property BboxRestClient * bboxRestClient;
@property NotificationsManager * notificationsManager;
@property NSString * ip;

- (id) initWithIp:(NSString *)ip;

@end
