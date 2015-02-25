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
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
//- (void)addButtomNavigationBar:(UIView*)inView fromThaTop:(CGRectMake)closeFrame And:(CGRectMake)addFrame{
//    
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeButton setFrame:closeFrame];
//    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateNormal];
//    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateSelected];
//    [closeButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
//    closeButton.tag = 0;
//    [inView addSubview:closeButton];
//    
//    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [nextButton setFrame:Add];
//    [nextButton setImage:[UIImage imageNamed:@"red_plus_down.png"] forState:UIControlStateNormal];
//    [nextButton setImage:[UIImage imageNamed:@"red_plus_down.png"] forState:UIControlStateSelected];
//    [nextButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
//    nextButton.tag = 1;
//    [inView addSubview:nextButton];
//}


//- (void)GetData:(NSDictionary *)parameters completionBlock:(void (^)(NSArray *data, NSError *error))block {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
//
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//        
//        [manager POST:BASE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//            
//            NSLog(@"%@",responseObject);
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//
//            
//        }];
//
//    });
//}

@end
