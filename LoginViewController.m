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



typedef void(^AlertViewActionBlock)(void);

@interface LoginViewController ()<GPPSignInDelegate>


@property (nonatomic, copy) void (^confirmActionBlock)(void);
@property (nonatomic, copy) void (^cancelActionBlock)(void);

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
        [self.navigationController pushViewController:homeCont animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (IBAction)signIn:(id)sender{
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
    
    if (error) {
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
                        
                        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AUTH"];
                        NSLog(@"Email= %@",[GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@",person.identifier);
                        NSLog(@"User Name=%@",[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName]);
                        NSLog(@"Gender=%@",person.gender);
                        
                    }
                }];

}
}
- (void)didDisconnectWithError:(NSError *)error {
  
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    [[self navigationController] pushViewController:viewController animated:YES];
}

@end
