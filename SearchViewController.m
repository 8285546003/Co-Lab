//
//  SearchViewController.m
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController (){
 IBOutlet UITextField *txtRearch;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *imgSearch=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)]; // Set frame as per space required around icon
    [imgSearch setImage:[UIImage imageNamed:@"Search_Image.png"]];
    
    [imgSearch setContentMode:UIViewContentModeCenter];// Set content mode centre
    
    txtRearch.leftView=imgSearch;
    txtRearch.leftViewMode=UITextFieldViewModeAlways;
    
    
    
    [self settingBarButton];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)settingBarButton{
    
    NSLog(@"View height == %f",self.view.bounds.size.height);
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, self.view.bounds.size.height - 60, 50, 50)];
    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateSelected];
    [closeButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.tag = 1000;
    [self.view addSubview:closeButton];
    [closeButton bringSubviewToFront:self.view];
    
    UIButton *attachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [attachButton setFrame:CGRectMake(self.view.frame.size.width-120, self.view.frame.size.height - 60, 50, 50)];
    [attachButton setImage:[UIImage imageNamed:@"Attachment_Image.png"] forState:UIControlStateNormal];
    [attachButton setImage:[UIImage imageNamed:@"Attachment_Image.png"] forState:UIControlStateSelected];
    [attachButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    attachButton.tag = 2000;
    [self.view addSubview:attachButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - 60, 50, 50)];
    [nextButton setImage:[UIImage imageNamed:@"Next_Image.png"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"Next_Image.png"] forState:UIControlStateSelected];
    [nextButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = 3000;
    [self.view addSubview:nextButton];
    
}
- (void)settingBarMethod:(UIButton *)settingBtn{
    NSLog(@"Button tag == %ld",(long)settingBtn.tag);
    switch (settingBtn.tag) {
        case 1000:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2000:{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Take a photo!" delegate:nil cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"From Galary", @"From Camra", nil];
            [actionSheet showInView:self.view];
        }
            break;
        case 3000:{
            
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
