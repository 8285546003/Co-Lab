//
//  PPUtilts.h
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL @"http://miprojects2.com.php53-6.ord1-1.websitetestlink.com/colab/api/version4"
#define BASE_URL_IMAGE @"http://miprojects2.com.php53-6.ord1-1.websitetestlink.com/colab/"


#define kCustomAlert(title,msg,ok) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil] show]
#define kLoginAlert(title,msg,ok,retry) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:ok otherButtonTitles:retry, nil] show]



#define CANCEL_BUTTON_FRAME       CGRectMake(20, self.view.bounds.size.height - 45, 45, 45)
#define CANCEL_BUTTON_FRAME6       CGRectMake(20, self.view.bounds.size.height - 52, 52, 52)

#define CANCEL_BUTTON_FRAME6      CGRectMake(20, self.view.bounds.size.height - 52, 52, 52)
#define ADD_BUTTON_FRAME6         CGRectMake(self.view.frame.size.width -85, self.view.frame.size.height - 52, 52, 52)
#define ATTACHMENT_BUTTON_FRAME6 CGRectMake(self.view.frame.size.width-150, self.view.frame.size.height - 52, 52, 52)
#define ADD_BUTTON_NAME6          @"plus6.png"
#define BACK_BUTTON_NAME6         @"pre6.png"


#define CANCEL_BUTTON_NAME6       @"cancel6.png"
#define NEXT_BUTTON_NAME6         @"next6.png"
#define ATTACHMENT_BUTTON_NAME6   @"attachment6.png"



#define CANCEL_BUTTON_NAME       @"cancel.png"
#define CANCEL_BUTTON_NAME_WHITE @"preWhite.png"
#define BACK_BUTTON_NAME         @"pre.png"
#define NEXT_BUTTON_NAME         @"next.png"

#define ATTACHMENT_BUTTON_FRAME CGRectMake(self.view.frame.size.width-115, self.view.frame.size.height - 45, 45, 45)
#define ATTACHMENT_BUTTON_NAME  @"attachment.png"

#define ADD_BUTTON_FRAME        CGRectMake(self.view.frame.size.width -65, self.view.frame.size.height - 45, 45, 45)
#define ADD_BUTTON_NAME         @"plus.png"


#define ATTACHED_IMAGE_FRAME    CGRectMake(0, 0, self.view.frame.size.width, 200)

#define DETAIL_LABLE_FRAME      CGRectMake(40,470, 244,200)


#define kheightForRowAtIndexPath 200.0f
#define kCellHeightAtIndexZero   70
#define kCellHeightAtIndexfive   125
#define kCellHeight              50

#define kCellHeightWithImage     750
#define kCellHeightWithoutImage  500




#define GET_USERID              [[NSUserDefaults standardUserDefaults] valueForKey:@"USERID"]

#define CONTENT_TYPE_HTML       [NSSet setWithObject:@"text/html"]
#define PLEASE_WAIT             @"Please wait..."

#define     R                   @"R"
#define     Y                   @"Y"
#define     G                   @"G"
#define     B                   @"B"

#define ImageArray6 @[@"app_icon6.png",@"ideas6.png",@"brief6.png",@"search6.png",@"profile6.png",@"lib6.png"]


#define ImageArray @[@"app_icon.png",@"ideas.png",@"brief.png",@"search.png",@"profile.png",@"lib.png"]
#define  CellTitleText  @[@" CO\\Lab",@" Create new idea",@" Create new brief",@" Search",@" Profile",@" Latest Ideas & Brief"]


#define imageArrayProfile6 @[@"profile_white6.png",@"ideas6.png",@"briefT6.png",@"notification6.png",@"logout6.png"]


#define imageArrayProfile @[@"profile_white.png",@"ideaT.png",@"briefT.png",@"notification.png",@"logout.png"]
#define cellTitleProfile  @[@"Profile",@"My Ideas",@"My Briefs",@"Notifications",@"Log out"]


static NSString  *BOOL_NO                     =@"No";
static NSString  *BOOL_YES                    =@"Yes";
static NSString  *ZERO                        =@"0";

static NSString *kApiCall                    =@"apicall";

static NSString *kTag                        =@"tag";
static NSString *kUserid                     =@"user_id";
static NSString *kid                         =@"id";
static NSString *kColorCode                  =@"color_code";

static NSString *kApiCallLogin               =@"UserLogin";
static NSString *kApiCallCreateNewIdeaBrief  =@"CreateNewIdeaBrief";
static NSString *kApiCallLatestIdeaBrief     =@"LatestIdeaBrief";
static NSString *kApiCallTagSearch           =@"TagSearch";
static NSString *kApiCallMyBrief             =@"MyBrief";
static NSString *kApiCallMyIdea              =@"MyIdea";
static NSString *kApiCallSearchAuto          =@"SearchAuto";
static NSString *kApiCallDetail              =@"Detail";
static NSString *kApiCallLogOut              =@"LogOut";
static NSString *kApiCallNotifications       =@"NotificatioList";
static NSString *kApiCallNotificationsCount  =@"MyNotificationTotal";
static NSString *kApiCallNotificationsDetail =@"NotificationDetail";




static NSString *kResultMessage             =@"Success";
static NSString *kResultError               =@"false";
static NSString *kResultNoRecord            =@"No record found.";
static NSString *kResultRequestFailed       =@"Request fail please try again";

static NSString *kStaticIdentifier          =@"LatestIBCell";




typedef enum {
    
    PPkHomeViewController,
    PPkCreateIdeaViewController,
    PPkCreateBriefViewController,
    PPkSearchViewController,
    PPkProfileViewController,
    PPkLatestIdeasBrifes
    
}ControllerType;

typedef enum {
    
    PPkMyProfile,
    PPkMyIdeas,
    PPkMyBriefs,
    PPkMyNotifications,
    PPkLogOut,
    
}ProfileControllerType;

typedef enum{
    PPkCancel,
    PPkAttachment,
    PPkAddOrNext
} ActionType;

typedef enum{
    PPkHeader=101,
    PPkDescription,
    PPkTags
} TagType;

typedef enum{
    PP201=201,
    PP202,
    PP203,
    PP204
} ViewTagType;


@interface PPUtilts : NSObject
@property (nonatomic,retain)  NSString *deviceTocken;
@property (nonatomic, strong) NSString *colorCode;
@property (nonatomic, strong) NSString *LatestIDId;
@property (nonatomic, strong) NSString *apiCall;
@property (nonatomic, strong) NSString *tagSearch;
@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, strong) NSString *notification_send_time;

@property (nonatomic, strong) NSString *UniversalApi;





+ (instancetype)sharedInstance;
- (BOOL)connected;
- (BOOL)isNotificationViewHidden;
+ (BOOL)isiPhone4;
+ (BOOL)isiPhone5;
+ (BOOL)isiPhone6;
+ (BOOL)isiPhone6Plus;

+ (BOOL)isIPad;
+ (BOOL)isIPhone;

@end
