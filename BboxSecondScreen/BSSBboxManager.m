//
//  BboxManager.m
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 20/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#include <arpa/inet.h>

#import "BSSBboxManager.h"
#import "BSSBbox.h"

#import "BBSConstants.h"
@implementation BboxManager

@synthesize callback;


NSMutableArray * resolvers;

NSNetServiceBrowser *serviceBrowser;
NSNetService *serviceResolver;

- (void) startLookingForBboxThenCall:(void (^)(Bbox *))initialCallback {
    
    if (serviceBrowser) {
        [serviceBrowser stop];
    }
    
    resolvers = [[NSMutableArray alloc] init];
    
    self.callback = initialCallback;
    
    serviceBrowser = [[NSNetServiceBrowser alloc] init];
    serviceBrowser.delegate = self;
    [serviceBrowser searchForServicesOfType:MDNS_TYPE inDomain:MDNS_DOMAIN];
}

#pragma mark NSNetserviceBrowserDelegate
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    if ([[aNetService name] isEqualToString:BBoxIp]) {
        aNetService.delegate = self;
        [aNetService resolveWithTimeout:0.0];
        [resolvers addObject:aNetService];
    }
}

- (void)netServiceDidResolveAddress:(NSNetService *)service {
    for (NSData* data in [service addresses]) {
        NSLog(@"Description %@", [data description]);
        char addressBuffer[100];
        struct sockaddr_in* socketAddress = (struct sockaddr_in*) [data bytes];
        int sockFamily = socketAddress->sin_family;
        if (sockFamily == AF_INET) {
            const char* addressStr = inet_ntop(sockFamily,
                                               &(socketAddress->sin_addr), addressBuffer,
                                               sizeof(addressBuffer));            
            if (addressStr) {
                NSString * adr = [[NSString alloc] initWithUTF8String:addressStr];
                self.callback([[Bbox alloc]initWithIp:adr]);
                NSLog(@"Found box at %s", addressStr);
            }
        }
    }
    
}


@end
