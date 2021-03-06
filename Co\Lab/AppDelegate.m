//
//  AppDelegate.m
//  iBrief
//
//  Created by Magnon International on 13/01/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
// testing by mousumi

#import "AppDelegate.h"
#import <GooglePlus/GooglePlus.h>
#import "PPUtilts.h"

@interface AppDelegate () <GPPDeepLinkDelegate>

@end
@implementation AppDelegate
static NSString * const kClientID = @"1043369017986-eatg764omdvlrp4jb8tcge2uf6nk5rqs.apps.googleusercontent.com";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set app's client ID for |GPPSignIn| and |GPPShare|.
    [GPPSignIn sharedInstance].clientID = kClientID;
    
    // Override point for customization after application launch.
    LoginViewController *loginCont = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
   navCont = [[UINavigationController alloc] initWithRootViewController:loginCont];
    navCont.navigationBar.hidden = YES;
    self.window.rootViewController = navCont;
    // Read Google+ deep-link data.
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
    return YES;
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [PPUtilts sharedInstance].deviceTocken=token;
    NSLog(@"content---%@", token);
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if (url) {
        HomeViewController *homeCont = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        [navCont pushViewController:homeCont animated:YES];
    }
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

#pragma mark - GPPDeepLinkDelegate

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
    // An example to handle the deep link data.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Deep-link Data"
                          message:[deepLink deepLinkID]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}


@end
