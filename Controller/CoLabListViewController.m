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
    
    NSString *isHot;
    NSString *strColorType;
    
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
    [super viewWillAppear:YES];
}
//----------------------------------------------Get Parameters for the respective web services-------------------------------------------------------
-(NSDictionary*)getParameters{
    NSDictionary *parameters;
    if (![PPUtilts sharedInstance].userID) {[PPUtilts sharedInstance].userID=GET_USERID;}
    if ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief) {parameters = @{kApiCall:kApiCallLatestIdeaBrief};}
    else if ([PPUtilts sharedInstance].apiCall==kApiCallTagSearch){parameters = @{kApiCall:kApiCallTagSearch,kTag:[PPUtilts sharedInstance].tagSearch};}
    else if ([PPUtilts sharedInstance].apiCall==kApiCallMyIdea){parameters = @{kApiCall:kApiCallMyIdea,kUserid:[PPUtilts sharedInstance].userID};}
    else if ([PPUtilts sharedInstance].apiCall==kApiCallMyBrief){parameters = @{kApiCall:kApiCallMyBrief,kUserid:[PPUtilts sharedInstance].userID};}
    else{}
    return parameters;
}

//----------------------------------------------Set data to models-----------------------------------------------------------------------------------
-(void)setModels:(id)responseObject{
    if ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief) {ibModel = [[IBModel alloc] initWithDictionary:responseObject error:nil];}
    else if ([PPUtilts sharedInstance].apiCall==kApiCallMyIdea){myIdeaModel = [[MyIdeaModel alloc] initWithDictionary:responseObject error:nil];}
    else if ([PPUtilts sharedInstance].apiCall==kApiCallMyBrief){myBriefModel = [[MyBriefModel alloc] initWithDictionary:responseObject error:nil];}
    else{tagModel = [[TagSearchModel alloc] initWithDictionary:responseObject error:nil];}
    statusModel = [[StatusModel alloc] initWithDictionary:responseObject error:nil];
    status = statusModel.StatusArr[0];
}
-(void)callWebServices{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = PLEASE_WAIT;
    NSDictionary *parameters=[self getParameters];
    AFNInjector *objAFN = [AFNInjector new];
    [objAFN parameters:parameters completionBlock:^(NSArray *data, NSError *error) {
        if(!error) {
            [self setModels:data];
            if ([status.Error isEqualToString:kResultError]) {
                [allDataTableView setHidden:NO];
                [allDataTableView reloadData];
            }
            else{
                kCustomErrorAlert;
            }
            [self settingBarButton];
            [hud hide:YES];
            NSLog(@"%@",data);
        } else {
            [self settingBarButton];
            if (PPNoInternetConnection) {
                kCustomErrorAlert;
            }
            [hud hide:YES];

            NSLog(@"error %@", error);
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
    if ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief){return ibModel.LatestIdeaBrief.count;}
    else if ([PPUtilts sharedInstance].apiCall==kApiCallMyIdea){return myIdeaModel.MyIdea.count;}
    else if ([PPUtilts sharedInstance].apiCall==kApiCallMyBrief){return myBriefModel.MyBrief.count;}
    else{return tagModel.TagSearch.count;}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSString *CellIdentifier = kStaticIdentifier;
    LatestIBCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:kStaticIdentifier owner:self options:nil]lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief){ibModelDetails = ibModel.LatestIdeaBrief[indexPath.row];}
    else if ([PPUtilts sharedInstance].apiCall==kApiCallMyIdea){ibModelDetails = myIdeaModel.MyIdea[indexPath.row];}
    else if ([PPUtilts sharedInstance].apiCall==kApiCallMyBrief){ibModelDetails = myBriefModel.MyBrief[indexPath.row];}
    else{ibModelDetails = tagModel.TagSearch[indexPath.row];}
    
    cell.lblHeading.text=ibModelDetails.headline;
    cell.lblTag.text=ibModelDetails.tag;
    isHot=ibModelDetails.is_hot;
    strColorType=ibModelDetails.color_code;
    
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    UIView *cellBackgroundClearColor = [[UIView alloc] initWithFrame:cell.frame];
    cellBackgroundClearColor.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = cellBackgroundClearColor;
    UIImageView *imgIdea=(UIImageView *)[cell.contentView viewWithTag:101];
    UIImageView *imgBrief=(UIImageView *)[cell.contentView viewWithTag:102];
    UIImageView *imgHot=(UIImageView *)[cell.contentView viewWithTag:103];
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
    
    if ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief) {ibModelDetails = ibModel.LatestIdeaBrief[indexPath.row];}
    else if ([PPUtilts sharedInstance].apiCall==kApiCallMyIdea){ibModelDetails = myIdeaModel.MyIdea[indexPath.row];}
    else if ([PPUtilts sharedInstance].apiCall==kApiCallMyBrief){ibModelDetails = myBriefModel.MyBrief[indexPath.row];}
    else{ibModelDetails = tagModel.TagSearch[indexPath.row];}
    
    [PPUtilts sharedInstance].colorCode=ibModelDetails.color_code;
    [PPUtilts sharedInstance].LatestIDId=ibModelDetails.id;
    [self.navigationController pushViewController:obj animated:YES];
}

//-----------------------------------BUTTON NAVIGATION BUTTONS---------------------------------------------------

- (void)settingBarButton{
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CANCEL_BUTTON_FRAME];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateSelected];
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
