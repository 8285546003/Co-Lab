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
#import "HomeViewController.h"
#import "NotificationViewController.h"
#import "PPUtilts.h"
#import "CustomBadge.h"
#import "NotificationCount.h"
#import "NotificationCount.h"
#import "NotificationCountModel.h"
#import "MBProgressHUD.h"



#import "StatusModel.h"
#import "StatusModelDetails.h"
#import "IBModel.h"
#import "IBModelDetails.h"
#import "TagSearchModel.h"
#import "MyIdeaModel.h"
#import "MyBriefModel.h"
#import "AFNInjector.h"


#import "RGMPagingScrollView.h"
#import "RGMPageControl.h"
#import "RGMPageView.h"
#import "LatestIBCell.h"


#import "ExpendableTableViewController.h"


@interface HomeViewController ()<MBProgressHUDDelegate,RGMPagingScrollViewDatasource, RGMPagingScrollViewDelegate>{
    NSArray *imageArray;
    NSArray *cellTitleText;
    __weak IBOutlet UIView *notificationView;
    
    
    NotificationCount  *notificationCount;
    NotificationCountModel*notificationCountModel;
    
        __weak IBOutlet UILabel       *lblNotificationCount;
    CustomBadge *badge;
    MBProgressHUD *HUD;
    
    
    
    
    
    
    //------------Models-----------------
    StatusModel    *statusModel;
    IBModel        *ibModel;
    TagSearchModel *tagModel;
    MyIdeaModel    *myIdeaModel;
    MyBriefModel   *myBriefModel;
    
    IBModelDetails* ibModelDetails;
    StatusModelDetails* status;
    
    BOOL isHot;
    BOOL isBrief;;
    NSString *strColorType;
    
    NSDictionary *parameters;
    UILabel *lblHeight;
    
    
    
    UIImageView *attachmentImage;
    BOOL isAttachment;
    OverlayView *tmpOverlayObj;
      UITableView *allDataTableView;
      UITableView *homeTableView;
 
    
}
#pragma mark - RGMPagingScrollViewDatasource

- (NSInteger)pagingScrollViewNumberOfPages:(RGMPagingScrollView *)pagingScrollView;
- (UIView *)pagingScrollView:(RGMPagingScrollView *)pagingScrollView viewForIndex:(NSInteger)idx;

#pragma mark - RGMPagingScrollViewDelegate

- (void)pagingScrollView:(RGMPagingScrollView *)pagingScrollView scrolledToPage:(NSInteger)idx;


@end


#pragma mark -

static NSString *reuseIdentifier = @"RGMPageReuseIdentifier";
static NSInteger numberOfPages = 2;

@implementation HomeViewController
@synthesize attachmentImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Disable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Enable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}
-(void)getNotificationCount{
    
    parameters = @{kApiCall:kApiCallNotificationsCount,kUserid:GET_USERID};
    
    AFNInjector *objAFN = [AFNInjector new];
    [objAFN parameters:parameters completionBlock:^(id data, NSError *error) {
        if(!error) {
            statusModel = [[StatusModel alloc] initWithDictionary:data error:nil];
            status = statusModel.StatusArr[[ZERO integerValue]];
            notificationCountModel= [[NotificationCountModel alloc] initWithDictionary:data error:nil];
            notificationCount=notificationCountModel.NotificatioTotal[[ZERO integerValue]];
            if ([status.Error isEqualToString:kResultError]) {
                if ([status.Message isEqualToString:kResultMessage]) {
                NSString *str=[NSString stringWithFormat:@"%@.                          YOU HAVE                        %@ NEW IDEAS                 TO YOUR                          %@ BRIEFS.",[[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"],[[NSUserDefaults standardUserDefaults] valueForKey:@"NOTIFICATIONIDEA"],notificationCount.totalnotification];
                    lblNotificationCount.text=str;
                    [self->homeTableView reloadData];
                }
                else{
                    kCustomAlert(@"", status.Message, @"Ok");
                }
            }
            else{
                kCustomAlert(@"", status.Message, @"Ok");
            }
        } else {
            
        }
    }];

}
- (void)showToast{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_icon"]];
    HUD.delegate = self;
    HUD.labelText = @"Please Swipe";
    HUD.labelFont=[UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    HUD.detailsLabelText=@"Please swipe vertically to get latest Idea/Brief ";
    HUD.detailsLabelFont=[UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:3];
}
#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)settingBarButton{
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];

        if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]) {
            [cancelButton setFrame:CANCEL_BUTTON_FRAME6];

            [cancelButton setImage:[UIImage imageNamed:BACK_BUTTON_NAME6] forState:UIControlStateNormal];
            [cancelButton setImage:[UIImage imageNamed:BACK_BUTTON_NAME6] forState:UIControlStateSelected];
        }
        else{
            [cancelButton setFrame:CANCEL_BUTTON_FRAME];

            [cancelButton setImage:[UIImage imageNamed:BACK_BUTTON_NAME] forState:UIControlStateNormal];
            [cancelButton setImage:[UIImage imageNamed:BACK_BUTTON_NAME] forState:UIControlStateSelected];
        }
    
    [cancelButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = PPkCancel;
    [self.view addSubview:cancelButton];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]) {
        [addButton setFrame:ADD_BUTTON_FRAME6];
        [addButton setImage:[UIImage imageNamed:ADD_BUTTON_NAME6] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:ADD_BUTTON_NAME6] forState:UIControlStateSelected];
    }
    else{
        
        [addButton setFrame:ADD_BUTTON_FRAME];
        [addButton setImage:[UIImage imageNamed:ADD_BUTTON_NAME] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:ADD_BUTTON_NAME] forState:UIControlStateSelected];
    }
    

    [addButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    addButton.tag = PPkAddOrNext;
    [self.view addSubview:addButton];
}
-(void)removeButtons{
    for(UIView *view in self.view.subviews){
        if([view isMemberOfClass:[UIButton class]]){
            [allDataTableView removeFromSuperview];
            [(UIButton *)view removeFromSuperview];
        }
    }
}
- (void)settingBarMethod:(UIButton *)settingBtn{
    switch (settingBtn.tag) {
        case PPkCancel:(([PPUtilts sharedInstance].apiCall==kApiCallMyIdea)||([PPUtilts sharedInstance].apiCall==kApiCallMyBrief))?[self goToProfile]:[self.pagingScrollView setCurrentPage:0 animated:YES];
            [PPUtilts sharedInstance].apiCall=nil;
            [self removeButtons];
            break;
        case PPkAttachment:
            break;
        case PPkAddOrNext:[self addOverLay];
            break;
        default:
            break;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _btnLIB.frame=CGRectMake(20, self.view.frame.size.height-45, 45, 45);

    // Do any additional setup after loading the view from its nib.
}
-(void)addPageView{
    [self.pagingScrollView registerClass:[RGMPageView class] forCellReuseIdentifier:reuseIdentifier];
    // comment out for horizontal scrolling and indicator orientation (defaults)
    self.pagingScrollView.scrollDirection = RGMScrollDirectionVertical;
    self.pagingScrollView.pagingEnabled = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}


#pragma mark - RGMPagingScrollViewDatasource

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)tcOffset NS_AVAILABLE_IOS(5_0){
    float yValue = tcOffset->y;
    if(yValue > 0 && [self.pagingScrollView isScrollEnabled]){
         [self callWebServices];
         self.pagingScrollView.scrollEnabled = NO;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    
 
}
- (NSInteger)pagingScrollViewNumberOfPages:(RGMPagingScrollView *)pagingScrollView
{
    return numberOfPages;
}

- (UIView *)pagingScrollView:(RGMPagingScrollView *)pagingScrollView viewForIndex:(NSInteger)idx
{
    RGMPageView *view = (RGMPageView *)[pagingScrollView dequeueReusablePageWithIdentifer:reuseIdentifier forIndex:idx];
    switch (idx % 2) {
        case 0: {
            self->allDataTableView=nil;
            [self removeButtons];
            
            CGRect fr = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            self->homeTableView = [[UITableView alloc] initWithFrame:fr style:UITableViewStylePlain];
            self->homeTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            self->homeTableView.tag=2000;
            [self updateFrame];

            
            [view addSubview:self->homeTableView];
            
           // [self.pagingScrollView setCurrentPage:0];
            
            
            self->homeTableView.delegate = self;
            self->homeTableView.dataSource = self;
            self->homeTableView.scrollEnabled=NO;
            [self->homeTableView setBackgroundColor:[UIColor PPBackGroundColor]];


            
            isAttachment = NO;
            self.attachmentImage = [[UIImageView alloc] initWithFrame:ATTACHED_IMAGE_FRAME];
            [PPUtilts sharedInstance].apiCall=nil;
            
            [self->homeTableView reloadData];
            
            break;
            
        }
        case 1: {
            self->homeTableView=nil;
            CGRect fr = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            self->allDataTableView = [[UITableView alloc] initWithFrame:fr style:UITableViewStylePlain];
            self->allDataTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            self->allDataTableView.tag=2001;
            
            
            [view addSubview:self->allDataTableView];
            
            
           // [self.pagingScrollView setCurrentPage:1];

            
            self->allDataTableView.delegate = self;
            self->allDataTableView.dataSource = self;
            [self->allDataTableView setBackgroundColor:[UIColor PPBackGroundColor]];
            
            isAttachment = NO;
            self.attachmentImage = [[UIImageView alloc] initWithFrame:ATTACHED_IMAGE_FRAME];
            if (![PPUtilts sharedInstance].apiCall) {
                [PPUtilts sharedInstance].apiCall=kApiCallLatestIdeaBrief;
            }
            //[self callWebServices];
           
            [self->allDataTableView reloadData];

            break;
        }
    }
    
    return view;
}

#pragma mark - RGMPagingScrollViewDelegate

- (void)pagingScrollView:(RGMPagingScrollView *)pagingScrollView scrolledToPage:(NSInteger)idx
{
    if (idx==0) {
        self.pagingScrollView.scrollEnabled = YES;
    }
    else{
        self.pagingScrollView.scrollEnabled = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self addPageView];
    if (GET_USERID) {
        [self getNotificationCount];
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FIRSTLOGIN"]) {
            notificationView.hidden=NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FIRSTLOGIN"];
        }
        else{
            notificationView.hidden=YES;
        }
    }
    [self updateFrame];
    [self.pagingScrollView reloadData];
    
    if ([PPUtilts sharedInstance].apiCall) {
        [self callWebServices];
        if (([PPUtilts sharedInstance].apiCall==kApiCallMyBrief)||([PPUtilts sharedInstance].apiCall==kApiCallMyIdea)||([PPUtilts sharedInstance].apiCall==kApiCallTagSearch)||([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief)) {
            [self->homeTableView setHidden:YES];
            [self->allDataTableView setHidden:NO];
            [self.pagingScrollView setCurrentPage:1 animated:YES];
        }
    }
    else{
        [self.pagingScrollView setCurrentPage:0 animated:YES];
        [self->homeTableView setHidden:NO];

    }

    if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]) {
        imageArray    = ImageArray6;
        
    }
    else{
        imageArray    = ImageArray;
        
    }
    cellTitleText = CellTitleText;
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.view setBackgroundColor:[UIColor PPBackGroundColor]];
    
    
     [self->homeTableView setContentOffset:self->homeTableView.contentOffset animated:NO];
     [self.view  setAlpha:1.0f];

   
    [self.view setBackgroundColor:[UIColor PPBackGroundColor]];
}

-(void)updateFrame{
    [self.pagingScrollView scrollRectToVisible:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height) animated:YES];
    if ([PPUtilts isIPad]) {
        self->homeTableView.frame=CGRectMake(10, 540, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }
    else{
    if ([PPUtilts isiPhone5]) {
        self->homeTableView.frame=CGRectMake(10, 215, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-215);
    }
    else if ([PPUtilts isiPhone6]){
        self->homeTableView.frame=CGRectMake(10, 205, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-205);
    }
    else if ([PPUtilts isiPhone6Plus]){
        self->homeTableView.frame=CGRectMake(10, 275, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-275);
    }
    else{
        self->homeTableView.frame=CGRectMake(10, 130, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-130);
    }
 }
}

//-----------------------------------Get Parameters for the respective web services-------------------------------------------------------
-(NSDictionary*)getParameters{
    return  ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief)?(parameters = @{kApiCall:kApiCallLatestIdeaBrief}):([PPUtilts sharedInstance].apiCall==kApiCallMyIdea)?(parameters = @{kApiCall:kApiCallMyIdea,kUserid:GET_USERID}):([PPUtilts sharedInstance].apiCall==kApiCallMyBrief)?(parameters = @{kApiCall:kApiCallMyBrief,kUserid:GET_USERID}):(parameters = @{kApiCall:kApiCallTagSearch,kTag:[PPUtilts sharedInstance].tagSearch});
}

//------------------------------------Set data to models-----------------------------------------------------------------------------------
-(void)setModels:(id)responseObject{
    ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief)?(ibModel = [[IBModel alloc] initWithDictionary:responseObject error:nil]):([PPUtilts sharedInstance].apiCall==kApiCallMyIdea)?(myIdeaModel = [[MyIdeaModel alloc] initWithDictionary:responseObject error:nil]):([PPUtilts sharedInstance].apiCall==kApiCallMyBrief)?(myBriefModel = [[MyBriefModel alloc] initWithDictionary:responseObject error:nil]):(tagModel = [[TagSearchModel alloc] initWithDictionary:responseObject error:nil]);
    
    statusModel = [[StatusModel alloc] initWithDictionary:responseObject error:nil];
    status = statusModel.StatusArr[[ZERO integerValue]];
}
-(void)callWebServices{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = PLEASE_WAIT;
    parameters=[self getParameters];
    AFNInjector *objAFN = [AFNInjector new];
    [objAFN parameters:parameters completionBlock:^(NSArray *data, NSError *error) {
        if(!error) {
            [self setModels:data];
            if ([status.Error isEqualToString:kResultError]) {
                if ([status.Message isEqualToString:kResultMessage]) {
                   [self->allDataTableView setHidden:NO];
                    [self->allDataTableView reloadData];
                }
                else{
                    kCustomAlert(@"", status.Message, @"Ok");
                }
            }
            else{
                kCustomAlert(@"", status.Message, @"Ok");
            }
            [self settingBarButton];
            [hud hide:YES];
        } else {
            [self settingBarButton];
            [hud hide:YES];
        }
    }];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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
    if (self->homeTableView) {
    return [cellTitleText count];    //count number of row from counting array hear cataGorry is An Array
    }
    else{
         return  ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief)?ibModel.LatestIdeaBrief.count:([PPUtilts sharedInstance].apiCall==kApiCallMyIdea)?myIdeaModel.MyIdea.count:([PPUtilts sharedInstance].apiCall==kApiCallMyBrief)?myBriefModel.MyBrief.count:tagModel.TagSearch.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==2000) {
    NSString *CellIdentifier = kStaticIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView setBackgroundColor:[UIColor PPBackGroundColor]];
    [cell.imageView setImage:[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]]];
    cell.textLabel.text = [cellTitleText objectAtIndex:indexPath.row];

    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    }
    else{
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
           if (indexPath.row==4){
            if ([status.Error isEqualToString:kResultError]) {
                if ([status.Message isEqualToString:kResultMessage]) {
                    notificationCount=notificationCountModel.NotificatioTotal[[ZERO integerValue]];
                    [[NSUserDefaults standardUserDefaults] setValue:notificationCount.totalnotification forKey:@"NOTIFICATION"];
                    if ([notificationCount.totalnotification integerValue]>0) {
                        [badge removeFromSuperview];
                        [UIApplication sharedApplication].applicationIconBadgeNumber=[[[NSUserDefaults standardUserDefaults] valueForKey:@"NOTIFICATION"] integerValue];
                        badge = [CustomBadge customBadgeWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"NOTIFICATION"] withStyle:[BadgeStyle oldStyle]];
                        if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]){
                            badge.frame=CGRectMake(60, -2, 30, 30);
                        }
                        else{
                            badge.frame=CGRectMake(48, -1, 25, 25);
                        }
                        [badge bringSubviewToFront:cell.contentView];
                        [cell.contentView  addSubview:badge];
                }
                    else{
                        [badge removeFromSuperview];
                    }
            }
            
        }
            
    }
}

  return cell;
    }
    
    else{
        
        NSString *CellIdentifier = kStaticIdentifier;
        LatestIBCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:kStaticIdentifier owner:self options:nil]lastObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief)?(ibModelDetails = ibModel.LatestIdeaBrief[indexPath.row]):([PPUtilts sharedInstance].apiCall==kApiCallMyIdea)?(ibModelDetails = myIdeaModel.MyIdea[indexPath.row]):([PPUtilts sharedInstance].apiCall==kApiCallMyBrief)?(ibModelDetails = myBriefModel.MyBrief[indexPath.row]):(ibModelDetails = tagModel.TagSearch[indexPath.row]);
        
        
        if ([PPUtilts isIPad]) {
            cell.lblHeading.font=[UIFont boldSystemFontOfSize:70.0f];
        }
        cell.lblHeading.numberOfLines=5;
        cell.lblHeading.lineBreakMode=NSLineBreakByCharWrapping;
        
        cell.lblHeading.text=ibModelDetails.headline;

        [cell.lblHeading sizeToFit];
        cell.lblTag.text=ibModelDetails.tag;
        isHot  =[ibModelDetails.is_hot  isEqualToString:BOOL_YES];
        isBrief=[ibModelDetails.is_brief isEqualToString:BOOL_YES];
        strColorType=ibModelDetails.color_code;
        
        UIImageView *imgIdea=(UIImageView *)[cell.contentView viewWithTag:PP201];
        UIImageView *imgBrief=(UIImageView *)[cell.contentView viewWithTag:PP202];
        UIImageView *imgHot=(UIImageView *)[cell.contentView viewWithTag:PP203];
        
        lblHeight=(UILabel *)[cell.contentView viewWithTag:1000];
        
        typedef void (^CaseBlockForColor)();
        
        NSDictionary *colorType = @{
                                    
                                    R:
                                        ^{[cell setBackgroundColor:[UIColor    PPRedColor]];
                                            if (indexPath.row==0) {
                                                [self->allDataTableView setBackgroundColor:[UIColor    PPRedColor]];
                                            }
                                            cell.lblHeading.textColor=[UIColor whiteColor];
                                            cell.lblTag.textColor=[UIColor whiteColor];
                                            imgIdea.hidden=NO;
                                            if (isHot) {
                                                imgHot.hidden =NO;
                                                imgIdea.frame=imgBrief.frame;
                                            }
                                            else{
                                                imgIdea.frame=imgHot.frame;
                                            }
                                        },
                                    Y:
                                        ^{[cell setBackgroundColor:[UIColor    PPYellowColor]];
                                            if (indexPath.row==0) {
                                                [self->allDataTableView setBackgroundColor:[UIColor    PPYellowColor]];
                                                
                                            }
                                            imgIdea.hidden=NO;
                                            imgBrief.hidden=NO;
                                            if (isHot){imgHot.hidden =NO;}
                                            else{imgIdea.frame=imgBrief.frame;imgBrief.frame=imgHot.frame;}
                                            
                                        },
                                    G:
                                        ^{ [cell setBackgroundColor:[UIColor    PPGreenColor]];
                                            if (indexPath.row==0) {
                                                [self->allDataTableView setBackgroundColor:[UIColor    PPGreenColor]];
                                            }
                                            imgIdea.hidden=NO;
                                            imgBrief.hidden=NO;
                                            
                                            CGRect frame = imgBrief.frame;
                                            imgBrief.frame=imgIdea.frame;
                                            imgIdea.frame=frame;
                                            
                                            if (isHot) {imgHot.hidden =NO;}
                                            else{
                                                imgBrief.frame=imgIdea.frame;
                                                imgIdea.frame=imgHot.frame;
                                            }
                                        },
                                    B:
                                        ^{ [cell setBackgroundColor:[UIColor    PPBlueColor]];
                                            if (indexPath.row==0) {
                                                [self->allDataTableView setBackgroundColor:[UIColor    PPBlueColor]];
                                            }
                                            imgBrief.hidden=NO;
                                            if (isHot) {imgHot.hidden =NO;}
                                            else{imgBrief.frame=imgHot.frame;}
                                        }
                                    };
        
        ((CaseBlockForColor)colorType[strColorType])(); // invoke the correct block of code
        
        return cell;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self->homeTableView) {
        if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]) {
            return (indexPath.row==0)?85:(indexPath.row==5)?116:65;
        }
        else{
            return (indexPath.row==0)?kCellHeightAtIndexZero:(indexPath.row==5)?85:kCellHeight;
        }
    }
    else{
        return lblHeight.frame.size.height+60;
        [self->allDataTableView beginUpdates];
        [self->allDataTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self->allDataTableView endUpdates];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==2000) {
    switch (indexPath.row) {

        case PPkHomeViewController:
            break;
        case PPkCreateIdeaViewController:[self goToCreateIdeaBriefsWith:YES];
            break;
        case PPkCreateBriefViewController:[self goToCreateIdeaBriefsWith:NO];
            break;
        case PPkSearchViewController:[self goToSearch];
            break;
        case PPkProfileViewController:[self goToProfile];
            break;
        case PPkLatestIdeasBrifes:
            [self.pagingScrollView setCurrentPage:1 animated:YES];
            [PPUtilts sharedInstance].apiCall=kApiCallLatestIdeaBrief;
            [self callWebServices];
            break;
        default:
            break;
            
    }
    }
    else if(tableView.tag==2001){
        ExpendableTableViewController *obj=[ExpendableTableViewController new];
        
        ([PPUtilts sharedInstance].apiCall==kApiCallLatestIdeaBrief)?(ibModelDetails = ibModel.LatestIdeaBrief[indexPath.row]):([PPUtilts sharedInstance].apiCall==kApiCallMyIdea)?(ibModelDetails = myIdeaModel.MyIdea[indexPath.row]):([PPUtilts sharedInstance].apiCall==kApiCallMyBrief)?(ibModelDetails = myBriefModel.MyBrief[indexPath.row]):(ibModelDetails = tagModel.TagSearch[indexPath.row]);
        
        [PPUtilts sharedInstance].colorCode=ibModelDetails.color_code;
        [PPUtilts sharedInstance].LatestIDId=ibModelDetails.id;
        [PPUtilts sharedInstance].UniversalApi=[PPUtilts sharedInstance].apiCall;
        [PPUtilts sharedInstance].apiCall=kApiCallDetail;
        [self.navigationController pushViewController:obj animated:YES];
    }
    else{
        [self.pagingScrollView setCurrentPage:1 animated:YES];
    }
    
}

-(void)goToProfile{
    ProfileViewController *objProfile = [ProfileViewController new];
    [PPUtilts sharedInstance].apiCall=nil;
    [self.navigationController pushViewController:objProfile animated:YES];
}
-(void)goToSearch{
    SearchViewController *objSearch= [SearchViewController new];
    [self.navigationController pushViewController:objSearch animated:YES];
}
-(void)goToCreateIdeaBriefsWith:(BOOL)NavigationType{
    CreateIdea_BriefViewController *objCreateIdea = [CreateIdea_BriefViewController new];
    [objCreateIdea setIsIdeaSubmitScreen:NavigationType];
    [self.navigationController pushViewController:objCreateIdea animated:YES];
}
- (IBAction)btnCancel:(id)sender {
    NotificationViewController *objNotification = [NotificationViewController new];
    [self.navigationController pushViewController:objNotification animated:YES];
}

//-----------------------------------------OVERLAY---------------------------------------------
-(void)addOverLay{
    tmpOverlayObj = [[OverlayView alloc] initOverlayView];
    [tmpOverlayObj setDelegate:self];
    [self.view addSubview:tmpOverlayObj];
    [tmpOverlayObj createOrAnswerIB:NO];
}
- (void)createIdea{
    CreateIdea_BriefViewController *objCreateIdea = [CreateIdea_BriefViewController new];
    [objCreateIdea setIsIdeaSubmitScreen:YES];
    [objCreateIdea setIsCurrentControllerPresented:YES];
    [tmpOverlayObj closeIBView:nil];
    [self presentViewController:objCreateIdea animated:YES completion:^{[PPUtilts sharedInstance].apiCall=nil;}];
}
- (void)createBrief{
    CreateIdea_BriefViewController *objCreateIdea = [CreateIdea_BriefViewController new];
    [objCreateIdea setIsIdeaSubmitScreen:NO];
    [objCreateIdea setIsCurrentControllerPresented:YES];
    [tmpOverlayObj closeIBView:nil];
    [self presentViewController:objCreateIdea animated:YES completion:^{[PPUtilts sharedInstance].apiCall=nil;}];
}

@end
