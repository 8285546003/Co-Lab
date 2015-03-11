//
//  AFNInjector.h
//  Co\Lab 
//
//  Created by magnon on 11/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AFNInjector : NSObject
- (void) parameters:(NSDictionary *)dic completionBlock:(void (^)(NSArray *data, NSError *error)) block;
@end