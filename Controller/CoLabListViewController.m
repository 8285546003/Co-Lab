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

#define KEYBOARD_HEIGHT 216



@interface CoLabListViewController ()

@end

@implementation CoLabListViewController
@synthesize attachmentImage,allData,allDataTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isAttachment = NO;
    self.allDataTableView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.attachmentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [self getLatestIdeaBrief];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)getLatestIdeaBrief{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = @"Please wait...";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters;
    if ([PPUtilts sharedInstance].apiCall==kApiCall) {
        parameters = @{@"apicall":[PPUtilts sharedInstance].apiCall};
         }
    else if ([PPUtilts sharedInstance].apiCall==kApiCallTagSearch){
          parameters = @{@"apicall":[PPUtilts sharedInstance].apiCall,@"tag":[PPUtilts sharedInstance].tagSearch};
    }
    else{
        
        if ([PPUtilts sharedInstance].userID) {
            parameters = @{@"apicall":[PPUtilts sharedInstance].apiCall,@"user_id":[PPUtilts sharedInstance].userID};
        }
        else{
       
        }
    }
    [manager POST:BASE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // if ([[responseObject valueForKey:@"Message"] isEqualToString:@"Success"]&&[[responseObject valueForKey:@"Error"] isEqualToString:@"false"]) {
            NSLog(@"JSON: %@", responseObject);
            [self settingBarButton];
            self.allData=responseObject;
            [allDataTableView setHidden:NO];
            [allDataTableView reloadData];
       // }
//else{
            [self settingBarButton];
       // }
        
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self settingBarButton];
        if (PPNoInternetConnection) {
            kCustomAlert(@"Error", @"Someting went wrong please connect to your WiFi/3G",@"Ok");
        }
        [hud hide:YES];
        
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
    return [[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"color_code"]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CustomCellReuseID";
    LatestIBCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LatestIBCell" owner:self options:nil]lastObject];
    }
    
    cell.lblHeading.text=[[[self.allData  valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"headline"] objectAtIndex:indexPath.row];
    cell.lblTag.text=[[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"tag"] objectAtIndex:indexPath.row];
    
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    UIView *cellBackgroundClearColor = [[UIView alloc] initWithFrame:cell.frame];
    cellBackgroundClearColor.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = cellBackgroundClearColor;
    
    BOOL isHot=[[[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"is_hot"] objectAtIndex:indexPath.row] isEqualToString:@"No"]?NO:YES;
    
    UIImageView *imgIdea=(UIImageView *)[cell.contentView viewWithTag:101];
    UIImageView *imgBrief=(UIImageView *)[cell.contentView viewWithTag:102];
    UIImageView *imgHot=(UIImageView *)[cell.contentView viewWithTag:103];
    

    
    NSString *strColorType=[[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"color_code"] objectAtIndex:indexPath.row];
    typedef void (^CaseBlockForColor)();
    NSDictionary *colorType = @{
                                
                                @"R":
                                    ^{[cell setBackgroundColor:[UIColor    PPRedColor]];
                                        imgIdea.hidden=NO;
                                        if (isHot) {imgHot.hidden =NO;imgIdea.frame=imgBrief.frame;}
                                        else{imgIdea.frame=imgHot.frame;}
                                    },
                                @"Y":
                                    ^{[cell setBackgroundColor:[UIColor    PPYellowColor]];
                                        imgIdea.hidden=NO;
                                        imgBrief.hidden=NO;
                                        if (isHot){imgHot.hidden =NO;}
                                        else{imgIdea.frame=imgBrief.frame;imgBrief.frame=imgHot.frame;}

                                    },
                                @"G":
                                    ^{ [cell setBackgroundColor:[UIColor    PPGreenColor]];
                                        imgIdea.hidden=NO;
                                        imgBrief.hidden=NO;
                                        if (isHot) {imgHot.hidden =NO;}
                                        else{imgIdea.frame=imgBrief.frame;imgBrief.frame=imgHot.frame;}
                                    },
                                @"B":
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
    return 250.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpendableTableViewController *obj=[ExpendableTableViewController new];
    [PPUtilts sharedInstance].colorCode=[[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"color_code"] objectAtIndex:indexPath.row];
    [PPUtilts sharedInstance].LatestIDId=[[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"id"] objectAtIndex:indexPath.row];
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
    [tmpOverlayObj createOrAnswerIB:self.view With:NO];
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
