//
//  RemoteManager.h
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 07/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSSBboxRestClient.h"

@interface RemoteManager : NSObject

@property BboxRestClient * client;

- (id) initWithBboxRestClient:(BboxRestClient*) client;

- (void) sendThisKey:(NSString*)key ofThatType:(NSString*)type andThenCall:(void (^)(BOOL success, NSError *error))callback;

- (void) sendThisText:(NSString*)text thenCall:(void (^)(BOOL success, NSError *error))callback;

- (void) getVolumeAndCall:(void (^)(BOOL success, NSString* volume, NSError *error))callback;

- (void) setVolumeTo:(NSString*)volume andCall:(void (^)(BOOL success, NSError *error))callback;

@end
