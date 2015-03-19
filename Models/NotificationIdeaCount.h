//
//  NotificationIdeaCount.h
//  Co\Lab 
//
//  Created by magnon on 19/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
@protocol  NotificationIdeaCount @end

@interface NotificationIdeaCount : JSONModel
@property (nonatomic, strong) NSString *totalnotification;
@property (nonatomic, strong) NSString *totalidea;
@end
