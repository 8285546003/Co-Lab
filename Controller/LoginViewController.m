//
//  LoginViewController.m
//  iBrief
//
//  Created by Magnon International on 13/01/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "LoginViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "PPUtilts.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()<GPPSignInDelegate>
{
    MBProgressHUD *hud;
}
@end


@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AUTH"]) {
        HomeViewController *homeCont = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        [self.navigationController pushViewController:homeCont animated:NO];
    }
}
- (IBAction)signIn:(id)sender{
    hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = PLEASE_WAIT;
    [self connectWithGoogle];
   
//[PPUtilts sharedInstance].connected?[self connectWithGoogle]:kCustomAlert(@"No NetWork", @"Something went wrong please check your WIFI connection");
}

-(void)connectWithGoogle{
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    [signIn setScopes:[NSArray arrayWithObject:@"https://www.googleapis.com/auth/plus.login"]];
    [signIn setDelegate:self];
    [signIn authenticate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
   // hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
   // hud.labelText = PLEASE_WAIT;
    if (error) {
        [self.navigationController popToRootViewControllerAnimated:FALSE];
        [hud hide:YES];
        // Do some error handling here.
    } else {
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        // *4. Use the "v1" version of the Google+ API.*
        plusService.apiVersion = @"v1";
        
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        
                        
                        
                        //Handle Error
                        
                    } else
                    {

                        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                        manager.requestSerializer = [AFJSONRequestSerializer serializer];
                        manager.responseSerializer = [AFJSONResponseSerializer serializer];
                        manager.responseSerializer.acceptableContentTypes = CONTENT_TYPE_HTML;
                        
                        NSString *strDeviceTocken=[PPUtilts sharedInstance].deviceTocken;;
                        if (!strDeviceTocken) {
                            strDeviceTocken=@"";
                        }
                        
                        NSDictionary *parameters = @{kApiCall:@"UserLogin",@"display_name":[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName],@"user_email":[GPPSignIn sharedInstance].authentication.userEmail,@"device_token":strDeviceTocken ,@"os_type":@"1"};
                        [manager POST:BASE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
                            if ([[responseObject valueForKey:@"Error"] isEqualToString:@"false"]&&[[responseObject valueForKey:@"Message"] isEqualToString:@"Success"]) {
                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AUTH"];
                            [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:kUserid] forKey:@"USERID"];
                            [PPUtilts sharedInstance].userID=[responseObject valueForKey:kUserid];
                            HomeViewController *homeCont = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                               // NSMutableArray *viewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
                                //[viewControllers removeObjectIdenticalTo:self];
                               // self.navigationController.viewControllers = viewControllers;
                                [self.navigationController pushViewController:homeCont animated:NO];


                                [hud hide:YES];

                            }
                            else{
                                kCustomErrorAlert;
                            }
                            //[hud hide:YES];

                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [hud hide:YES];
                            NSLog(@"Error: %@", error);
                            kCustomErrorAlert;
                            
                        }];
                        
                        
                    }
                }];

}
}
@end
