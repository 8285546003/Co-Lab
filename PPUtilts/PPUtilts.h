//
//  PPUtilts.h
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL @"http://miprojects2.com.php53-6.ord1-1.websitetestlink.com/colab/api/version2"
#define BASE_URL_IMAGE @"http://miprojects2.com.php53-6.ord1-1.websitetestlink.com/colab/"


#define kCustomAlert(title,msg,ok) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil] show]
#define kLoginAlert(title,msg,ok,retry) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:ok otherButtonTitles:retry, nil] show]



#define CANCEL_BUTTON_FRAME      CGRectMake(20, self.view.bounds.size.height - 45, 45, 45)
#define CANCEL_BUTTON_NAME       @"Close_Image.png"
#define CANCEL_BUTTON_NAME_WHITE @"white_arrow.png"
#define BACK_BUTTON_NAME         @"Pre_Image.png"

#define ATTACHMENT_BUTTON_FRAME CGRectMake(self.view.frame.size.width-135, self.view.frame.size.height - 45, 45, 45)
#define ATTACHMENT_BUTTON_NAME  @"Attachment_Image.png"

#define ADD_BUTTON_FRAME        CGRectMake(self.view.frame.size.width -65, self.view.frame.size.height - 45, 45, 45)
#define ADD_BUTTON_NAME         @"plus_trans.png"


#define ATTACHED_IMAGE_FRAME    CGRectMake(0, 0, self.view.frame.size.width, 200)

#define DETAIL_LABLE_FRAME      CGRectMake(40,470, 244,200)


#define kheightForRowAtIndexPath 200.0f
#define kCellHeightAtIndexZero   70
#define kCellHeightAtIndexfive   125
#define kCellHeight              50

#define kCellHeightWithImage     750
#define kCellHeightWithoutImage  600




#define GET_USERID              [[NSUserDefaults standardUserDefaults] valueForKey:@"USERID"]

#define CONTENT_TYPE_HTML       [NSSet setWithObject:@"text/html"]
#define PLEASE_WAIT             @"Please wait..."

#define     R                   @"R"
#define     Y                   @"Y"
#define     G                   @"G"
#define     B                   @"B"

#define ImageArray @[@"CoAppImage.png",@"my_ideas.png",@"my_brief.png",@"search.png",@"profile_black.png"]
#define  CellTitleText  @[@" CO\\Lab",@" Create New Idea",@" Create New Briefs",@" Search",@" Profile"]

#define imageArrayProfile @[@"profile.png",@"my_ideas.png",@"my_brief.png",@"Notification.png",@"logout.png"]
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
