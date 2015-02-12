//
//  NotificationsManager.h
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 23/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SRWebSocket.h"
#import "BSSBboxRestClient.h"

/**
 The NotificationsManager is a SocketRocket abstraction to establish a websocket connection with the BboxAPI
 */
@interface NotificationsManager : NSObject <SRWebSocketDelegate>

/**
 Our current channelId
 */
@property NSString * channelId;

/**
 An array of callback to call when a notification occur.
 */
@property NSMutableArray * callbackArray;

/**
 Init a NotificationsManager
 @param restClient BboxRestClient of the bbox we want to open a websocket.
 @param appId The appId of our current application (Obtained with the ApplicationsManager)
 @return an instance of NotificationsManager
 */
- (id) initWithBboxRestClient:(BboxRestClient *)restClient andAppId:(NSString *)appId;

/**
 Open the websocket connection.
 */
- (void) connectWebSocket;

/**
 Unsubscribe to a resource.
 @param notification Resource you want to unsubscribe ex: 'Application'
 @param callback Result of the operation
 */
- (void) unSubscribeToNotification:(NSString *)notification thenCall:(void (^)(BOOL success, NSError * error))callback;

/**
 Update to a resource
 @param notification Resource you want to subscribe to ex: 'Application'
 @param callback Result of the operation
 */
- (void) UpdateNotification:(NSString *)notification thenCall:(void (^)(BOOL, NSError *))callback;

/**
 Subscribe to a resource
 @param notification Resource you want to subscribe to ex: 'Application'
 @param callback Result of the operation
 */
- (void) subscribeToNotification:(NSString *)notification thenCall:(void (^)(BOOL success, NSError * error))callback;

/**
 Send a message to a channelId
 @param message Message you want to send
 @param channelId ChannelId of the receiver
 */
- (void) sendThisMessage:(NSString *)message toChannelId:(NSString *)channelId;

/**
 Send a message to a room
 @param message Message you want to send
 @param room Room to send the message
 */
- (void) sendThisMessage:(NSString *)message toRoom:(NSString *)room;

/**
 Provide the callback you want to call when a notification occur
 @param callback Will be called when a notification occur
 */
- (void)whenANotificationOccurCall:(void (^)(NSDictionary *notification))callback;

@end
