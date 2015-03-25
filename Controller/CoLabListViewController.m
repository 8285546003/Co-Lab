//
//  CoLabListViewController.m
//  Co\Lab 
//
//  Created by magnon on 26/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "CoLabListViewController.h"
#import "UIColor+PPColor.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "PPUtilts.h"
#import "LatestIBCell.h"
#import "ExpendableTableViewController.h"
#import "CreateIdea_BriefViewController.h"
#import "StatusModel.h"
#import "StatusModelDetails.h"
#import "IBModel.h"
#import "IBModelDetails.h"
#import "TagSearchModel.h"
#import "MyIdeaModel.h"
#import "MyBriefModel.h"
#import "AFNInjector.h"

@interface CoLabListViewController (){
    
    //------------Models-----------------
    StatusModel    *statusModel;
    IBModel        *ibModel;
    TagSearchModel *tagModel;
    MyIdeaModel    *myIdeaModel;
    MyBriefModel   *myBriefModel;
    
    IBModelDetails* ibModelDetails;
    StatusModelDetails* status;
    
    BOOL isHot;
    NSString *strColorType;
    
    NSDictionary *parameters;
    
}
@end

@implementation CoLabListViewController
@synthesize attachmentImage,allDataTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    isAttachment = NO;
    self.attachmentImage = [[UIImageView alloc] initWithFrame:ATTACHED_IMAGE_FRAME];
    [self callWebServices];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.view setBackgroundColor:[UIColor PPBackGroundColor]];
    [super viewWillAppear:YES];
}
//-----------------------------------Get Parameters for the respective web services-------------------------------------------------------
-(NSDictionary*)getParameters{
 return  ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief)?(parameters = @{kApiCall:kApiCallLatestIdeaBrief}):([PPUtilts sharedInstance].apiCall==kApiCallMyIdea)?(parameters = @{kApiCall:kApiCallMyIdea,kUserid:GET_USERID}):([PPUtilts sharedInstance].apiCall==kApiCallMyBrief)?(parameters = @{kApiCall:kApiCallMyBrief,kUserid:GET_USERID}):(parameters = @{kApiCall:kApiCallTagSearch,kTag:[PPUtilts sharedInstance].tagSearch});
}

//------------------------------------Set data to models-----------------------------------------------------------------------------------
-(void)setModels:(id)responseObject{
    ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief)?(ibModel = [[IBModel alloc] initWithDictionary:responseObject error:nil]):([PPUtilts sharedInstance].apiCall==kApiCallMyIdea)?(myIdeaModel = [[MyIdeaModel alloc] initWithDictionary:responseObject error:nil]):([PPUtilts sharedInstance].apiCall==kApiCallMyBrief)?(myBriefModel = [[MyBriefModel alloc] initWithDictionary:responseObject error:nil]):(tagModel = [[TagSearchModel alloc] initWithDictionary:responseObject error:nil]);
    
    statusModel = [[StatusModel alloc] initWithDictionary:responseObject error:nil];
    status = statusModel.StatusArr[[ZERO integerValue]];
}
-(void)callWebServices{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = PLEASE_WAIT;
    parameters=[self getParameters];
    AFNInjector *objAFN = [AFNInjector new];
    [objAFN parameters:parameters completionBlock:^(NSArray *data, NSError *error) {
        if(!error) {
            [self setModels:data];
            if ([status.Error isEqualToString:kResultError]) {
                if ([status.Message isEqualToString:kResultMessage]) {
                    [allDataTableView setHidden:NO];
                    [allDataTableView reloadData];
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
        } else {
            [self settingBarButton];
            [hud hide:YES];
        }
    }];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 return  ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief)?ibModel.LatestIdeaBrief.count:([PPUtilts sharedInstance].apiCall==kApiCallMyIdea)?myIdeaModel.MyIdea.count:([PPUtilts sharedInstance].apiCall==kApiCallMyBrief)?myBriefModel.MyBrief.count:tagModel.TagSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSString *CellIdentifier = kStaticIdentifier;
    LatestIBCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:kStaticIdentifier owner:self options:nil]lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief)?(ibModelDetails = ibModel.LatestIdeaBrief[indexPath.row]):([PPUtilts sharedInstance].apiCall==kApiCallMyIdea)?(ibModelDetails = myIdeaModel.MyIdea[indexPath.row]):([PPUtilts sharedInstance].apiCall==kApiCallMyBrief)?(ibModelDetails = myBriefModel.MyBrief[indexPath.row]):(ibModelDetails = tagModel.TagSearch[indexPath.row]);

    cell.lblHeading.text=ibModelDetails.headline;
    cell.lblHeading.numberOfLines=5;
    cell.lblHeading.lineBreakMode=NSLineBreakByCharWrapping;
    [cell.lblHeading sizeToFit];
    cell.lblTag.text=ibModelDetails.tag;
    isHot=[ibModelDetails.is_hot isEqualToString:BOOL_YES];
    strColorType=ibModelDetails.color_code;
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    UIView *cellBackgroundClearColor = [[UIView alloc] initWithFrame:cell.frame];
    cellBackgroundClearColor.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = cellBackgroundClearColor;
    
    UIImageView *imgIdea=(UIImageView *)[cell.contentView viewWithTag:PP101];
    UIImageView *imgBrief=(UIImageView *)[cell.contentView viewWithTag:PP102];
    UIImageView *imgHot=(UIImageView *)[cell.contentView viewWithTag:PP103];
    
    typedef void (^CaseBlockForColor)();
    NSDictionary *colorType = @{
                                
                                R:
                                    ^{[cell setBackgroundColor:[UIColor    PPRedColor]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kheightForRowAtIndexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExpendableTableViewController *obj=[ExpendableTableViewController new];
    
    ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief)?(ibModelDetails = ibModel.LatestIdeaBrief[indexPath.row]):([PPUtilts sharedInstance].apiCall==kApiCallMyIdea)?(ibModelDetails = myIdeaModel.MyIdea[indexPath.row]):([PPUtilts sharedInstance].apiCall==kApiCallMyBrief)?(ibModelDetails = myBriefModel.MyBrief[indexPath.row]):(ibModelDetails = tagModel.TagSearch[indexPath.row]);
    
    [PPUtilts sharedInstance].colorCode=ibModelDetails.color_code;
    [PPUtilts sharedInstance].LatestIDId=ibModelDetails.id;
    [self.navigationController pushViewController:obj animated:YES];
}

//-----------------------------------BUTTON NAVIGATION BUTTONS---------------------------------------------------

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
    tmpOverlayObj = [[OverlayView alloc] initOverlayView];
    [tmpOverlayObj setDelegate:self];
    [self.view addSubview:tmpOverlayObj];
    [tmpOverlayObj createOrAnswerIB:NO];
}
- (void)createIdea{
    CreateIdea_BriefViewController *objCreateIdea = [CreateIdea_BriefViewController new];
    [objCreateIdea setIsIdeaSubmitScreen:YES];
    [objCreateIdea setIsCurrentControllerPresented:YES];
    [tmpOverlayObj closeIBView:nil];
    [self presentViewController:objCreateIdea animated:YES completion:nil];
}
- (void)createBrief{
    CreateIdea_BriefViewController *objCreateIdea = [CreateIdea_BriefViewController new];
    [objCreateIdea setIsIdeaSubmitScreen:NO];
    [objCreateIdea setIsCurrentControllerPresented:YES];
    [tmpOverlayObj closeIBView:nil];
    [self presentViewController:objCreateIdea animated:YES completion:nil];
}

@end
