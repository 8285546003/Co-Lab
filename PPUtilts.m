//
//  PPUtilts.m
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "PPUtilts.h"

@implementation PPUtilts
@synthesize deviceTocken;

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
//-(UIImageView*)addLogo InView:(UIView*)View{
//    UIImage *imageLogo = [[UIImage alloc] init];
//    UIImageView *imageViewForLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10,View.fra, 0, 0)];
//    [imageViewForLogo  setImage:imageLogo];
//    return imageViewForLogo;
//}

@end
