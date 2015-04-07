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
#import "MBProgressHUD.h"


@interface HomeViewController ()<MBProgressHUDDelegate>{
    NSArray *imageArray;
    NSArray *cellTitleText;
    __weak IBOutlet UIView *notificationView;
    
    StatusModel         *statusModel;
    StatusModelDetails  *status;
    
    NotificationCount  *notificationCount;
    NotificationCountModel*notificationCountModel;
    
        __weak IBOutlet UILabel       *lblNotificationCount;
    CustomBadge *badge;
    MBProgressHUD *HUD;
 
    
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

    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(btnSlideDown)];
    [_viewLIB addGestureRecognizer:gesture];
    
    imageArray=ImageArray ;
    cellTitleText = CellTitleText;
    
    
    self.homeTableView.delegate   = self;
    self.homeTableView.dataSource = self;

    
    // Do any additional setup after loading the view from its nib.
}
-(void)btnSlideDown{
   // _viewLIB.adjustsImageWhenHighlighted = YES;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = .3;
    // animation.repeatCount = 5;
    animation.fromValue = [NSValue valueWithCGPoint:_viewLIB.center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(_viewLIB.center.x, _viewLIB.center.y+40)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    [_viewLIB.layer addAnimation:animation forKey:@"position"];
   
   // [self performSelector:@selector(goToLatestIdeaBriefs) withObject:nil afterDelay:0.2];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //[object method];
         [self goToLatestIdeaBriefs];
    });
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.homeTableView setContentOffset:self.homeTableView.contentOffset animated:NO];
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
    //[self.homeTableView setBackgroundColor:[UIColor redColor]];
    [self.view setBackgroundColor:[UIColor PPBackGroundColor]];
    [self updateFrame];
}
-(void)updateFrame{
    _viewLIB.frame=CGRectMake(25, self.view.frame.size.height-77, 320, 103);
   // _btnLIB.frame=CGRectMake(15, self.view.frame.size.height-103, 60, 103);
    if ([PPUtilts isIPad]) {
        self.homeTableView.frame=CGRectMake(0, 540, self.view.frame.size.width, self.view.frame.size.height);
    }
    else{
    if ([PPUtilts isiPhone5]) {
        self.homeTableView.frame=CGRectMake(10, 220, self.view.frame.size.width, self.view.frame.size.height);
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
    [cell.contentView setBackgroundColor:[UIColor PPBackGroundColor]];
    [cell.imageView setImage:[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]]];
    cell.textLabel.text = [cellTitleText objectAtIndex:indexPath.row];

    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    }
    else{
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
           if (indexPath.row==4){
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
//-(void)handleSwipe:(UISwipeGestureRecognizer *) sender
//{
//    [self goToLatestIdeaBriefs];
////    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
////    {
////        //do something
////    }
////    else //if (sender.direction == UISwipeGestureRecognizerDirectionRight)
////    {
////        //do something
////    }
//}
- (void)showToast{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_ideas.png"]];
    HUD.delegate = self;
    HUD.labelText = @"Please Swipe";
    HUD.detailsLabelText=@"to get latest Idea/Brief";
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:3];
}
#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
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
        case PPkLatestIdeasBrifes://[self goToLatestIdeaBriefs];
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
   // objLatestIB.view.layer.speed = 0.8;
    [objLatestIB setIsCurrentControllerPresented:YES];
    UINavigationController *navC=[[UINavigationController alloc]initWithRootViewController:objLatestIB];
    [self presentViewController:navC animated:YES completion:^{}];
    //[self presentViewController:objLatestIB animated:YES completion:nil];
}
- (IBAction)btnCancel:(id)sender {
    NotificationViewController *objNotification = [NotificationViewController new];
    [self.navigationController pushViewController:objNotification animated:YES];
}
@end
