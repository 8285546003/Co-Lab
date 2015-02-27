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

@interface ExpendableTableViewController ()

@end

@implementation ExpendableTableViewController
@synthesize table;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLatestIdeaBrief];
    self.table.HVTableViewDataSource = self;
    self.table.HVTableViewDelegate = self;
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)getLatestIdeaBrief{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = @"Please wait...";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"apicall":@"Detail",@"id":[PPUtilts sharedInstance].LatestIDId,@"color_code":[PPUtilts sharedInstance].colorCode};
    [manager POST:BASE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _allLatestIBDetails=responseObject;
        [self.table reloadData];
        [self.table setHidden:NO];
        [self settingBarButton];
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self settingBarButton];
        NSLog(@"fail! \nerror: %@", [error localizedDescription]);
        [hud hide:YES];
        
    }];
    
}

- (void)settingBarButton{
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
//    cell.alpha=0;
//    
//    [UIView animateWithDuration:1.5 animations:^{
//        cell.alpha = 1;
//        [cell.contentView viewWithTag:3].transform = CGAffineTransformMakeRotation(3.14);
//    }];
}

-(void)tableView:(UITableView *)tableView collapseCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
//    cell.alpha=0;
//    
//    [UIView animateWithDuration:1.5 animations:^{
//        cell.alpha=1;
//        [cell.contentView viewWithTag:3].transform = CGAffineTransformMakeRotation(-3.14);
//        
//    } completion:^(BOOL finished) {
//        
//    }];
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
            return 600;
    }
   
    if (isexpanded){
         return 600;
    }
    else{
        return 175;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded
{
    static NSString *CellIdentifier = @"CustomCellReuseID";
    LatestIBCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setTag:3];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LatestIBCell" owner:self options:nil]lastObject];
    }
    
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    UIView *cellBackgroundClearColor = [[UIView alloc] initWithFrame:cell.frame];
    cellBackgroundClearColor.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = cellBackgroundClearColor;
    
    cell.lblHeading.text=[[[_allLatestIBDetails  valueForKey:@"Detail"] valueForKey:@"headline"] objectAtIndex:indexPath.row];
    cell.lblTag.text=[[[_allLatestIBDetails valueForKey:@"Detail"] valueForKey:@"tag"] objectAtIndex:indexPath.row];
     cell.lblDescription.text=[[[_allLatestIBDetails valueForKey:@"Detail"] valueForKey:@"description"] objectAtIndex:indexPath.row];
    NSString *imageName=[[[_allLatestIBDetails valueForKey:@"Detail"] valueForKey:@"image"] objectAtIndex:indexPath.row];
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
    
    BOOL isHot=[[[[_allLatestIBDetails valueForKey:@"Detail"] valueForKey:@"is_hot"] objectAtIndex:indexPath.row] isEqualToString:@"No"]?NO:YES;
    // BOOL isBrief=[[[[self.allLatestIdeaAndBrief valueForKey:@"LatestIdeaBrief"] valueForKey:@"is_brief"] objectAtIndex:indexPath.row] isEqualToString:@"No"]?NO:YES;
    UIImageView *imgIdea=(UIImageView *)[cell.contentView viewWithTag:101];
    UIImageView *imgBrief=(UIImageView *)[cell.contentView viewWithTag:102];
    UIImageView *imgHot=(UIImageView *)[cell.contentView viewWithTag:103];
    if (isHot) {
        imgHot.hidden =NO;
    }
    
    NSString *strColorType=[[[_allLatestIBDetails valueForKey:@"Detail"] valueForKey:@"color_code"] objectAtIndex:indexPath.row];
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

-(BOOL)isImageExist:(NSString*)path{return (![[path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0);}

@end
