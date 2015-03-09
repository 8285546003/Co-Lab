//
//  IBModel.h
//  Co\Lab 
//
//  Created by magnon on 04/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
#import "IBModelDetails.h"

@interface IBModel : JSONModel
@property (strong, nonatomic) NSArray<IBModelDetails,ConvertOnDemand>* LatestIdeaBrief;
@end
