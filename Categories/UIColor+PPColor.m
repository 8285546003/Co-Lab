//
//  UIColor+PPColor.m
//  Co\Lab 
//
//  Created by magnon on 20/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "UIColor+PPColor.h"

@implementation UIColor (PPColor)


+ (UIColor*) PPRedColor {
    return [UIColor colorWithRed:0.816 green:0.216 blue:0.216 alpha:1]; /*#d03737*/
  //return [UIColor colorWithRed:196.0f/255.0f    green:34.0f/255.0f blue:42.0f/255.0f alpha:1];
}

+ (UIColor*) PPYellowColor {
    return  [UIColor colorWithRed:0.957 green:0.878 blue:0.208 alpha:1]; /*#f4e035*/
    //return [UIColor colorWithRed:240.0f/255.0f    green:220.0f/255.0f blue:42.0f/255.0f alpha:1];
}

+ (UIColor*) PPGreenColor {
    return  [UIColor colorWithRed:0.471 green:0.749 blue:0.345 alpha:1]; /*#78bf58*/
   // return [UIColor colorWithRed:103.0f/255.0f    green:181.0f/255.0f blue:71.0f/255.0f alpha:1];
}

+ (UIColor*) PPBlueColor {
    return  [UIColor colorWithRed:0 green:0.671 blue:0.678 alpha:1]; /*#00abad*/
    //return [UIColor colorWithRed:21.0f/255.0f     green:156.0f/255.0f blue:157.0f/255.0f alpha:1];
}
+ (UIColor*) PPBackGroundColor{
    return [UIColor colorWithRed:0.91 green:0.886 blue:0.863 alpha:1]; /*#e8e2dc*/
    //return [UIColor colorWithRed:227.0f/255.0f     green:219.0f/255.0f blue:212.0f/255.0f alpha:1];
}
+ (UIColor*) PPProfileBackGroundColor{
    return [UIColor colorWithRed:0.176 green:0.176 blue:0.176 alpha:1]; /*#2d2d2d*/
   // return [UIColor colorWithRed:34.0f/255.0f     green:34.0f/255.0f blue:34.0f/255.0f alpha:1];
}
+ (UIColor*) PPTextColor{
    return [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:1]; /*#252525*/
    // return [UIColor colorWithRed:34.0f/255.0f     green:34.0f/255.0f blue:34.0f/255.0f alpha:1];
}

@end
