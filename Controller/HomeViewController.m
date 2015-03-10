//
//  HomeViewController.m
//  iBrief
//
//  Created by Magnon International on 14/01/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "SearchViewController.h"
#import "CoLabListViewController.h"
#import "NotificationViewController.h"
#import "PPUtilts.h"

@interface HomeViewController (){
    NSArray *imageArray;
    NSArray *cellTitleText;
    __weak IBOutlet UIView *notificationView;
}
@property (nonatomic, strong) IBOutlet UITableView *homeTableView;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageArray=ImageArray ;
    cellTitleText = CellTitleText;
    notificationView.hidden=YES;
    
    self.homeTableView.delegate   = self;
    self.homeTableView.dataSource = self;
    if (![PPUtilts sharedInstance].isNotificationViewHidden) {
        [self settingBarButton];
        notificationView.hidden = NO;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)settingBarButton{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CANCEL_BUTTON_FRAME];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateSelected];
    [cancelButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag =PPkCancel;
    [notificationView addSubview:cancelButton];
    [cancelButton bringSubviewToFront:self.view];
}
- (void)settingBarMethod:(UIButton *)settingBtn{
    
    switch (settingBtn.tag) {
        case PPkCancel:[self goToNotificationViewController];
            break;
        case PPkAttachment:
           break;
        case PPkAddOrNext:
            break;
        default:
            break;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *CellIdentifier = kStaticIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.textColor=[UIColor blackColor];
    [cell.imageView setImage:[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]]];
    cell.textLabel.text = [cellTitleText objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    else{
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.row==5) {
            cell.textLabel.numberOfLines=0;
            NSString *str = [NSString stringWithFormat:@"%@\n\n\n\n",[cellTitleText objectAtIndex:indexPath.row]];
            cell.textLabel.text=str;
        }
    }

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0){
        return kCellHeightAtIndexZero;
    }
    else if (indexPath.row==5){
        return kCellHeightAtIndexfive;
    }
    else{
        return kCellHeight;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
            
        case PPkHomeViewController:
            break;
        case PPkCreateIdeaViewController:[self goToCreateIdeaBriefsWith:YES];
            break;
        case PPkCreateBriefViewController:[self goToCreateIdeaBriefsWith:NO];
            break;
        case PPkSearchViewController:[self goToSearch];
            break;
        case PPkProfileViewController:[self goToProfile];
            break;
        case PPkLatestIdeasBrifes:[self goToLatestIdeaBriefs];
            break;
        default:
            break;
            
    }
    
}

-(void)goToProfile{
    ProfileViewController *objProfile = [ProfileViewController new];
    [self.navigationController pushViewController:objProfile animated:YES];
}
-(void)goToSearch{
    SearchViewController *objSearch= [SearchViewController new];
    [self.navigationController pushViewController:objSearch animated:YES];
}
-(void)goToCreateIdeaBriefsWith:(BOOL)NavigationType{
    CreateIdea_BriefViewController *objCreateIdea = [CreateIdea_BriefViewController new];
    [objCreateIdea setIsIdeaSubmitScreen:NavigationType];
    [self.navigationController pushViewController:objCreateIdea animated:YES];
}
-(void)goToLatestIdeaBriefs{
    [PPUtilts sharedInstance].apiCall=kApiCallLatestIdeaBrief;
    CoLabListViewController *objLatestIB = [CoLabListViewController new];
    [self.navigationController pushViewController:objLatestIB animated:YES];
}
-(void)goToNotificationViewController{
     NotificationViewController *objNotification = [NotificationViewController new];
    [self.navigationController pushViewController:objNotification animated:YES];
}

@end
