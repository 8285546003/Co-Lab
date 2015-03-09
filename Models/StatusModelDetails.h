//
//  StatusModelDetails.h
//  Co\Lab 
//
//  Created by magnon on 04/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "JSONModel.h"

@protocol  StatusModelDetails @end

@interface StatusModelDetails : JSONModel

@property (nonatomic, strong) NSString *Error;
@property (nonatomic, strong) NSString *Message;

@end
