//
//  PPUtilts.h
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPUtilts : NSObject
@property(nonatomic,retain) NSString *deviceTocken;
@property(nonatomic,retain) NSString *userID;
+ (instancetype)sharedInstance;
@end
