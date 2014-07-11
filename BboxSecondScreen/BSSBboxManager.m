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

@implementation BboxManager

@synthesize callback;

NSMutableArray * resolvers;

- (void) startLookingForBboxThenCall:(void (^)(Bbox *))initialCallback {
    
    if (self.serviceBrowser) {
        [self.serviceBrowser stop];
    }
    
    resolvers = [[NSMutableArray alloc] init];
    
    self.callback = initialCallback;
    
    self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
    self.serviceBrowser.delegate = self;
    [self.serviceBrowser searchForServicesOfType:@"_workstation._tcp" inDomain:@"local"];
    
}

#pragma mark NSNetserviceBrowserDelegate
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    if ([aNetService.name hasPrefix:@"OpenSTB"]) {
        aNetService.delegate = self;
        [aNetService resolveWithTimeout:0.0];
        [resolvers addObject:aNetService];
    }
}

- (void)netServiceDidResolveAddress:(NSNetService *)service {
    for (NSData* data in [service addresses]) {
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
                NSLog(@"Found OpenSTB at %s", addressStr);
            }
        }
    }
    
}


@end