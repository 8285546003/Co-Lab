//
//  TagSearchModel.h
//  Co\Lab 
//
//  Created by magnon on 09/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
#import "TagSearchModelDetails.h"

@interface TagSearchModel : JSONModel

@property (strong, nonatomic) NSArray<TagSearchModelDetails,ConvertOnDemand>* TagSearch;
@end
