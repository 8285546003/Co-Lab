//
//  NotificatioListModel.h
//  Co\Lab 
//
//  Created by magnon on 13/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
#import "NotificatioListModelDetails.h"

@interface NotificatioListModel : JSONModel
@property (strong, nonatomic) NSArray<NotificatioListModelDetails,ConvertOnDemand>* NotificatioList;
@end
