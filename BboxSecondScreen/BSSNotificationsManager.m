//
//  NotificationsManager.m
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 23/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import "BSSNotificationsManager.h"
#import "BBSConstants.h"
/**
 Private methods for the Websocket delegate
 */
@interface NotificationsManager()

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket;
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;

@end

@implementation NotificationsManager

@synthesize channelId;



BboxRestClient * client;
SRWebSocket * webSocket;
NSString * applicationId;
NSMutableArray * notifications;

- (id) initWithBboxRestClient:(BboxRestClient *)restClient andAppId:(NSString *)appId {
    
    client = restClient;
    applicationId = appId;
    
    notifications = [[NSMutableArray alloc] init];
    
    self.callbackArray = [[NSMutableArray alloc] init];
    return self;
}

- (void)connectWebSocket {
    webSocket.delegate = nil;
    webSocket = nil;
    
    NSString *urlString =  [NSString  stringWithFormat: URL_part, client.ip];
    
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    newWebSocket.delegate = self;
    
    [newWebSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    NSLog(@"Socket OPENED");
    webSocket = newWebSocket;
    [webSocket send:(id)applicationId];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
    //[self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"%@", reason);
    //[self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    NSError *e;
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [message dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                                           error: &e];

    for (void (^cb)(NSDictionary *) in self.callbackArray) {
        cb(JSON);
    }
    
}

- (void) subscribeToNotification:(NSString *)notification thenCall:(void (^)(BOOL, NSError *))callback {
    
    Boolean exist = false;
    
    for (NSString * notif in notifications) {
        if ([notif isEqual:notification]) {
            exist = true;
        }
    }
    
    if (!exist) {
        [notifications addObject:notification];
        NSLog(@"added");
    }
    
    [self updateNotificationsThenCall:^(BOOL success, NSError *error) {
        callback(success, error);
    }];
    
}



- (void) UpdateNotification:(NSString *)notification thenCall:(void (^)(BOOL, NSError *))callback {
    
    Boolean exist = false;
    
    for (NSString * notif in notifications) {
        if ([notif isEqual:notification]) {
            exist = true;
        }
    }
    
    if (!exist) {
        [notifications addObject:notification];
        NSLog(@"added");
    }
    
    [self updateNotificationsThenCall:^(BOOL success, NSError *error) {
        callback(success, error);
    }];
    
}

- (void) unSubscribeToNotification:(NSString *)notification thenCall:(void (^)(BOOL, NSError *))callback {
    
    for (NSString * notif in notifications) {
        if ([notif isEqual:notification]) {
            [notifications delete:notif];
        }
    }
    
    [self updateNotificationsThenCall:^(BOOL success, NSError *error) {
        callback(success, error);
    }];
    
}

- (void) updateNotificationsThenCall:(void (^)(BOOL success, NSError * error))callback {
    
    NSMutableDictionary * body = [[NSMutableDictionary alloc] init];
    NSMutableArray * res = [[NSMutableArray alloc] init];
    
    for (NSString * notif in notifications) {
        [res addObject:@{ResourceId:notif}];
    }
    
    [body setObject:applicationId forKey:AppId_Key];
    [body setObject:res forKey:Resources_Key];
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * header = [[NSMutableDictionary alloc] init];
    [header setObject:[userDefaults objectForKey:Session_userDefaults_Key]  forKey:SessionId_Header_Key];
    
    
    [client post:NOTIFICATION withBody:body  withHeader:header  thenCallWithHeaders:^(BOOL success, NSInteger statusCode, NSDictionary *headers, id response, NSError *error) {
        if (success) {
            NSArray * urlArray = [[headers objectForKey:Location_Key] componentsSeparatedByString:@"/"];
            self.channelId = [urlArray objectAtIndex:[urlArray count]-1];
        }
        callback(success, error);
    }];
    
    [client post:NOTIFICATION withBody:body thenCall:^(BOOL success, NSInteger statusCode, id response, NSError *error) {
        
    }];
}


- (void)sendThisMessage:(NSString *)message toChannelId:(NSString *)channelId {
    
    NSMutableDictionary * toSend = [[NSMutableDictionary alloc] init];
    
    [toSend setObject:self.channelId forKey:Destination_Key];
    [toSend setObject:applicationId forKey:Source_Key];
    [toSend setObject:message forKey:Body_Key];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:toSend
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [webSocket send:jsonString];
}

- (void)sendThisMessage:(NSString *)message toRoom:(NSString *)room {
    [self sendThisMessage:message toChannelId:[NSString stringWithFormat:@"Message/%@", room]];
}

- (void) whenANotificationOccurCall:(void (^)(NSDictionary *))callback {
    
    Boolean exist = false;
    
    for (id cb in self.callbackArray) {
        if (cb == (id) callback) {
            exist = true;
        }
    }
    
    if (!exist) {
        [self.callbackArray addObject:callback];
    }
}

@end
