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
#import "CustomBadge.h"
#import "NotificationCount.h"
#import "AFNInjector.h"
#import "StatusModelDetails.h"
#import "StatusModel.h"
#import "NotificationCount.h"
#import "NotificationCountModel.h"


@interface HomeViewController (){
    NSArray *imageArray;
    NSArray *cellTitleText;
    __weak IBOutlet UIView *notificationView;
    
    StatusModel         *statusModel;
    StatusModelDetails  *status;
    
    NotificationCount  *notificationCount;
    NotificationCountModel*notificationCountModel;
    
        __weak IBOutlet UILabel       *lblNotificationCount;
    CustomBadge *badge;
 
    
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
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Disable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Enable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}
-(void)getNotificationCount{
    
    NSDictionary *parameters = @{kApiCall:kApiCallNotificationsCount,kUserid:GET_USERID};
    
    AFNInjector *objAFN = [AFNInjector new];
    [objAFN parameters:parameters completionBlock:^(id data, NSError *error) {
        if(!error) {
            statusModel = [[StatusModel alloc] initWithDictionary:data error:nil];
            status = statusModel.StatusArr[[ZERO integerValue]];
            notificationCountModel= [[NotificationCountModel alloc] initWithDictionary:data error:nil];
            notificationCount=notificationCountModel.NotificatioTotal[[ZERO integerValue]];
            if ([status.Error isEqualToString:kResultError]) {
                if ([status.Message isEqualToString:kResultMessage]) {
                NSString *str=[NSString stringWithFormat:@"%@.                          YOU HAVE                        %@ NEW IDEAS                 TO YOUR                          %@ BRIEFS.",[[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"],[[NSUserDefaults standardUserDefaults] valueForKey:@"NOTIFICATIONIDEA"],notificationCount.totalnotification];
                    lblNotificationCount.text=str;
                    [self.homeTableView reloadData];
                }
                else{
                    kCustomAlert(@"", status.Message, @"Ok");
                }
            }
            else{
                kCustomAlert(@"", status.Message, @"Ok");
            }
        } else {
            
        }
    }];

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    imageArray=ImageArray ;
    cellTitleText = CellTitleText;
    
    
    self.homeTableView.delegate   = self;
    self.homeTableView.dataSource = self;

    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self.view  setAlpha:1.0f];
    notificationView.hidden=YES;
    if (GET_USERID) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FIRSTLOGIN"]) {
            [self.view  setAlpha:0.85f];
            notificationView.hidden = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FIRSTLOGIN"];
        }
        [self getNotificationCount];
    }
    
    [self.view setBackgroundColor:[UIColor PPBackGroundColor]];
    [self updateFrame];
}
-(void)updateFrame{
    if ([PPUtilts isIPad]) {
        self.homeTableView.frame=CGRectMake(0, 540, self.view.frame.size.width, self.view.frame.size.height);
    }
    else{
    if ([PPUtilts isiPhone5]) {
        self.homeTableView.frame=CGRectMake(0, 90, self.view.frame.size.width, self.view.frame.size.height);
    }
    else if ([PPUtilts isiPhone6]){
        self.homeTableView.frame=CGRectMake(0, 190, self.view.frame.size.width, self.view.frame.size.height);
    }
    else if ([PPUtilts isiPhone6Plus]){
        self.homeTableView.frame=CGRectMake(0, 260, self.view.frame.size.width, self.view.frame.size.height);
    }
    else{
        self.homeTableView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.textColor=[UIColor blackColor];
    [cell.imageView setImage:[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]]];
    cell.textLabel.text = [cellTitleText objectAtIndex:indexPath.row];

    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    else{
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.row==5) {
            cell.textLabel.numberOfLines=0;
            NSString *str = [NSString stringWithFormat:@"%@\n\n\n\n",[cellTitleText objectAtIndex:indexPath.row]];
            cell.textLabel.text=str;
        }
        else if (indexPath.row==4){
            if ([status.Error isEqualToString:kResultError]) {
                if ([status.Message isEqualToString:kResultMessage]) {
                    notificationCount=notificationCountModel.NotificatioTotal[[ZERO integerValue]];
                    [[NSUserDefaults standardUserDefaults] setValue:notificationCount.totalnotification forKey:@"NOTIFICATION"];
                    if ([notificationCount.totalnotification integerValue]>0) {
                        badge = [CustomBadge customBadgeWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"NOTIFICATION"] withStyle:[BadgeStyle oldStyle]];
                        badge.frame=CGRectMake(60, -4, 30, 30);
                        [badge bringSubviewToFront:cell.contentView];
                        [cell.contentView  addSubview:badge];
                }
                    else{
                        [badge removeFromSuperview];
                    }
            }
            
        }
            
    }
}

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row==0)?kCellHeightAtIndexZero:(indexPath.row==5)?kCellHeightAtIndexfive:kCellHeight;
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
- (IBAction)btnCancel:(id)sender {
    NotificationViewController *objNotification = [NotificationViewController new];
    [self.navigationController pushViewController:objNotification animated:YES];
}
@end
