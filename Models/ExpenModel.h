//
//  ExpenModel.h
//  Co\Lab 
//
//  Created by magnon on 09/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
#import "ExpenModelDetails.h"

@interface ExpenModel : JSONModel
@property (strong, nonatomic) NSArray<ExpenModelDetails,ConvertOnDemand>* Detail;

@end
