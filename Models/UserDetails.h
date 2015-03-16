//
//  UserDetails.h
//  Co\Lab 
//
//  Created by magnon on 16/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"
@protocol  UserDetails @end
@interface UserDetails : JSONModel
@property (nonatomic, strong) NSString *display_name;
@property (nonatomic, strong) NSString *user_email;
@property (nonatomic, strong) NSString *user_id;
@end
