//
//  BSSConnectManager.h
//  Pods
//
//  Created by Nicolas Jaouen on 04/02/2015.
//
//

#import "BSSBboxRestClient.h"
@interface ConnectManager : NSObject

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

- (void) getToken:(void (^)(BOOL success, NSError * error))callback;
- (void) getSession:(void (^)(BOOL success, NSError * error))callback;


@end

