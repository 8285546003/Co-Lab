//
//  SearchModel.h
//  Co\Lab 
//
//  Created by magnon on 09/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
#import "SearchModelDetails.h"

@interface SearchModel : JSONModel
@property (strong, nonatomic) NSArray<SearchModelDetails,ConvertOnDemand>* SearchAuto;

@end
