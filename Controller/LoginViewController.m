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
#import "StatusModel.h"
#import "StatusModelDetails.h"
#import "AFNInjector.h"
#import "UserDetails.h"
#import "UserDetailsModel.h"
#import "NotificationIdeaCount.h"
#import "NotificationIdeaModel.h"

@interface LoginViewController ()<GPPSignInDelegate>
{
    StatusModel         *statusModel;
    StatusModelDetails  *status;
    
    UserDetails         *userDetail;
    UserDetailsModel    *userModel;
    
    NotificationIdeaCount  *notificationCount;
    NotificationIdeaModel  *notificationModel;
    
    
    
    MBProgressHUD       *hud;
    int i;
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
    if (GET_USERID) {
        HomeViewController *homeCont = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        [self.navigationController pushViewController:homeCont animated:NO];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self.view setBackgroundColor:[UIColor PPBackGroundColor]];
}
-(void)timerFired{
    i++;
    if (i==60) {
        [hud hide:YES];
        kLoginAlert(@"Network Error", @"Something went wrong please try again.", @"Cancel",@"Retry");
        [_timer invalidate];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self connectWithGoogle];
    }
}
- (IBAction)signIn:(id)sender{
    [self connectWithGoogle];
}

-(void)connectWithGoogle{
    hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = PLEASE_WAIT;
    _timer=[NSTimer new];
    
    i=0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(timerFired)
                                            userInfo:nil
                                             repeats:YES];
    
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
                        
                        NSString *strDeviceTocken=[PPUtilts sharedInstance].deviceTocken;;
                        if (!strDeviceTocken) {
                            strDeviceTocken=@"";
                        }
                        
                        NSDictionary *parameters = @{kApiCall:kApiCallLogin,@"display_name":[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName],@"user_email":[GPPSignIn sharedInstance].authentication.userEmail,@"device_token":strDeviceTocken ,@"os_type":@"1"};
                        [[NSUserDefaults standardUserDefaults] setValue:[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName] forKey:@"USERNAME"];
                        AFNInjector *objAFN = [AFNInjector new];
                        [objAFN parameters:parameters completionBlock:^(id data, NSError *error) {
                            if(!error) {
                                statusModel = [[StatusModel alloc] initWithDictionary:data error:nil];
                                status = statusModel.StatusArr[[ZERO integerValue]];
                                userModel= [[UserDetailsModel alloc] initWithDictionary:data error:nil];
                                userDetail=userModel.UserDetails[[ZERO integerValue]];
                                notificationModel= [[NotificationIdeaModel alloc] initWithDictionary:data error:nil];
                                notificationCount=notificationModel.NotificatioTotal[[ZERO integerValue]];
                                
                                if ([status.Error isEqualToString:kResultError]) {
                                    if ([status.Message isEqualToString:kResultMessage]) {
                                        [[NSUserDefaults standardUserDefaults] setValue:userDetail.user_id forKey:@"USERID"];
                                        if (![notificationCount.totalnotification isEqualToString:ZERO]) {
                                            [[NSUserDefaults standardUserDefaults] setValue:notificationCount.totalnotification forKey:@"NOTIFICATION"];
                                            [[NSUserDefaults standardUserDefaults] setValue:notificationCount.totalidea         forKey:@"NOTIFICATIONIDEA"];
                                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FIRSTLOGIN"];
                                        }

                                        HomeViewController *homeCont = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                                        [_timer invalidate];
                                        [self.navigationController pushViewController:homeCont animated:NO];
                                    }
                                    else{
                                        kCustomAlert(@"", status.Message, @"Ok");
                                    }
                                }
                                else{
                                    kCustomAlert(@"", status.Message, @"Ok");
                                }
                                [hud hide:YES];
                            } else {
                                [hud hide:YES];
                            }
                        }];
                    }
                }];

        }
}
@end
