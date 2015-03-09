//
//  MyBriefModel.h
//  Co\Lab 
//
//  Created by magnon on 09/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
#import "MyBriefModelDetails.h"

@interface MyBriefModel : JSONModel
@property (strong, nonatomic) NSArray<MyBriefModelDetails,ConvertOnDemand>* MyBrief;

@end
