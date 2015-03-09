//
//  ExpenModelDetails.h
//  Co\Lab 
//
//  Created by magnon on 09/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"

@protocol ExpenModelDetails @end

@interface ExpenModelDetails : JSONModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *description_idea_brief;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *is_brief;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_email;
@property (nonatomic, strong) NSString *is_hot;
@property (nonatomic, strong) NSString *color_code;

@end
