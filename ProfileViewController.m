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

@interface ProfileViewController (){
NSArray *imageArray;
NSArray *cellTitleText;
}
@property (nonatomic, strong) IBOutlet UITableView *profileTableView;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:193 green:6 blue:4 alpha:1.0]];
    imageArray   = @[@"Profile_Image.png",@"Create_New_Idea_Image.png",@"Create_New_Brief_Image.png",@"Search_Image.png",@"Profile_Image.png"];
    cellTitleText = @[@"Profile",@"My Ideas",@"My Briefs",@"Notifications",@"Log out"];
    
    self.profileTableView.delegate   = self ;
    self.profileTableView.dataSource = self;
    [self settingBarButton];
}

- (void)settingBarButton{
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(10, self.view.bounds.size.height - 60, 50, 50)];
    [nextButton setImage:[UIImage imageNamed:@"Next_Image.png"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"Next_Image.png"] forState:UIControlStateSelected];
    [nextButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = 1000;
    [self.view addSubview:nextButton];
}

- (void)settingBarMethod:(UIButton *)settingBtn{
    NSLog(@"Button tag == %ld",(long)settingBtn.tag);
    switch (settingBtn.tag) {
        case Cancel:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case Add:
            break;
        case Attachment:
            break;
        default:
            break;
    }
}


#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [cellTitleText count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
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
       return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0){
        return 100;;
    }
    else{
        return 75;

    }

    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case PPkMyProfile:
            break;
        case PPkMyIdeas:[self goToWithApiCall:kMyMyIdeasSting];
            break;
        case PPkMyBriefs:[self goToWithApiCall:kMyBriefsSting];
            break;
        case PPkMyNotifications:[self goToWithApiCall:kMyNotificationsSting];
            break;
        case PPkLogOut:[self goToWithApiCall:kLogOutSting];
            break;
        default:
            break;
            
    }
}

-(void)goToWithApiCall:(NSString*)apiCall{
    if (apiCall==kLogOutSting||![[NSUserDefaults standardUserDefaults] valueForKey:@"USERID"]) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"AUTH"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"USERID"];
        [[GPPSignIn sharedInstance]signOut];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [PPUtilts sharedInstance].userID= [[NSUserDefaults standardUserDefaults] valueForKey:@"USERID"];
        [PPUtilts sharedInstance].apiCall=apiCall;
        CoLabListViewController *objProfile = [CoLabListViewController new];
        [self.navigationController pushViewController:objProfile animated:NO];
    }

}


- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
