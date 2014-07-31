//
//  RemoteManager.h
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 07/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSSBboxRestClient.h"

/**
 The RemoteManager object allow you to emulate a remote.
 @warning Only the volume methods are working with current version of BboxAPI.
 */
@interface RemoteManager : NSObject

/**
 The BboxRestClient is making all the REST call to the API.
 */
@property BboxRestClient * client;

/**
 Init a RemoteManager with the BboxRestClient provided.
 
 @param client The BboxRestClient of the corresponding Bbox.
 
 @return the newly created RemoteManager
 */
- (id) initWithBboxRestClient:(BboxRestClient*) client;

/**
 Send a key to the bbox.
 @warning In current version of the Bbox API, the userinterface/remotecontroller part is NOT implemented. These method are not working for the moment.
 */
- (void) sendThisKey:(NSString*)key ofThatType:(NSString*)type andThenCall:(void (^)(BOOL success, NSError *error))callback;

/**
 Send text to the bbox (to fill a textfield for example.
 @warning In current version of the Bbox API, the userinterface/remotecontroller part is NOT implemented. These method are not working for the moment.
 */
- (void) sendThisText:(NSString*)text thenCall:(void (^)(BOOL success, NSError *error))callback;

/**
 Get the current volume state
 
 @param callback The callback called to get the response.
 */
- (void) getVolumeAndCall:(void (^)(BOOL success, NSString* volume, NSError *error))callback;

/**
 Set the current volume state
 
 @param volume 0 <= volume <= 100
 @param callback The callback called to get the response.
 */
- (void) setVolumeTo:(NSString*)volume andCall:(void (^)(BOOL success, NSError *error))callback;

@end
