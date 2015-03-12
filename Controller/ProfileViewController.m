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

@interface ProfileViewController (){
NSArray *imageArray;
NSArray *cellTitleText;
}
@property (nonatomic, strong) IBOutlet UITableView *profileTableView;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:193 green:6 blue:4 alpha:1.0]];
    imageArray    = imageArrayProfile;
    cellTitleText = cellTitleProfile;
    
    self.profileTableView.delegate   = self ;
    self.profileTableView.dataSource = self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self settingBarButton];
    [self updateFrame];
    [self.view setBackgroundColor:[UIColor PPProfileBackGroundColor]];
}
-(void)updateFrame{
     if ([PPUtilts isiPhone4]){
         self.profileTableView.frame=CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)settingBarButton{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CANCEL_BUTTON_FRAME];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME_WHITE] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME_WHITE] forState:UIControlStateSelected];
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
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;    //count of section
//}


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
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    else{
         cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0){
        return kCellHeightAtIndexZero;;
    }
    else{
        return kCellHeight;
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
        case PPkMyNotifications://[self goToWithApiCall:kApiCallNotifications];
            break;
        case PPkLogOut:[self goToWithApiCall:kApiCallLogOut];
            break;
        default:
            break;
            
    }
}

-(void)goToWithApiCall:(NSString*)apiCall{
    if (apiCall==kApiCallLogOut) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AUTH"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"USERID"];
        [[GPPSignIn sharedInstance]signOut];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        if (GET_USERID) {
           // [PPUtilts sharedInstance].userID=GET_USERID;
            [PPUtilts sharedInstance].apiCall=apiCall;
            CoLabListViewController *objProfile = [CoLabListViewController new];
            [self.navigationController pushViewController:objProfile animated:NO];
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
