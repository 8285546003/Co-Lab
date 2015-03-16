//
//  NotificationCountModel.h
//  Co\Lab 
//
//  Created by magnon on 16/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
#import "NotificationCount.h"

@interface NotificationCountModel : JSONModel
@property (strong, nonatomic) NSArray<NotificationCount,ConvertOnDemand>* NotificatioTotal;

@end
