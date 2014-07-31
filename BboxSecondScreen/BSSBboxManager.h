//
//  BboxManager.h
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 20/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSSBbox.h"

/**
 ‘BboxManager‘ is a class made to help find Bbox on the LAN. It use mDNS protocol.
 */
@interface BboxManager : NSObject <NSNetServiceDelegate, NSNetServiceBrowserDelegate>

/**
 A callback called when a bbox is found. it return a BSSBbox object.
 */
@property (nonatomic, copy) void (^callback)(Bbox *);

/**
 Method to start looking for bbox on LAN. Call the provided callback for every Bbox found.
 */
- (void) startLookingForBboxThenCall:(void (^)(Bbox * bbox))callback;

@end
