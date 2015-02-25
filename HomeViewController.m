//
//  HomeViewController.m
//  iBrief
//
//  Created by Magnon International on 14/01/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "SearchViewController.h"
#import "CreateBriefViewController.h"
#import "LatestIdeaBriefsViewController.h"
#define kCellHeaderHeight 100
#define kCellHeight       75
#define ImageArray @[@"CoAppImage73.png",@"Create_New_Idea_Image.png",@"Create_New_Brief_Image.png",@"Search_Image.png",@"Profile_Image.png",@"Latest_Idea_And_Briefs.png"]
#define  CellTitleText  @[@" CO\\Lab",@"  Create New Idea",@"  Create New Briefs",@"  Search",@"  Profile",@"  Latest Idea & Brifes"]

typedef enum {
    
  PPkHomeViewController,
  PPkCreateIdeaViewController,
  PPkCreateBriefViewController,
  PPkSearchViewController,
  PPkProfileViewController,
  PPkLatestIdeasBrifes
    
}ControllerType;

typedef enum ButtonType{
    
    PPkClose,
    PPkNext
    
}ButtonType;

@interface HomeViewController (){
    NSArray *imageArray;
    NSArray *cellTitleText;
    __weak IBOutlet UIView *notificationView;
}
@property (nonatomic, strong) IBOutlet UITableView *homeTableView;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    notificationView.hidden = YES;
    imageArray=ImageArray ;
    cellTitleText = CellTitleText;
    notificationView.hidden=YES;
    
    self.homeTableView.delegate   = self;
    self.homeTableView.dataSource = self;
    [self settingBarButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)settingBarButton{
    
    NSLog(@"View height == %f",self.view.bounds.size.height);
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(10, self.view.bounds.size.height - 60, 50, 50)];
    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateSelected];
    [closeButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.tag = 0;
    [notificationView addSubview:closeButton];
    [closeButton bringSubviewToFront:self.view];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(self.view.frame.size.width - 60, self.view.frame.size.height - 60, 50, 50)];
    [nextButton setImage:[UIImage imageNamed:@"Next_Image.png"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"Next_Image.png"] forState:UIControlStateSelected];
    [nextButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = 1;
    [notificationView addSubview:nextButton];
    
}
- (void)settingBarMethod:(UIButton *)settingBtn{
    NSLog(@"Button tag == %ld",(long)settingBtn.tag);
    switch (settingBtn.tag) {
        case 0: notificationView.hidden=[self isNotificationViewVisible];
            break;
        case 1:
           break;
        default:
            break;
    }
}


-(BOOL)isNotificationViewVisible{
    
    if (PPkClose) {
        return YES;
    }
    else if (PPkNext){
        return YES;
    }
    else{
        return YES;
    }
    return YES;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [cellTitleText count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.textColor=[UIColor blackColor];
    [cell.imageView setImage:[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]]];
    cell.textLabel.text = [cellTitleText objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    else{
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.row==5) {
            cell.textLabel.numberOfLines=0;
            NSString *str = [NSString stringWithFormat:@"%@\n\n\n\n",[cellTitleText objectAtIndex:indexPath.row]];
            cell.textLabel.text=str;
        }
    }

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0){
        return kCellHeaderHeight;
    }
    else if (indexPath.row==5){
        return 125;
    }
    else{
        return kCellHeight;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
            
        case PPkHomeViewController:
            break;
        case PPkCreateIdeaViewController:[self goToCreateNewIdea];
            break;
        case PPkCreateBriefViewController:[self goToCreateNewBriefs];
            break;
        case PPkSearchViewController:[self goToSearch];
            break;
        case PPkProfileViewController:[self goToProfile];
            break;
        case PPkLatestIdeasBrifes:[self goToLatestIdeaBriefs];
            break;
        default:
            break;
            
    }
    
}
-(void)goToProfile{
    ProfileViewController *objProfile = [ProfileViewController new];
    [self.navigationController pushViewController:objProfile animated:YES];
}
-(void)goToSearch{
    SearchViewController *objSearch= [SearchViewController new];
    [self.navigationController pushViewController:objSearch animated:YES];
}
-(void)goToCreateNewIdea{
    CreateIdea_BriefViewController *objCreateIdea = [CreateIdea_BriefViewController new];
    [objCreateIdea setIsIdeaSubmitScreen:YES];
    [self.navigationController pushViewController:objCreateIdea animated:YES];
   // CreateIdeaViewController *objCreateIdea = [CreateIdeaViewController new];
   // [self.navigationController pushViewController:objCreateIdea animated:YES];
}
-(void)goToCreateNewBriefs{
    CreateIdea_BriefViewController *objCreateIdea = [CreateIdea_BriefViewController new];
    [objCreateIdea setIsIdeaSubmitScreen:NO];
    [self.navigationController pushViewController:objCreateIdea animated:YES];
    //CreateBriefViewController *objCreateBrife = [CreateBriefViewController new];
    //[self.navigationController pushViewController:objCreateBrife animated:YES];
}
-(void)goToLatestIdeaBriefs{
    LatestIdeaBriefsViewController *objLatestIB = [LatestIdeaBriefsViewController new];
    [self.navigationController pushViewController:objLatestIB animated:YES];
}

@end
