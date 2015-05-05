//
//  NotificationViewController.m
//  Co\Lab 
//
//  Created by magnon on 03/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationViewCell.h"
#import "PPUtilts.h"
#import "UIColor+PPColor.h"
#import "ExpendableTableViewController.h"
#import "PPUtilts.h"
#import "UIColor+PPColor.h"
#import "MBProgressHUD.h"
#import "AFNInjector.h"
#import "NotificatioListModelDetails.h"
#import "StatusModelDetails.h"
#import "StatusModel.h"
#import "NotificatioListModel.h"
#import "CustomBadge.h"
#import "NotificationCount.h"
#import "NotificationCountModel.h"

@interface NotificationViewController (){
    StatusModel    *statusModel;
    NotificatioListModel*notificationModel;
    
    NotificatioListModelDetails* ibModelDetails;
    StatusModelDetails* status;
    
    NotificationCount  *notificationCount;
    NotificationCountModel*notificationCountModel;
    
    CustomBadge *badge;
    
}
@property (nonatomic, strong) IBOutlet UIButton *imgIcon;

@end

@implementation NotificationViewController
@synthesize notificationTableView;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]) {
        [_imgIcon setBackgroundImage:[UIImage imageNamed:@"notification6"] forState:UIControlStateNormal];
        [_imgIcon setFrame:CGRectMake(20, 20, 52, 52)];
    }
}

// Do any additional setup after loading the view from its nib.
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [self callWebServices];
    [self settingBarButton];
    [self.view setBackgroundColor:[UIColor PPBackGroundColor]];

}
-(void)callWebServices{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = PLEASE_WAIT;
    NSDictionary *parameters= @{kApiCall:kApiCallNotifications,kUserid:GET_USERID};
    AFNInjector *objAFN = [AFNInjector new];
    [objAFN parameters:parameters completionBlock:^(id data, NSError *error) {
        if(!error) {
            notificationModel = [[NotificatioListModel alloc] initWithDictionary:data error:nil];
            statusModel = [[StatusModel alloc] initWithDictionary:data error:nil];
            status = statusModel.StatusArr[[ZERO integerValue]];
            
            notificationCountModel= [[NotificationCountModel alloc] initWithDictionary:data error:nil];
            if (notificationCountModel.NotificatioTotal.count>0) {
                notificationCount=notificationCountModel.NotificatioTotal[[ZERO integerValue]];
            }
            if ([status.Error isEqualToString:kResultError]) {
                if ([status.Message isEqualToString:kResultMessage]) {
                    if (![notificationCount.totalnotification integerValue] ==0) {
                        [[NSUserDefaults standardUserDefaults] setValue:notificationCount.totalnotification forKey:@"NOTIFICATION"];
                        badge = [CustomBadge customBadgeWithString:notificationCount.totalnotification withStyle:[BadgeStyle oldStyle]];
                        if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]) {
                            badge.frame=CGRectMake(55, 5, 30, 30);

                        }
                        else{
                            badge.frame=CGRectMake(45, 0, 30, 30);

                        }
                        [self.view addSubview:badge];
                    }
                    else{
                        [[NSUserDefaults standardUserDefaults] setValue:ZERO forKey:@"NOTIFICATION"];
                        [badge removeFromSuperview];
                    }
                    [self.notificationTableView  setHidden:NO];
                    [self.notificationTableView reloadData];
                }
                else{
                    kCustomAlert(@"", status.Message, @"OK");
                }
            }
            else{
                kCustomAlert(@"", status.Message, @"OK");
            }
            [self settingBarButton];
            [hud hide:YES];
        } else {
            [self settingBarButton];
            [hud hide:YES];
        }
    }];
    
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return notificationModel.NotificatioList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CustomCellReuseID";
    NotificationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NotificationViewCell" owner:self options:nil]lastObject];
    }
    
    ibModelDetails = notificationModel.NotificatioList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:ibModelDetails.msg];
    NSRange selectedRange = NSMakeRange(9, 1); // 4 characters, starting at index 22
    
     NSRange selectedRange1 = NSMakeRange(38, string.length-61); // 4 characters, starting at index 22
    
    [string beginEditing];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]
                   range:selectedRange];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]
                   range:selectedRange1];
    
    [string endEditing];;
    
    cell.lblNotificationDescription.attributedText=string;
    cell.lblTime.text=ibModelDetails.send_time;
    
    BOOL isMessageRead=[ibModelDetails.read_status isEqualToString:BOOL_YES];
    if (isMessageRead) {
        cell.contentView.alpha=0.3;
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     ibModelDetails = notificationModel.NotificatioList[indexPath.row];
    [PPUtilts sharedInstance].UniversalApi=[PPUtilts sharedInstance].apiCall;
    [PPUtilts sharedInstance].apiCall=kApiCallNotifications;
    [PPUtilts sharedInstance].parent_id=ibModelDetails.n_parent_id;
    [PPUtilts sharedInstance].notification_send_time=ibModelDetails.n_notification_send_time;
     ExpendableTableViewController *objLatestIB = [ExpendableTableViewController new];
    [self.navigationController pushViewController:objLatestIB animated:YES];
}


- (void)settingBarButton{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]) {
        [cancelButton setFrame:CANCEL_BUTTON_FRAME6];
        [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME6] forState:UIControlStateNormal];
        [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME6] forState:UIControlStateSelected];
    }
    else{
        [cancelButton setFrame:CANCEL_BUTTON_FRAME];
        [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateNormal];
        [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateSelected];
        
    }
    

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
@end
