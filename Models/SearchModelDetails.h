//
//  SearchModelDetails.h
//  Co\Lab 
//
//  Created by magnon on 09/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"

@protocol SearchModelDetails @end

@interface SearchModelDetails : JSONModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *tag;
@end
