//
//  PPUtilts.m
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "PPUtilts.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@implementation PPUtilts

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

-(BOOL)isNotificationViewHidden{
    return YES;
}

+ (BOOL)isiPhone6{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if( screenHeight < screenWidth ){
        screenHeight = screenWidth;
    }
    if ( screenHeight > 568 && screenHeight < 736 ){
        return YES;
    }
    else{
        return NO;
    }
}
+ (BOOL)isiPhone5{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if( screenHeight < screenWidth ){
        screenHeight = screenWidth;
    }
    if( screenHeight > 480 && screenHeight < 667 ){
        return YES;
    }
    else{
        return NO;
    }
}
+ (BOOL)isiPhone6Plus{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if( screenHeight < screenWidth ){
        screenHeight = screenWidth;
    }
    if ( screenHeight > 667){
        return YES;
    }
    else{
        return NO;
    }
}
+ (BOOL)isiPhone4{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if( screenHeight < screenWidth ){
        screenHeight = screenWidth;
    }
    if ( screenHeight== 480){
        return YES;
    }
    else{
        return NO;
    }
}
+ (BOOL)isIPad {
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return YES; /* Device is iPad */
    }
    else{
        return NO;
    }
}

+ (BOOL)isIPhone {
    return ![PPUtilts isIPad];
}


-(void)toast:(NSString*)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @ "Checkmark"]];
}

@end
