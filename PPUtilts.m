//
//  PPUtilts.m
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "PPUtilts.h"
#import "AFNetworking.h"

@implementation PPUtilts
@synthesize deviceTocken;

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (BOOL)connected {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
@end
