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



@interface ExpendableTableViewController (){
    //--------Models---------
    StatusModel  *statusModel;
    ExpenModel   *ibModel;
    
    IBModelDetails* ibModelDetails;
    StatusModelDetails* status;
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
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)getLatestIdeaBrief{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = PLEASE_WAIT;
    
    NSDictionary *parameters = @{kApiCall:kApiCallDetail,kid:[PPUtilts sharedInstance].LatestIDId,kColorCode:[PPUtilts sharedInstance].colorCode};
    AFNInjector *objAFN = [AFNInjector new];
    [objAFN parameters:parameters completionBlock:^(id data, NSError *error) {
        ibModel = [[ExpenModel alloc] initWithDictionary:data error:nil];
        statusModel = [[StatusModel alloc] initWithDictionary:data error:nil];
        status = statusModel.StatusArr[0];
        if(!error) {
            if ([status.Error isEqualToString:kResultError]) {
                [self.table reloadData];
                [self.table setHidden:NO];
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
    return ibModel.Detail.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isexpanded
{
    NSString *imageName=ibModelDetails.image;

    if (indexPath.row==0){
        if ([self isImageExist:imageName]) {return 700;}
        else{return 600;}
    }
    if (isexpanded){return 600;}
    else{return 175;}
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded
{
    NSString *CellIdentifier = kStaticIdentifier;
    LatestIBCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setTag:3];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:kStaticIdentifier owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ibModelDetails = ibModel.Detail[indexPath.row];
    
    cell.lblHeading.text=ibModelDetails.headline;
    cell.lblTag.text=ibModelDetails.user_email;
    cell.lblDescription.text=ibModelDetails.description_idea_brief;
    
    NSString *imageName=ibModelDetails.image;

    
    if ([self isImageExist:imageName]) {
        cell.lblDescription.frame=CGRectMake(40,410, 230,162);
        [cell.imgMain sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL_IMAGE,imageName]]
                     placeholderImage:nil
                              options:SDWebImageProgressiveDownload
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                if (image) {
                                    cell.imgMain.image = image;
                    }
            }];
    }
    
    
    BOOL isHot=[ibModelDetails.is_hot isEqualToString:@"No"]?NO:YES;

    
    UIImageView *imgIdea=(UIImageView *) [cell.contentView viewWithTag:PP101];
    UIImageView *imgBrief=(UIImageView *)[cell.contentView viewWithTag:PP102];
    UIImageView *imgHot=(UIImageView *)  [cell.contentView viewWithTag:PP103];
    
    if (isHot) {
        imgHot.hidden =NO;
    }
    
    NSString *strColorType=ibModelDetails.color_code;
    
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

-(BOOL)isImageExist:(NSString*)path{return (![[path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0);}

@end
