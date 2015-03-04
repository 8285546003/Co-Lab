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
    return [[[self.allData valueForKey:@"SearchAuto"] valueForKey:@"tag"] count];
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
    cell.textLabel.text=[[[self.allData valueForKey:@"SearchAuto"] valueForKey:@"tag"] objectAtIndex:indexPath.row];
    
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
    [PPUtilts sharedInstance].tagSearch=[[[self.allData valueForKey:@"SearchAuto"] valueForKey:@"tag"]objectAtIndex:indexPath.row];
    [self goToLatestIdeaBriefs];
}


-(void)getDataFromTag:(NSString*)tag{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSLog(@"%@",tag);
    NSDictionary *parameters=@{@"apicall":@"SearchAuto",@"tag":tag};
    
    [manager POST:BASE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            if ([[responseObject valueForKey:@"Error"] isEqualToString:@"false"]&&[[responseObject valueForKey:@"Message"] isEqualToString:@"Success"]) {
            [self settingBarButton];
            self.allData=responseObject;
            [self.allDataTableView reloadData];
            [self.allDataTableView setHidden:NO];
            }
            else{
                kCustomAlert(@"Error", @"Somthing went wrong", @"Ok");
                [self settingBarButton];
            }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self settingBarButton];
        
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
