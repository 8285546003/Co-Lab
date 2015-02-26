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

#define KEYBOARD_HEIGHT 216

static NSString *kApiCall=@"LatestIdeaBrief";

typedef enum{
    R,
    Y,
    G,
    B
} CardType;

typedef enum{
    Cancle,
    Add,
} ActionType;


@interface CoLabListViewController ()

@end

@implementation CoLabListViewController
@synthesize attachmentImage,allData,allDataTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[PPUtilts sharedInstance].connected?[self getLatestIdeaBrief]:kCustomAlert(@"No NetWork", @"Something went wrong please check your WIFI connection");
    isAttachment = NO;
    self.attachmentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self getLatestIdeaBrief];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)getLatestIdeaBrief{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = @"Please wait...";
    //hud.detailsLabelText=@"Latest idea and brief will be populating";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters;
    if ([PPUtilts sharedInstance].apiCall==kApiCall) {
        parameters = @{@"apicall":[PPUtilts sharedInstance].apiCall};
         }
    else{
        parameters = @{@"apicall":[PPUtilts sharedInstance].apiCall,@"user_id":[PPUtilts sharedInstance].userID};
    }
    
    
    [manager POST:BASE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject valueForKey:@"Message"] isEqualToString:@"Success"]&&[[responseObject valueForKey:@"Error"] isEqualToString:@"false"]) {
            NSLog(@"JSON: %@", responseObject);
            [self settingBarButton];
            self.allData=responseObject;
            [allDataTableView setHidden:NO];
            [allDataTableView reloadData];
        }
        else{
            [self settingBarButton];
        }
        
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self settingBarButton];
        NSLog(@"fail! \nerror: %@", [error localizedDescription]);
        [hud hide:YES];
        
    }];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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
    BOOL isHot=[[[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"is_hot"] objectAtIndex:indexPath.row] isEqualToString:@"No"]?NO:YES;
    
    if (isHot) {
        cell.imgHot.hidden =NO;
    }
    
    NSString *strColorType=[[[self.allData valueForKey:[PPUtilts sharedInstance].apiCall] valueForKey:@"color_code"] objectAtIndex:indexPath.row];
    typedef void (^CaseBlockForColor)();
    NSDictionary *colorType = @{
                                
                                @"R":
                                    ^{[cell setBackgroundColor:[UIColor    PPRedColor]];cell.imgIdea.hidden=NO;},
                                @"Y":
                                    ^{[cell setBackgroundColor:[UIColor    PPYellowColor]];cell.imgIdea.hidden=NO;cell.imgBrief.hidden=NO;},
                                @"G":
                                    ^{ [cell setBackgroundColor:[UIColor    PPGreenColor]];cell.imgIdea.hidden=NO;cell.imgBrief.hidden=NO;},
                                @"B":
                                    ^{ [cell setBackgroundColor:[UIColor    PPBlueColor]];cell.imgBrief.hidden=NO;}
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

- (void)settingBarButton{
    
    NSLog(@"View height == %f",self.view.bounds.size.height);
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, self.view.bounds.size.height - 60, 50, 50)];
    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateSelected];
    [closeButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.tag = 0;
    [self.view addSubview:closeButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - 60, 50, 50)];
    [nextButton setImage:[UIImage imageNamed:@"red_plus_down.png"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"red_plus_down.png"] forState:UIControlStateSelected];
    [nextButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = 1;
    [self.view addSubview:nextButton];
}

- (void)settingBarMethod:(UIButton *)settingBtn{
    NSLog(@"Button tag == %ld",(long)settingBtn.tag);
    switch (settingBtn.tag) {
        case Cancle:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case Add:[self addOverLay];
            break;
        default:
            break;
    }
}
-(void)addOverLay{
    tmpOverlayObj = [[OverlayView alloc] initOverlayView];
    tmpOverlayObj.tag = 1000;
    [tmpOverlayObj setDelegate:self];
    [self.view addSubview:tmpOverlayObj];
    [tmpOverlayObj renderingScreenAccordingToFrame:self.view isBrief:NO];
}
- (void) photoFromCamraOrGalary{
    
}
- (void) hideKeyboard {
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sectionTapped{
    
}

@end
