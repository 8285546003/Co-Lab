//
//  StatusModel.h
//  Co\Lab 
//
//  Created by magnon on 04/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
#import "StatusModelDetails.h"

@interface StatusModel :JSONModel

@property (strong, nonatomic) NSArray<StatusModelDetails,ConvertOnDemand>* StatusArr;

@end
