//
//  TagSearchModel.h
//  Co\Lab 
//
//  Created by magnon on 09/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
#import "IBModelDetails.h"

@interface TagSearchModel : JSONModel

@property (strong, nonatomic) NSArray<IBModelDetails,ConvertOnDemand>* TagSearch;
@end
