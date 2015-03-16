//
//  NotificatioListModelDetails.h
//  Co\Lab 
//
//  Created by magnon on 13/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
@protocol  NotificatioListModelDetails @end
@interface NotificatioListModelDetails : JSONModel
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *read_status;
@property (nonatomic, strong) NSString *send_time;
@property (nonatomic, strong) NSString *n_parent_id;
@property (nonatomic, strong) NSString *n_notification_send_time;

@end


