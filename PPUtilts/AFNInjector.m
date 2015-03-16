//
//  AFNInjector.m
//  Co\Lab 
//
//  Created by magnon on 11/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "AFNInjector.h"
#import "AFNetworking.h"
#import "PPUtilts.h"

@implementation AFNInjector
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) parameters:(NSDictionary *)dic completionBlock:(void (^)(NSArray *data, NSError *error)) block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = CONTENT_TYPE_HTML;
        [manager POST:BASE_URL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil, error);
        }];
    });
}
@end
