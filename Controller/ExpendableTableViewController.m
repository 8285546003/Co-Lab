//
//  ExpendableTableViewController.m
//  Co\Lab 
//
//  Created by magnon on 25/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//




#import "ExpendableTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "PPUtilts.h"
#import "AFNetworking.h"
#import "LatestIBCell.h"
#import "UIColor+PPColor.h"
#import "StatusModel.h"
#import "ExpenModel.h"
#import "AFNInjector.h"
#import "CreateIdea_BriefViewController.h"
#import "NotificatioDetail.h"



@interface ExpendableTableViewController (){
    //--------Models---------
    StatusModel  *statusModel;
    ExpenModel   *ibModel;
    NotificatioDetail *notificationModel;
    
    IBModelDetails* ibModelDetails;
    StatusModelDetails* status;
    BOOL isAnswerTheBriefs;
}

@end
@implementation ExpendableTableViewController

@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLatestIdeaBrief];
    self.table.HVTableViewDataSource = self;
    self.table.HVTableViewDelegate = self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.view setBackgroundColor:[UIColor PPBackGroundColor]];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)getLatestIdeaBrief{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = PLEASE_WAIT;
    
    NSDictionary *parameters;
    
    if ([PPUtilts sharedInstance].apiCall==kApiCallNotifications) {
               parameters = @{kApiCall:@"NotificationDetail",kUserid:GET_USERID,@"n_parent_id":[PPUtilts sharedInstance].parent_id,@"n_notification_send_time":[PPUtilts sharedInstance].notification_send_time};
    }
    else{
        parameters = @{kApiCall:kApiCallDetail,kid:[PPUtilts sharedInstance].LatestIDId,kColorCode:[PPUtilts sharedInstance].colorCode};

    }
    
    
    AFNInjector *objAFN = [AFNInjector new];
    [objAFN parameters:parameters completionBlock:^(id data, NSError *error) {
        if ([PPUtilts sharedInstance].apiCall==kApiCallNotifications) {
            notificationModel = [[NotificatioDetail alloc] initWithDictionary:data error:nil];
        }
        else{
            ibModel = [[ExpenModel alloc] initWithDictionary:data error:nil];

        }
        statusModel = [[StatusModel alloc] initWithDictionary:data error:nil];
        status = statusModel.StatusArr[[ZERO integerValue]];
        if(!error) {
            if ([status.Error isEqualToString:kResultError]) {
                if ([status.Message isEqualToString:kResultMessage]) {
                    [self.table reloadData];
                    [self.table setHidden:NO];
                }
                else{
                    kCustomAlert(@"", status.Message, @"Ok");
                }
            }
            else{
                kCustomErrorAlert;
            }
            [self settingBarButton];
            [hud hide:YES];
            NSLog(@"%@",data);
        } else {
            [self settingBarButton];
            [hud hide:YES];
            if (PPNoInternetConnection) {
                kCustomErrorAlert;
            }
            NSLog(@"error %@", error);
        }
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

- (void)settingBarButton{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CANCEL_BUTTON_FRAME];
    if ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief) {
        [cancelButton setImage:[UIImage imageNamed:BACK_BUTTON_NAME] forState:UIControlStateNormal];
        [cancelButton setImage:[UIImage imageNamed:BACK_BUTTON_NAME] forState:UIControlStateSelected];
    }
    else{
        [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateNormal];
        [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateSelected];
    }
    [cancelButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = PPkCancel;
    [self.view addSubview:cancelButton];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setFrame:ADD_BUTTON_FRAME];
    [addButton setImage:[UIImage imageNamed:ADD_BUTTON_NAME] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:ADD_BUTTON_NAME] forState:UIControlStateSelected];
    [addButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    addButton.tag = PPkAddOrNext;
    [self.view addSubview:addButton];
}
- (void)settingBarMethod:(UIButton *)settingBtn{
    switch (settingBtn.tag) {
        case PPkCancel:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case PPkAttachment:
            break;
        case PPkAddOrNext:[self addOverLay];
            break;
        default:
            break;
    }
}
//-----------------------------------------OVERLAY---------------------------------------------

-(void)addOverLay{
    _tmpOverlayObj = [[OverlayView alloc] initOverlayView];
    [_tmpOverlayObj setDelegate:self];
    [self.view addSubview:_tmpOverlayObj];
    [_tmpOverlayObj createOrAnswerIB:isAnswerTheBriefs];
}
- (void)createIdea{
    CreateIdea_BriefViewController *objCreateIdea = [CreateIdea_BriefViewController new];
    [objCreateIdea setIsIdeaSubmitScreen:YES];
    [objCreateIdea setIsCurrentControllerPresented:YES];
    [objCreateIdea setIsAnswerTheBriefs:NO];
    [_tmpOverlayObj closeIBView:nil];
    [self presentViewController:objCreateIdea animated:YES completion:nil];
}
- (void)createBrief{
    CreateIdea_BriefViewController *objCreateIdea = [CreateIdea_BriefViewController new];
    [objCreateIdea setIsIdeaSubmitScreen:NO];
    [objCreateIdea setIsCurrentControllerPresented:YES];
    [_tmpOverlayObj closeIBView:nil];
    [self presentViewController:objCreateIdea animated:YES completion:nil];
}
- (void)answerIB{
    CreateIdea_BriefViewController *objCreateIdea = [CreateIdea_BriefViewController new];
    [objCreateIdea setIsIdeaSubmitScreen:YES];
    [objCreateIdea setIsCurrentControllerPresented:YES];
    [objCreateIdea setIsAnswerTheBriefs:YES];
    [_tmpOverlayObj closeIBView:nil];
    [self presentViewController:objCreateIdea animated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView expandCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{

}
-(void)tableView:(UITableView *)tableView collapseCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([PPUtilts sharedInstance].apiCall==kApiCallNotifications) {
        return notificationModel.NotificatioDetail.count;
    }
  else{
      return ibModel.Detail.count;

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isexpanded
{
    NSString *imageName=ibModelDetails.image;

    if (indexPath.row==[ZERO intValue]){
        if ([self isImageExist:imageName]) {return kCellHeightWithImage;}
        else{return kCellHeightWithoutImage;}
    }
    if (isexpanded){return kCellHeightWithoutImage;}
    else{return kCellHeightNormal;}
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded
{
    NSString *CellIdentifier = kStaticIdentifier;
    LatestIBCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setTag:3];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:kStaticIdentifier owner:self options:nil]lastObject];
        [cell.btnEmail setHidden:NO];
        [cell.btnEmail addTarget:self action:@selector(buttonPressedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
       if ([PPUtilts sharedInstance].apiCall==kApiCallNotifications) {
           ibModelDetails= notificationModel.NotificatioDetail[indexPath.row];
     }
     else{
         ibModelDetails = ibModel.Detail[indexPath.row];

     }
    cell.lblHeading.text=ibModelDetails.headline;
    cell.lblTag.text=ibModelDetails.user_email;
    cell.lblDescription.text=ibModelDetails.description_idea_brief;
    
    NSString *imageName=ibModelDetails.image;

    
    if ([self isImageExist:imageName]) {
        cell.lblDescription.frame=DETAIL_LABLE_FRAME;
        [cell.imgMain sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL_IMAGE,imageName]]
                     placeholderImage:nil
                              options:SDWebImageProgressiveDownload
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                if (image) {
                                    cell.imgMain.image = image;
                    }
            }];
    }
    
    
    BOOL isHot=[ibModelDetails.is_hot isEqualToString:BOOL_YES];

    UIImageView *imgIdea=(UIImageView *) [cell.contentView viewWithTag:PP101];
    UIImageView *imgBrief=(UIImageView *)[cell.contentView viewWithTag:PP102];
    UIImageView *imgHot=(UIImageView *)  [cell.contentView viewWithTag:PP103];
    
    if (isHot) {
        imgHot.hidden =NO;
    }
    
    NSString *strColorType=ibModelDetails.color_code;
    isAnswerTheBriefs=YES;
    
    typedef void (^CaseBlockForColor)();
    NSDictionary *colorType = @{
                                R:
                                    ^{[cell setBackgroundColor:[UIColor    PPRedColor]];
                                        isAnswerTheBriefs=NO;
                                        imgIdea.hidden=NO;
                                        if (isHot) {imgHot.hidden =NO;imgIdea.frame=imgBrief.frame;}
                                        else{imgIdea.frame=imgHot.frame;}
                                    },
                                Y:
                                    ^{[cell setBackgroundColor:[UIColor    PPYellowColor]];
                                        imgIdea.hidden=NO;
                                        imgBrief.hidden=NO;
                                        if (isHot){imgHot.hidden =NO;}
                                        else{imgIdea.frame=imgBrief.frame;imgBrief.frame=imgHot.frame;}
                                        
                                    },
                                G:
                                    ^{ [cell setBackgroundColor:[UIColor    PPGreenColor]];
                                        imgIdea.hidden=NO;
                                        imgBrief.hidden=NO;
                                        if (isHot) {imgHot.hidden =NO;}
                                        else{imgIdea.frame=imgBrief.frame;imgBrief.frame=imgHot.frame;}
                                    },
                                B:
                                    ^{ [cell setBackgroundColor:[UIColor    PPBlueColor]];
                                        imgBrief.hidden=NO;
                                        if (isHot) {imgHot.hidden =NO;}
                                        else{imgBrief.frame=imgHot.frame;}
                                    }
                                };
    
    ((CaseBlockForColor)colorType[strColorType])(); // invoke the correct block of code
    
    return cell;
}
- (void)buttonPressedAction:(id)sender
{
    CGPoint buttonOriginInTableView = [sender convertPoint:CGPointZero toView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonOriginInTableView];
    
    if ([PPUtilts sharedInstance].apiCall==kApiCallNotifications) {
        ibModelDetails= notificationModel.NotificatioDetail[indexPath.row];
    }
    else{
        ibModelDetails = ibModel.Detail[indexPath.row];

    }
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        //[mail setSubject:@"Sample Subject"];
        //[mail setMessageBody:@"Here is some main text in the email!" isHTML:NO];
       // NSArray *usersTo = [NSArray arrayWithObject: @"nobody@stackoverflow.com"];
       // [mail setToRecipients:usersTo];
        [mail setToRecipients:@[ibModelDetails.user_email]];
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(BOOL)isImageExist:(NSString*)path{return (![[path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0);}

@end
