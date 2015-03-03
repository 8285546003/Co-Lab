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


@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize allData,allDataTableView,txtSearch;
- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.image = [UIImage imageNamed:@"s1"];
    self.txtSearch.leftView = imageView;
    self.txtSearch.leftViewMode=UITextFieldViewModeAlways;\
    self.txtSearch.delegate=self;
    [self settingBarButton];
    
    self.allDataTableView.backgroundColor=[UIColor clearColor];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void) hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if ([[self.allData valueForKey:@"Message"] isEqualToString:@"No record found."]) {
        
        return 1;
        
    }
    else{
    return [[[self.allData valueForKey:@"TagSearch"] valueForKey:@"headline"]count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CustomCellReuseID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    
    if ([[self.allData valueForKey:@"Message"] isEqualToString:@"No record found."]) {
        cell.imageView.image=[UIImage imageNamed:@"found"];
    }
    else{
    cell.textLabel.text=[[[self.allData valueForKey:@"TagSearch"] valueForKey:@"headline"]objectAtIndex:indexPath.row];
    
        cell.imageView.image=nil;
    }
    

    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.allData valueForKey:@"Message"] isEqualToString:@"No record found."]) {
        
        return 200;
        
    }
    else{

        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self goToLatestIdeaBriefs];
}


-(void)getDataFromTag:(NSString*)tag{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters=@{@"apicall":@"TagSearch",@"tag":tag};
    
    
    [manager POST:BASE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [self settingBarButton];
            self.allData=responseObject;
            self.allDataTableView.tableFooterView.frame=CGRectZero;
            [self.allDataTableView reloadData];
           [self.allDataTableView setHidden:NO];
        if ([[responseObject valueForKey:@"Message"] isEqualToString:@"No record found."]) {
            
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self settingBarButton];
        
    }];

}

- (void)settingBarButton{
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CANCEL_BUTTON_FRAME];
    [closeButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateSelected];
    [closeButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.tag=Cancel;
    [self.view addSubview:closeButton];
    [closeButton bringSubviewToFront:self.view];
}
- (void)settingBarMethod:(UIButton *)settingBtn{
    switch (settingBtn.tag) {
        case Cancel:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case Add:
            break;
        case Attachment:
            break;
        default:
            break;
    }
}


-(void)goToLatestIdeaBriefs{
    [PPUtilts sharedInstance].apiCall=kApiCall;
    CoLabListViewController *objLatestIB = [CoLabListViewController new];
    [self.navigationController pushViewController:objLatestIB animated:YES];
}


#pragma UITextfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self getDataFromTag:[txtSearch.text stringByAppendingString:string]];
    return YES;
}
@end
