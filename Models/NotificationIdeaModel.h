//
//  NotificationIdeaModel.h
//  Co\Lab 
//
//  Created by magnon on 19/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
#import "NotificationIdeaCount.h"

@interface NotificationIdeaModel : JSONModel
@property (strong, nonatomic) NSArray<NotificationIdeaCount,ConvertOnDemand>* NotificatioTotal;

@end
