//
//  MyIdeaModel.h
//  Co\Lab 
//
//  Created by magnon on 09/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
#import "MyIdeaModelDetails.h"

@interface MyIdeaModel : JSONModel
@property (strong, nonatomic) NSArray<MyIdeaModelDetails,ConvertOnDemand>* MyIdea;

@end
