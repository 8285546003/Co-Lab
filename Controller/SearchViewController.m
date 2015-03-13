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


@interface SearchViewController (){
    StatusModel  *statusModel;
    SearchModel      *ibModel;
}

@end

@implementation SearchViewController
@synthesize allDataTableView,txtSearch;
- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    imageView.image = [UIImage imageNamed:@"s1"];
    self.txtSearch.leftView = imageView;
    self.txtSearch.leftViewMode=UITextFieldViewModeAlways;\
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
- (void) hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ibModel.SearchAuto.count;
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
     SearchModelDetails* ibModelDetails = ibModel.SearchAuto[indexPath.row];
     StatusModelDetails* status = statusModel.StatusArr[0];
    
    if (status.Message==kResultNoRecord){
        cell.textLabel.text=kResultNoRecord;
    }
    else{
        cell.textLabel.text=ibModelDetails.tag;

    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StatusModelDetails* status = statusModel.StatusArr[0];
    if (status.Message==kResultNoRecord) {
        return 200;
    }
    else{
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchModelDetails* ibModelDetails = ibModel.SearchAuto[indexPath.row];
    
    [PPUtilts sharedInstance].tagSearch=ibModelDetails.tag;
    [self goToLatestIdeaBriefs];
}


-(void)getDataFromTag:(NSString*)tag{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = CONTENT_TYPE_HTML;
    NSDictionary *parameters=@{kApiCall:kApiCallSearchAuto,kTag:tag};
    
    [manager POST:BASE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ibModel = [[SearchModel alloc] initWithDictionary:responseObject error:nil];
        statusModel = [[StatusModel alloc] initWithDictionary:responseObject error:nil];
        StatusModelDetails* status = statusModel.StatusArr[0];
        if ([status.Error isEqualToString:kResultError]) {
            [self.allDataTableView reloadData];
            [self.allDataTableView setHidden:NO];
        }
        else{
            kCustomErrorAlert;
        }
        [self settingBarButton];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self settingBarButton];
        kCustomErrorAlert;
        
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
        [self getDataFromTag:string];
    }
    else{
         [self getDataFromTag:[txtSearch.text stringByAppendingString:string]];
    }
    return YES;
}
@end
