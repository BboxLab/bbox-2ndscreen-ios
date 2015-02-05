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
#import "BSSConnectManager.h"
/**
 Object representation of a Bbox.
 */
@interface Bbox : NSObject

/**
 RemoteManager for the current Bbox
 */
@property RemoteManager * remoteManager;
/**
 RemoteManager for the current Bbox
 */
@property ConnectManager * connectManager;

/**
 ApplicationsManager for the current Bbox
 */
@property ApplicationsManager * applicationsManager;

/**
 BboxRestClient for the current Bbox
 */
@property BboxRestClient * bboxRestClient;

/**
 NotificationsManager for the current Bbox
 @warning You have to instanciate it when you need it.
 */
@property NotificationsManager * notificationsManager;

/**
 ip of the current Bbox
 */
@property NSString * ip;

/**
 Init a Bbox object with the provided ip. It will instanciate a BboxRestClient, RemoteManager, and ApplicationsManager
 */
- (id) initWithIp:(NSString *)ip;

@end
