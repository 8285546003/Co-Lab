//
//  UserDetailsModel.h
//  Co\Lab 
//
//  Created by magnon on 16/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
#import "UserDetails.h"
@interface UserDetailsModel : JSONModel
@property (strong, nonatomic) NSArray<UserDetails,ConvertOnDemand>* UserDetails;

@end
