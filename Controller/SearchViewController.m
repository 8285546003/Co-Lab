//
//  SearchViewController.m
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "SearchViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "PPUtilts.h"
#import "CoLabListViewController.h"
#import "StatusModel.h"
#import "StatusModelDetails.h"
#import "SearchModel.h"
#import "SearchModelDetails.h"
#import "UIColor+PPColor.h"
#import "AFNInjector.h"


@interface SearchViewController (){
    StatusModel  *statusModel;
    SearchModel      *ibModel;
    
    StatusModelDetails* status;
    SearchModelDetails* ibModelDetails;
}

@end

@implementation SearchViewController
@synthesize allDataTableView,txtSearch;
- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
    
   // self.txtSearch.leftView = paddingView;
   // self.txtSearch.leftViewMode = UITextFieldViewModeAlways;
    [paddingView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"search"];
    
    
    CGRect frameRect = self.txtSearch.frame;
    frameRect.size.height = 60;
    self.txtSearch.frame = frameRect;
    

    
    self.txtSearch.leftView = paddingView;
    self.txtSearch.leftViewMode=UITextFieldViewModeAlways;
    self.txtSearch.delegate=self;
    
    self.allDataTableView.backgroundColor=[UIColor clearColor];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self settingBarButton];
    [self.view setBackgroundColor:[UIColor PPBackGroundColor]];
    [super viewWillAppear:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    ibModel.SearchAuto=nil;
    txtSearch.text=nil;
    self.allDataTableView.hidden=YES;
}
- (void) hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [status.Message isEqualToString:kResultNoRecord] ? 200 : 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [status.Message isEqualToString:kResultNoRecord] ? 1 : ibModel.SearchAuto.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSString *CellIdentifier = kStaticIdentifier;
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.backgroundColor=[UIColor clearColor];
     ibModelDetails= ibModel.SearchAuto[indexPath.row];
     status = statusModel.StatusArr[[ZERO integerValue]];
     cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:15];
     [status.Message isEqualToString:kResultNoRecord] ? [cell.textLabel setText:kResultNoRecord]:[cell.textLabel setText:ibModelDetails.tag];
     [status.Message isEqualToString:kResultNoRecord] ? [self.allDataTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone]:[self.allDataTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];


     return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    status = statusModel.StatusArr[[ZERO integerValue]];
    if (![status.Message isEqualToString:kResultNoRecord]) {
        ibModelDetails = ibModel.SearchAuto[indexPath.row];
        [PPUtilts sharedInstance].tagSearch=ibModelDetails.tag;
        [self goToLatestIdeaBriefs];
    }
}


-(void)getDataFromTag:(NSString*)tag{

    NSDictionary *parameters=@{kApiCall:kApiCallSearchAuto,kTag:tag};
    
    AFNInjector *objAFN = [AFNInjector new];
    [objAFN parameters:parameters completionBlock:^(id data, NSError *error) {
        if(!error) {
            statusModel = [[StatusModel alloc] initWithDictionary:data error:nil];
            status = statusModel.StatusArr[[ZERO integerValue]];
            ibModel = [[SearchModel alloc] initWithDictionary:data error:nil];

            if ([status.Error isEqualToString:kResultError]) {
                if ([status.Message isEqualToString:kResultMessage]) {
                    [self.allDataTableView setHidden:NO];
                    [self.allDataTableView reloadData];
                }
                else{
                    [self.allDataTableView setHidden:NO];
                    ibModel.SearchAuto=nil;
                    [self.allDataTableView reloadData];
                }
            }
            else{
                kCustomAlert(@"", status.Message, @"Ok");
            }
             [self settingBarButton];
        } else {
            [self settingBarButton];
        }
    }];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)settingBarButton{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CANCEL_BUTTON_FRAME];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateSelected];
    [cancelButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag=PPkCancel;
    [self.view addSubview:cancelButton];
    [cancelButton bringSubviewToFront:self.view];
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


-(void)goToLatestIdeaBriefs{
    [PPUtilts sharedInstance].apiCall=kApiCallTagSearch;
    CoLabListViewController *objLatestIB = [CoLabListViewController new];
    [self.navigationController pushViewController:objLatestIB animated:YES];
}


#pragma UITextfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    
        if (isBackSpace == -8) {
            string = [txtSearch.text substringToIndex:[txtSearch.text length] - 1];
            ![string isEqualToString:@""] ? [self getDataFromTag:string]:[self.allDataTableView setHidden:YES];ibModel.SearchAuto=nil;[self.allDataTableView reloadData];
        }
        else{
            [self getDataFromTag:[txtSearch.text stringByAppendingString:string]];
        }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
