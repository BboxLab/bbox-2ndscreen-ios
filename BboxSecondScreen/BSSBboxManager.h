//
//  BboxManager.h
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 20/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSSBbox.h"

@interface BboxManager : NSObject <NSNetServiceDelegate, NSNetServiceBrowserDelegate>

@property NSNetServiceBrowser *serviceBrowser;
@property NSNetService *serviceResolver;

@property (nonatomic, copy) void (^callback)(Bbox *);

- (void) startLookingForBboxThenCall:(void (^)(Bbox * bbox))callback;

@end
