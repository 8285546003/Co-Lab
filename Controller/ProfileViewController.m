//
//  ProfileViewController.m
//  Co\Lab 
//
//  Created by magnon on 17/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "ProfileViewController.h"
#import "HomeViewController.h"
#import <GooglePlus/GooglePlus.h>
#import "PPUtilts.h"
#import "UIColor+PPColor.h"
#import "NotificationViewController.h"
#import "CustomBadge.h"

@interface ProfileViewController (){
NSArray *imageArray;
NSArray *cellTitleText;
    CustomBadge *badge;
}
@property (nonatomic, strong) IBOutlet UITableView *profileTableView;
@property (nonatomic, strong) IBOutlet UIImageView *imgIcon;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]) {
        imageArray    = imageArrayProfile6;

    }
    else{
        imageArray    = imageArrayProfile;

    }
    cellTitleText = cellTitleProfile;
    
    self.profileTableView.delegate   = self ;
    self.profileTableView.dataSource = self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.profileTableView reloadData];
    [self settingBarButton];
    [self updateFrame];
    [self.view setBackgroundColor:[UIColor PPProfileBackGroundColor]];
}
-(void)updateFrame{
    //_imgIcon.image=nil;
    [_imgIcon setImage:[UIImage imageNamed:@"app_icon"]];

    if ([PPUtilts isIPad]) {
        self.profileTableView.frame=CGRectMake(10, 600, self.view.frame.size.width, self.view.frame.size.height);
    }
    else{
    if ([PPUtilts isiPhone5]) {
        self.profileTableView.frame=CGRectMake(10, 240, self.view.frame.size.width, self.view.frame.size.height);
    }
    else if ([PPUtilts isiPhone6]){
        [_imgIcon setImage:[UIImage imageNamed:@"app_icon6"]];
        [_imgIcon setFrame:CGRectMake(25, 20, 60, 60)];
        self.profileTableView.frame=CGRectMake(10, 250, self.view.frame.size.width, self.view.frame.size.height);
    }
    else if ([PPUtilts isiPhone6Plus]){
        [_imgIcon setImage:[UIImage imageNamed:@"app_icon6"]];
        [_imgIcon setFrame:CGRectMake(25, 20, 60, 60)];
        self.profileTableView.frame=CGRectMake(10, 315, self.view.frame.size.width, self.view.frame.size.height);
    }
    if ([PPUtilts isiPhone4]){
        self.profileTableView.frame=CGRectMake(10, 154, self.view.frame.size.width, self.view.frame.size.height);
    }
    else{
    }
 }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)settingBarButton{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([PPUtilts isiPhone6]){
        [cancelButton setFrame:CGRectMake(25, self.view.bounds.size.height - 60, 60, 60)];
        [cancelButton setImage:[UIImage imageNamed:@"preWhite6.png"] forState:UIControlStateNormal];
        [cancelButton setImage:[UIImage imageNamed:@"preWhite6.png"] forState:UIControlStateSelected];
    }
    else if ([PPUtilts isiPhone6Plus]){
        
        [cancelButton setFrame:CGRectMake(30, self.view.bounds.size.height - 60, 60, 60)];
        [cancelButton setImage:[UIImage imageNamed:@"preWhite6.png"] forState:UIControlStateNormal];
        [cancelButton setImage:[UIImage imageNamed:@"preWhite6.png"] forState:UIControlStateSelected];
    }
    else{
        [cancelButton setFrame:CGRectMake(25, self.view.bounds.size.height - 45, 45, 45)];
        [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME_WHITE] forState:UIControlStateNormal];
        [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME_WHITE] forState:UIControlStateSelected];
    }

    [cancelButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = PPkCancel;
    [self.view addSubview:cancelButton];
}
- (void)settingBarMethod:(UIButton *)settingBtn{
    switch (settingBtn.tag) {
        case PPkCancel:
            if ([PPUtilts sharedInstance].apiCall==kApiCallNotifications) {
                [PPUtilts sharedInstance].apiCall=nil;
            }
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case PPkAttachment:
            break;
        case PPkAddOrNext:
            break;
        default:
            break;
    }
}


#pragma UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [cellTitleText count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *MyIdentifier = kStaticIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }

    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.textColor=[UIColor whiteColor];
    [cell.imageView setImage:[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]]];
    cell.textLabel.text = [cellTitleText objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    }
    else if (indexPath.row==3){
        cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"NOTIFICATION"] integerValue]==0) {
            [UIApplication sharedApplication].applicationIconBadgeNumber=[[[NSUserDefaults standardUserDefaults] valueForKey:@"NOTIFICATION"] integerValue];
           badge = [CustomBadge customBadgeWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"NOTIFICATION"] withStyle:[BadgeStyle oldStyle]];
            if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]){
                badge.frame=CGRectMake(60, -2, 30, 30);
            }
            else{
                badge.frame=CGRectMake(52, -4, 25, 25);

                //badge.frame=CGRectMake(52, -1, 25, 25);
            }

            [badge bringSubviewToFront:cell.contentView];
            [cell.contentView  addSubview:badge];
        }
        else{
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
            [badge removeFromSuperview];
        }
    }
    
    else{
         cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]) {
        return (indexPath.row==0)?  85 : 65;

    }
    else{
        return (indexPath.row==0) ?  kCellHeightAtIndexZero : kCellHeight;

    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case PPkMyProfile:
            break;
        case PPkMyIdeas:[self goToWithApiCall:kApiCallMyIdea];
            break;
        case PPkMyBriefs:[self goToWithApiCall:kApiCallMyBrief];
            break;
        case PPkMyNotifications:[self gotoNotificationController];
            break;
        case PPkLogOut:[self goToWithApiCall:kApiCallLogOut];
            break;
        default:
            break;
            
    }
}
-(void)gotoNotificationController{
    NotificationViewController *obj = [NotificationViewController new];
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)goToWithApiCall:(NSString*)apiCall{
    if (apiCall==kApiCallLogOut) {
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"USERID"];
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        [signIn signOut];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        if (GET_USERID) {
            [PPUtilts sharedInstance].apiCall=apiCall;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            kCustomAlert(@"Failed to Login", @"Something went wrong please go to (profile->Loout) for re-login", @"Ok");
        }

    }

}
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
