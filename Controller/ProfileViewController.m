//
//  ProfileViewController.m
//  Co\Lab 
//
//  Created by magnon on 17/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "ProfileViewController.h"
#import "CoLabListViewController.h"
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
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    imageArray    = imageArrayProfile;
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
    
    if ([PPUtilts isIPad]) {
        self.profileTableView.frame=CGRectMake(0, 600, self.view.frame.size.width, self.view.frame.size.height);
    }
    else{
    if ([PPUtilts isiPhone5]) {
        self.profileTableView.frame=CGRectMake(10, 242, self.view.frame.size.width, self.view.frame.size.height);
    }
    else if ([PPUtilts isiPhone6]){
        self.profileTableView.frame=CGRectMake(0, 240, self.view.frame.size.width, self.view.frame.size.height);
    }
    else if ([PPUtilts isiPhone6Plus]){
        self.profileTableView.frame=CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height);
    }
    if ([PPUtilts isiPhone4]){
        self.profileTableView.frame=CGRectMake(0, 55, self.view.frame.size.width, self.view.frame.size.height);
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
    
    [cancelButton setFrame:CGRectMake(25, self.view.bounds.size.height - 45, 45, 45)];
    [cancelButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected];
    [cancelButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = PPkCancel;
    [self.view addSubview:cancelButton];
}
- (void)settingBarMethod:(UIButton *)settingBtn{
    switch (settingBtn.tag) {
        case PPkCancel:
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
           badge = [CustomBadge customBadgeWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"NOTIFICATION"] withStyle:[BadgeStyle oldStyle]];
            badge.frame=CGRectMake(60, -4, 30, 30);
            [badge bringSubviewToFront:cell.contentView];
            [cell.contentView  addSubview:badge];
        }
        else{
            [badge removeFromSuperview];
        }
    }
    
    else{
         cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 return (indexPath.row==0) ?  kCellHeightAtIndexZero : kCellHeight;
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
            CoLabListViewController *objProfile = [CoLabListViewController new];
            [self.navigationController pushViewController:objProfile animated:YES];
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
