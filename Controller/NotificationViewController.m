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

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize notificationTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingBarButton];
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CustomCellReuseID";
    NotificationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NotificationViewCell" owner:self options:nil]lastObject];
    }
    
    cell.lblNotificationDescription.text=@"nlmsndfl;sdnflk;jsdhknsdALCJDOSW;FHIadjklFNSLKASDFNlkAJSDFHA;Lndflk;asFHL;Andlj;aSDHL;ANSdlh;dna'LFH;AKSLfhl;sdfJKG";
//    cell.lblHeading.text=[[[self.allData  valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"headline"] objectAtIndex:indexPath.row];
//    cell.lblTag.text=[[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"tag"] objectAtIndex:indexPath.row];
//    
//    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
//    UIView *cellBackgroundClearColor = [[UIView alloc] initWithFrame:cell.frame];
//    cellBackgroundClearColor.backgroundColor = [UIColor clearColor];
//    cell.selectedBackgroundView = cellBackgroundClearColor;
//    
//    BOOL isHot=[[[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"is_hot"] objectAtIndex:indexPath.row] isEqualToString:@"No"]?NO:YES;

    
//    
//    NSString *strColorType=[[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"color_code"] objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ExpendableTableViewController *obj=[ExpendableTableViewController new];
//    [PPUtilts sharedInstance].colorCode=[[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"color_code"] objectAtIndex:indexPath.row];
//    [PPUtilts sharedInstance].LatestIDId=[[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"id"] objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:obj animated:YES];
}


- (void)settingBarButton{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CANCEL_BUTTON_FRAME];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateSelected];
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
