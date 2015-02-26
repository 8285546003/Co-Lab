//
//  ExpendableTableViewController.m
//  Co\Lab 
//
//  Created by magnon on 25/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//




#import "ExpendableTableViewController.h"
#import "MBProgressHUD.h"
#import "PPUtilts.h"
#import "AFNetworking.h"
#import "LatestIBCell.h"
#import "UIColor+PPColor.h"

@interface ExpendableTableViewController ()

@end

@implementation ExpendableTableViewController
@synthesize table;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getLatestIdeaBrief];
    [self settingBarButton];
    
    self.table.HVTableViewDataSource = self;
    self.table.HVTableViewDelegate = self;
    

    NSLog(@"aaaa %@   bbbbb %@",[PPUtilts sharedInstance].LatestIDId,[PPUtilts sharedInstance].colorCode);
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)getLatestIdeaBrief{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = @"Please wait...";
    hud.detailsLabelText=@"Latest idea and brief will be populating";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"apicall":@"Detail",@"id":[PPUtilts sharedInstance].LatestIDId,@"color_code":[PPUtilts sharedInstance].colorCode};
    [manager POST:BASE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _allLatestIBDetails=responseObject;
        [self.table reloadData];
         NSLog(@"JSON: %@", responseObject);
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        [hud hide:YES];
        
    }];
    
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
}
- (void)settingBarMethod:(UIButton *)settingBtn{
    switch (settingBtn.tag) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            break;
        default:
            break;
    }
}


-(void)tableView:(UITableView *)tableView expandCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:3];
    UIButton *purchaseButton = (UIButton *)[cell viewWithTag:10];
    purchaseButton.alpha = 0;
    purchaseButton.hidden = NO;
    
    [UIView animateWithDuration:.5 animations:^{
        detailLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        purchaseButton.alpha = 1;
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(3.14);
    }];
}

-(void)tableView:(UITableView *)tableView collapseCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:3];
    UIButton *purchaseButton = (UIButton *)[cell viewWithTag:10];
    
    [UIView animateWithDuration:.5 animations:^{
        detailLabel.text = @"Lorem ipsum dolor sit amet";
        purchaseButton.alpha = 0;
        [cell.contentView viewWithTag:7].transform = CGAffineTransformMakeRotation(-3.14);
    } completion:^(BOOL finished) {
        purchaseButton.hidden = YES;
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_allLatestIBDetails valueForKey:@"Detail"] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isexpanded
{
    if (indexPath.row==0) {
        return 400;
    }
    if (isexpanded){
         return 400;
    }
    else{
        return 175;
    }
    

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded
{
    static NSString *CellIdentifier = @"CustomCellReuseID";
    LatestIBCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LatestIBCell" owner:self options:nil]lastObject];
    }
    
    cell.lblHeading.text=[[[_allLatestIBDetails  valueForKey:@"Detail"] valueForKey:@"headline"] objectAtIndex:indexPath.row];
    cell.lblTag.text=[[[_allLatestIBDetails valueForKey:@"Detail"] valueForKey:@"tag"] objectAtIndex:indexPath.row];
    
    
    BOOL isHot=[[[[_allLatestIBDetails valueForKey:@"Detail"] valueForKey:@"is_hot"] objectAtIndex:indexPath.row] isEqualToString:@"No"]?NO:YES;
    // BOOL isBrief=[[[[self.allLatestIdeaAndBrief valueForKey:@"LatestIdeaBrief"] valueForKey:@"is_brief"] objectAtIndex:indexPath.row] isEqualToString:@"No"]?NO:YES;
    
    if (isHot) {
        cell.imgHot.hidden =NO;
    }
    
    NSString *strColorType=[[[_allLatestIBDetails valueForKey:@"Detail"] valueForKey:@"color_code"] objectAtIndex:indexPath.row];
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

@end
