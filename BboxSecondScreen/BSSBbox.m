//
//  Bbox.m
//  BboxSecondScreen
//
//  Created by Pierre-Etienne Cherière on 20/05/2014.
//  Copyright (c) 2014 Bouygues Telecom. All rights reserved.
//

#import "BSSBbox.h"

@implementation Bbox

@synthesize remoteManager;
@synthesize connectManager;
@synthesize applicationsManager;
@synthesize bboxRestClient;
@synthesize notificationsManager;
@synthesize ip;

- (id)initWithIp:(NSString *)initialIp {
    
    self.ip = initialIp;
    
    self.bboxRestClient = [[BboxRestClient alloc] initWithIp:self.ip];
    
    self.connectManager = [[ConnectManager alloc] initWithBboxRestClient:self.bboxRestClient];
    self.remoteManager = [[RemoteManager alloc] initWithBboxRestClient:self.bboxRestClient];
    self.applicationsManager = [[ApplicationsManager alloc] initWith:self.bboxRestClient];
    return self;
}

@end
