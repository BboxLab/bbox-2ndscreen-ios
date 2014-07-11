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

@interface NotificationsManager : NSObject <SRWebSocketDelegate>

@property NSString * channelId;
@property NSMutableArray * callbackArray;

- (id) initWithBboxRestClient:(BboxRestClient *)restClient andAppId:(NSString *)appId;

- (void) connectWebSocket;

- (void) unSubscribeToNotification:(NSString *)notification thenCall:(void (^)(BOOL success, NSError * error))callback;

- (void) subscribeToNotification:(NSString *)notification thenCall:(void (^)(BOOL success, NSError * error))callback;

- (void) sendThisMessage:(NSString *)message toChannelId:(NSString *)channelId;
- (void) sendThisMessage:(NSString *)message toRoom:(NSString *)room;

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket;
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;

- (void)whenANotificationOccurCall:(void (^)(NSDictionary *notification))callback;

@end
