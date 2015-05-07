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

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CTStringAttributes.h>
#import <CoreText/CoreText.h>



@interface ExpendableTableViewController (){
    //--------Models---------
    StatusModel  *statusModel;
    ExpenModel   *ibModel;
    NotificatioDetail *notificationModel;
    
    IBModelDetails* ibModelDetails;
    StatusModelDetails* status;
    BOOL isAnswerTheBriefs;
    UILabel *heightHeading;
    UILabel *heightDescription;
    UIImageView *heightImageView;
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
    self.table.frame=CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height);
    [self.table reloadData];
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:YES];
    [self.view setBackgroundColor:[UIColor PPBackGroundColor]];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidAppear:(BOOL)animated{
    
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

- (void)settingBarButton{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]) {
            [cancelButton setFrame:CANCEL_BUTTON_FRAME6];

            [cancelButton setImage:[UIImage imageNamed:BACK_BUTTON_NAME6] forState:UIControlStateNormal];
            [cancelButton setImage:[UIImage imageNamed:BACK_BUTTON_NAME6] forState:UIControlStateSelected];
        }
        
        else{
            [cancelButton setFrame:CANCEL_BUTTON_FRAME];

            [cancelButton setImage:[UIImage imageNamed:BACK_BUTTON_NAME] forState:UIControlStateNormal];
            [cancelButton setImage:[UIImage imageNamed:BACK_BUTTON_NAME] forState:UIControlStateSelected];
        }
    
    [cancelButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = PPkCancel;
    [self.view addSubview:cancelButton];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]) {
        [addButton setFrame:ADD_BUTTON_FRAME6];
        [addButton setImage:[UIImage imageNamed:ADD_BUTTON_NAME6] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:ADD_BUTTON_NAME6] forState:UIControlStateSelected];
    }
    
    else{
        [addButton setFrame:ADD_BUTTON_FRAME];
        [addButton setImage:[UIImage imageNamed:ADD_BUTTON_NAME] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:ADD_BUTTON_NAME] forState:UIControlStateSelected];
    }
    

    [addButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    addButton.tag = PPkAddOrNext;
    [self.view addSubview:addButton];
}
- (void)settingBarMethod:(UIButton *)settingBtn{
    switch (settingBtn.tag) {
        case PPkCancel://_isCurrentControllerPresented?[self dismissViewControllerAnimated:YES completion:^{}]:
            //[PPUtilts sharedInstance].apiCall=[self getApiCall:[PPUtilts sharedInstance].UniversalApi];
            [PPUtilts sharedInstance].apiCall=[PPUtilts sharedInstance].UniversalApi;

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
-(NSString*)getApiCall:(NSString*)Api{
    NSString *strApi;
    if (Api) {
        if ([Api isEqualToString:kApiCallDetail]) {
            strApi=kApiCallLatestIdeaBrief;
        }
        else if ([Api isEqualToString:kApiCallMyBrief]){
            strApi=kApiCallLatestIdeaBrief;

        }
    }
    return strApi;
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
   return ([PPUtilts sharedInstance].apiCall==kApiCallNotifications)?notificationModel.NotificatioDetail.count:ibModel.Detail.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isexpanded
{
    NSString *imageName=ibModelDetails.image;
    
    if (indexPath.row==[ZERO intValue]){
        if ([self isImageExist:imageName]) {
            return kCellHeightWithImage;

        }
        else{
            return kCellHeightWithoutImage;

        }
    }
    if (isexpanded){
        if ([self isImageExist:imageName]) {
            return kCellHeightWithImage;

        }
        else{
            return kCellHeightWithoutImage;

        }
    }
    else{

        if ([PPUtilts isiPhone6Plus]||[PPUtilts isiPhone6]) {
            return heightHeading.frame.size.height+50;

        }
        else{
            
            return heightHeading.frame.size.height+80;

        }
        

    }
}

- (NSMutableAttributedString *)plainStringToAttributedUnits:(NSString *)string;
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    UIFont *font = [UIFont systemFontOfSize:10.0f];
    UIFont *smallFont = [UIFont systemFontOfSize:9.0f];
    
    [attString beginEditing];
    [attString addAttribute:NSFontAttributeName value:(font) range:NSMakeRange(0, string.length - 2)];
    [attString addAttribute:NSFontAttributeName value:(smallFont) range:NSMakeRange(string.length - 1, 1)];
    [attString addAttribute:(NSString*)kCTSuperscriptAttributeName value:@"1" range:NSMakeRange(string.length - 1, 1)];
    [attString addAttribute:(NSString*)kCTForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length - 1)];
    [attString endEditing];
    return attString;
}
- (float)heightOfLabel:(NSString *)tString{
    
    NSString *trimmedString = [tString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    NSString *tmpString = trimmedString;
    CGSize constrainedSize = CGSizeMake(340, FLT_MAX);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"HelveticaNeue" size:40.0f], NSFontAttributeName,nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:tmpString attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return requiredHeight.size.height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded
{
    NSString *CellIdentifier = kStaticIdentifier;
    LatestIBCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setTag:3];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:kStaticIdentifier owner:self options:nil]lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.backgroundColor=[UIColor redColor];
    [cell.btnEmail setHidden:NO];
    [cell.btnEmail addTarget:self action:@selector(buttonPressedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    ([PPUtilts sharedInstance].apiCall==kApiCallNotifications)?(ibModelDetails= notificationModel.NotificatioDetail[indexPath.row]):(ibModelDetails = ibModel.Detail[indexPath.row]);

    if ([PPUtilts isiPhone6Plus]||[PPUtilts isiPhone6]) {
        
        NSString *labelText =ibModelDetails.headline;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineHeightMultiple:0.85f];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        cell.lblHeading.attributedText = attributedString ;
    }
    else{
        
          cell.lblHeading.text=ibModelDetails.headline;

    }
    
    NSString *imageName=ibModelDetails.image;
    
    [cell.lblTag setFont:[UIFont fontWithName:@"Helvetica Neue" size:9.0f]];
    
    NSString *str=@"ℊ+";
    
    cell.lblGPlus.attributedText = [self plainStringToAttributedUnits:str];
    
    cell.lblTag.text=[NSString stringWithFormat:@"%@",ibModelDetails.user_email];
    cell.lblTag.backgroundColor=[UIColor blackColor];
    cell.lblTag.textAlignment=NSTextAlignmentCenter;
    cell.lblTag.alpha=0.4f;
    cell.lblTag.textColor=[UIColor whiteColor];
    cell.lblDescription.text=ibModelDetails.description_idea_brief;
    [cell.lblDescription sizeToFit];
    
    
 

    if ([self isImageExist:imageName]) {
        if ([PPUtilts isiPhone6Plus]||[PPUtilts isiPhone6]) {
            cell.lblHeading.lineBreakMode=NSLineBreakByCharWrapping;
            [cell.lblHeading sizeToFit];
            float newHeight = [self heightOfLabel:ibModelDetails.headline];
            float newHeightDesc = [self heightOfLabel:ibModelDetails.description_idea_brief];
            CGRect newRect;
            
            CGRect frame = cell.imgMain.frame;
            frame.origin.y = cell.lblHeading.frame.size.height+50;
            cell.imgMain.frame = frame;
            
            if (newHeight<50) {
                
                CGRect frameHeading = cell.lblHeading.frame;
                frameHeading.origin.y = 60;
                cell.lblHeading.frame = frameHeading;
                
                CGRect frameImgMain = cell.imgMain.frame;
                frameImgMain.origin.y = cell.lblHeading.frame.size.height+75;
                cell.imgMain.frame = frameImgMain;
                
                
                CGRect frameDesc = cell.imgMain.frame;
                frameDesc.origin.y = cell.imgMain.frame.size.height+cell.lblHeading.frame.size.height+95;
                cell.lblDescription.frame = frameDesc;
                
                NSLog(@"=======height === %f \n ",newHeight);
                
            }
            
            else if(newHeight >240){
                
                CGRect frameHeading = cell.lblHeading.frame;
                frameHeading.origin.y = 40;
                cell.lblHeading.frame = frameHeading;
                
                CGRect frameImgMain = cell.imgMain.frame;
                frameImgMain.origin.y = cell.lblHeading.frame.size.height+20;
                cell.imgMain.frame = frameImgMain;
                
                
                CGRect frameDesc = cell.imgMain.frame;
                frameDesc.origin.y = cell.imgMain.frame.size.height+cell.lblHeading.frame.size.height+40;
                cell.lblDescription.frame = frameDesc;
                
                NSLog(@"=======height === %f \n ",newHeight);
                
            }
            else if(newHeight >185){
                newRect = CGRectMake(40, 40, self.view.frame.size.width-130, newHeight);
                [cell.lblHeading setFrame:newRect];
                
                [cell.lblDescription setFrame:CGRectMake(40, cell.lblHeading.frame.size.height+cell.imgMain.frame.size.height+90 , self.view.frame.size.width-130, newHeightDesc)];
                NSLog(@"=======height === %f \n ",newHeight);
                
            }
            
            else{
                
                CGRect frameHeading = cell.lblHeading.frame;
                frameHeading.origin.y = 60;
                cell.lblHeading.frame = frameHeading;
                
                CGRect frameImgMain = cell.imgMain.frame;
                frameImgMain.origin.y = cell.lblHeading.frame.size.height+65;
                cell.imgMain.frame = frameImgMain;
                
                
                CGRect frameDesc = cell.imgMain.frame;
                frameDesc.origin.y = cell.imgMain.frame.size.height+cell.lblHeading.frame.size.height+76;
                cell.lblDescription.frame = frameDesc;
                NSLog(@"=======height === %f \n ",newHeight);
                //83
                //125
                
            }

            
        }
        
            else{
        
        //All fames are with image in iPhone 5
        
                cell.lblHeading.lineBreakMode=NSLineBreakByCharWrapping;
                [cell.lblHeading sizeToFit];
                float newHeight = [self heightOfLabel:ibModelDetails.headline];
                
                CGRect frame = cell.imgMain.frame;
                frame.origin.y = cell.lblHeading.frame.size.height+50;
                cell.imgMain.frame = frame;
                
                if (newHeight<50) {
                    
                    CGRect frameHeading = cell.lblHeading.frame;
                    frameHeading.origin.y = 56;
                    cell.lblHeading.frame = frameHeading;
                    
                    CGRect frameImgMain = cell.imgMain.frame;
                    frameImgMain.origin.y = cell.lblHeading.frame.size.height+58;
                    cell.imgMain.frame = frameImgMain;
                    
                    
                    CGRect frameDesc = cell.imgMain.frame;
                    frameDesc.origin.y = cell.imgMain.frame.size.height+cell.lblHeading.frame.size.height+73;
                    cell.lblDescription.frame = frameDesc;
                    
                    
                    NSLog(@"=======height === %f \n ",newHeight);
                    
                }
                
                else if(newHeight >240){
                    CGRect frameHeading = cell.lblHeading.frame;
                    frameHeading.origin.y = 56;
                    cell.lblHeading.frame = frameHeading;
                    
                    CGRect frameImgMain = cell.imgMain.frame;
                    frameImgMain.origin.y = cell.lblHeading.frame.size.height+58;
                    cell.imgMain.frame = frameImgMain;
                    
                    
                    CGRect frameDesc = cell.imgMain.frame;
                    frameDesc.origin.y = cell.imgMain.frame.size.height+cell.lblHeading.frame.size.height+73;
                    cell.lblDescription.frame = frameDesc;
                    
                    
                    NSLog(@"=======height === %f \n ",newHeight);
                    
                }
                else if(newHeight >185){
                    CGRect frameHeading = cell.lblHeading.frame;
                    frameHeading.origin.y = 56;
                    cell.lblHeading.frame = frameHeading;
                    
                    CGRect frameImgMain = cell.imgMain.frame;
                    frameImgMain.origin.y = cell.lblHeading.frame.size.height+58;
                    cell.imgMain.frame = frameImgMain;
                    
                    
                    CGRect frameDesc = cell.imgMain.frame;
                    frameDesc.origin.y = cell.imgMain.frame.size.height+cell.lblHeading.frame.size.height+73;
                    cell.lblDescription.frame = frameDesc;
                    
                    
                    NSLog(@"=======height === %f \n ",newHeight);
                    
                }
                
                else{
                    
                    CGRect frameHeading = cell.lblHeading.frame;
                    frameHeading.origin.y = 56;
                    cell.lblHeading.frame = frameHeading;
                    
                    CGRect frameImgMain = cell.imgMain.frame;
                    frameImgMain.origin.y = cell.lblHeading.frame.size.height+58;
                    cell.imgMain.frame = frameImgMain;
                    
                    
                    CGRect frameDesc = cell.imgMain.frame;
                    frameDesc.origin.y = cell.imgMain.frame.size.height+cell.lblHeading.frame.size.height+73;
                    cell.lblDescription.frame = frameDesc;

                    
                    
                    NSLog(@"=======height === %f \n ",newHeight);
                    //83
                    //125
                    
                }
                

                
                

         
}
        
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.hidden = NO;
        [activityIndicator startAnimating];
        activityIndicator.center = CGPointMake(cell.imgMain.frame.size.width/2, cell.imgMain.frame.size.height/2);
        [cell.imgMain addSubview:activityIndicator];

        
        [cell.imgMain sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL_IMAGE,imageName]]
                     placeholderImage:nil
                              options:SDWebImageProgressiveDownload
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                if (!error) {
                                    if (image) {
                                        cell.imgMain.image = image;
                                        [activityIndicator stopAnimating];
                                        [activityIndicator removeFromSuperview];
                                        activityIndicator.center = cell.imgMain.center;
                                    }
                                }
                                else{
                                    [activityIndicator stopAnimating];
                                    [activityIndicator removeFromSuperview];
                                }
        }];

    }
    else{
        
        cell.lblHeading.lineBreakMode=NSLineBreakByCharWrapping;
        [cell.lblHeading sizeToFit];
        float newHeight = [self heightOfLabel:ibModelDetails.headline];
        float newHeightDesc = [self heightOfLabel:ibModelDetails.description_idea_brief];
        CGRect newRect;
        
        if ([PPUtilts isiPhone6Plus]||[PPUtilts isiPhone6]) {
            if (newHeight<50) {
                newRect = CGRectMake(40, 53, self.view.frame.size.width-130, newHeight);
                [cell.lblHeading setFrame:newRect];
                [cell.lblDescription setFrame:CGRectMake(40, cell.lblHeading.frame.size.height+60 , self.view.frame.size.width-130, newHeightDesc)];
                NSLog(@"=======height === %f \n ",newHeight);
                
            }

            
            else if(newHeight >232){
                newRect = CGRectMake(40, 30, self.view.frame.size.width-130, newHeight);
                [cell.lblHeading setFrame:newRect];
                [cell.lblDescription setFrame:CGRectMake(40, cell.lblHeading.frame.size.height+20 , self.view.frame.size.width-130, newHeightDesc)];
                NSLog(@"=======height === %f \n ",newHeight);
                
            }
            else if(newHeight >185){
                newRect = CGRectMake(40, 35, self.view.frame.size.width-130, newHeight);
                [cell.lblHeading setFrame:newRect];
                CGRect frameDesc = cell.lblHeading.frame;
                frameDesc.origin.y =cell.lblHeading.frame.size.height+20;
                cell.lblDescription.frame = frameDesc;
                
                NSLog(@"=======height === %f \n ",newHeight);
                
            }
            else if (newHeight>138){
                
                newRect = CGRectMake(40, 40, self.view.frame.size.width-130, newHeight);
                [cell.lblHeading setFrame:newRect];
                
                CGRect frameDesc = cell.lblHeading.frame;
                frameDesc.origin.y =cell.lblHeading.frame.size.height+30;
                cell.lblDescription.frame = frameDesc;
                NSLog(@"=======height === %f \n ",newHeight);
            }
            

            

            else{
                newRect = CGRectMake(40, 60, self.view.frame.size.width-130, newHeight);
                [cell.lblHeading setFrame:newRect];

                CGRect frameDesc = cell.lblHeading.frame;
                frameDesc.origin.y =cell.lblHeading.frame.size.height+60;
                cell.lblDescription.frame = frameDesc;
                NSLog(@"=======height === %f \n ",newHeight);
                //83
                //125
                
            }
            
        }
        
        else{
       //iPhone5 Without Image
            
            if (newHeight<50) {
                newRect = CGRectMake(40, 48, 240, newHeight);
                [cell.lblHeading setFrame:newRect];
                CGRect frameDesc = cell.lblHeading.frame;
                frameDesc.origin.y =cell.lblHeading.frame.size.height+54;
                cell.lblDescription.frame = frameDesc;
                NSLog(@"=======height === %f \n ",newHeight);
                
            }
            else if(newHeight >240){
                newRect = CGRectMake(40, 40, 240, newHeight);
                [cell.lblHeading setFrame:newRect];
                NSLog(@"=======height === %f \n ",newHeight);
            }
            else if(newHeight >185){
                newRect = CGRectMake(40, 45, 240, newHeight);
                [cell.lblHeading setFrame:newRect];
                CGRect frameDesc = cell.lblHeading.frame;
                frameDesc.origin.y =cell.lblHeading.frame.size.height+50;
                cell.lblDescription.frame = frameDesc;
                NSLog(@"=======height === %f \n ",newHeight);
                
            }
            else{
                newRect = CGRectMake(40, 47,240, newHeight);
                [cell.lblHeading setFrame:newRect];
                CGRect frameDesc = cell.lblHeading.frame;
                frameDesc.origin.y =cell.lblHeading.frame.size.height+52;
                cell.lblDescription.frame = frameDesc;
                NSLog(@"=======height === %f \n ",newHeight);
                //83
                //125
                
            }
            
            //lblHeight.lineBreakMode=NSLineBreakByWordWrapping;
            //[lblHeight sizeToFit];
            
            
            
            
            
        }

    }
    
    
    BOOL isHot=[ibModelDetails.is_hot isEqualToString:BOOL_YES];

    UIImageView *imgIdea=(UIImageView *) [cell.contentView viewWithTag:PP201];
    UIImageView *imgBrief=(UIImageView *)[cell.contentView viewWithTag:PP202];
    UIImageView *imgHot=(UIImageView *)  [cell.contentView viewWithTag:PP203];
   // UIImageView *imgGoogle=(UIImageView *)  [cell.contentView viewWithTag:PP204];
    //[imgGoogle setHidden:NO];
    
    heightHeading=(UILabel *)[cell.contentView viewWithTag:1000];
    heightDescription=(UILabel *)[cell.contentView viewWithTag:1001];
    heightImageView=(UIImageView *)[cell.contentView viewWithTag:1002];
    
    NSString *strColorType=ibModelDetails.color_code;
    isAnswerTheBriefs=YES;
    
    if (isHot) {
        cell.lblTag.frame=CGRectMake(40, 26, 240-63, 20);

    }
    else{
        cell.lblTag.frame=CGRectMake(40, 26, 240-42, 20);

    }
    
    typedef void (^CaseBlockForColor)();
    NSDictionary *colorType = @{
                                R:
                                    ^{[cell setBackgroundColor:[UIColor    PPRedColor]];
                                        if (indexPath.row==0) {
                                            [self.view setBackgroundColor:[UIColor    PPRedColor]];
                                        }
                                        cell.lblTag.textColor=[UIColor whiteColor];
                                        cell.lblHeading.textColor=[UIColor whiteColor];
                                        cell.lblDescription.textColor=[UIColor whiteColor];
                                        isAnswerTheBriefs=NO;
                                        imgIdea.hidden=NO;

                                        cell.lblGPlus.textColor=[UIColor PPRedColor];
                                        
                                        if (isHot) {
                                            imgHot.hidden =NO;
                                            cell.lblGPlus.frame=imgIdea.frame;

                                            imgIdea.frame=imgBrief.frame;
                                            cell.lblTag.frame=CGRectMake(40, 26, 240-42, 20);


                                        }
                                        else{
                                            cell.lblGPlus.frame=imgBrief.frame;
                                            imgIdea.frame=imgHot.frame;
                                            cell.lblTag.frame=CGRectMake(40, 26, 240-21, 20);

                                        }
                                    },
                                Y:
                                    ^{[cell setBackgroundColor:[UIColor    PPYellowColor]];
                                        if (indexPath.row==0) {
                                            [self.view setBackgroundColor:[UIColor    PPYellowColor]];
                                        }
                                        cell.lblTag.textColor=[UIColor PPYellowColor];
                                        cell.lblGPlus.textColor=[UIColor PPYellowColor];

                                        imgIdea.hidden=NO;
                                        imgBrief.hidden=NO;
                                        if (isHot){
                                            imgHot.hidden =NO;
                                           // cell.lblTag.frame=CGRectMake(40, 22, 240-63, 20);

                                        }
                                        else{
                                            cell.lblGPlus.frame=imgIdea.frame;

                                            imgIdea.frame=imgBrief.frame;
                                            imgBrief.frame=imgHot.frame;
                                           // cell.lblTag.frame=CGRectMake(40, 22, 240-42, 20);

                                        }
                                        
                                    },
                                G:
                                    ^{ [cell setBackgroundColor:[UIColor    PPGreenColor]];
                                        if (indexPath.row==0) {
                                            [self.view setBackgroundColor:[UIColor    PPGreenColor]];
                                        }
                                        cell.lblTag.textColor=[UIColor PPGreenColor];
                                        cell.lblGPlus.textColor=[UIColor PPGreenColor];

                                        imgIdea.hidden=NO;
                                        imgBrief.hidden=NO;
                                        

                                        
                                        CGRect frame = imgIdea.frame;
                                        
                                        
                                        imgIdea.frame=imgBrief.frame;
                        
        
                                        imgBrief.frame=frame;
                                        
   
                                        if (isHot) {
                                            imgHot.hidden =NO;
                                            //cell.lblTag.frame=CGRectMake(40, 22, 240-63, 20);



                                        }
                                        else{
                                            cell.lblGPlus.frame=imgBrief.frame;
                                            imgBrief.frame=imgIdea.frame;
                                            imgIdea.frame =imgHot.frame;
                                           // cell.lblTag.frame=CGRectMake(40, 22, 240-42, 20);

                                            
                                            
        
                                        }
                                    },
                                B:
                                    ^{ [cell setBackgroundColor:[UIColor    PPBlueColor]];
                                        if (indexPath.row==0) {
                                            [self.view setBackgroundColor:[UIColor    PPBlueColor]];
                                        }
                                        cell.lblTag.textColor=[UIColor PPBlueColor];
                                        cell.lblGPlus.textColor=[UIColor PPBlueColor];

                                        imgBrief.hidden=NO;

                                        if (isHot) {
                                            imgHot.hidden =NO;
                                            cell.lblGPlus.frame=imgIdea.frame;
                                            cell.lblTag.frame=CGRectMake(40, 26, 240-42, 20);

                                        }
                                        else{
                                            cell.lblGPlus.frame=imgBrief.frame;
                                            imgBrief.frame=imgHot.frame;
                                            cell.lblTag.frame=CGRectMake(40, 26, 240-21, 20);

                                        }
                                    }
                                };
    
    ((CaseBlockForColor)colorType[strColorType])(); // invoke the correct block of code
    
    return cell;
}


- (void)buttonPressedAction:(id)sender
{
    CGPoint buttonOriginInTableView = [sender convertPoint:CGPointZero toView:self.table];
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint:buttonOriginInTableView];

  ([PPUtilts sharedInstance].apiCall==kApiCallNotifications)?(ibModelDetails= notificationModel.NotificatioDetail[indexPath.row]):(ibModelDetails = ibModel.Detail[indexPath.row]);

    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setToRecipients:@[ibModelDetails.user_email]];
        [self presentViewController:mail animated:YES completion:NULL];
    }
    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    [self.table reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(BOOL)isImageExist:(NSString*)path{return (![[path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0);}

@end
