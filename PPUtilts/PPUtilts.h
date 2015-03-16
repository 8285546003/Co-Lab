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


#define kCustomErrorAlert [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Someting went wrong please connect to your WiFi/3G" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show]



#define CANCEL_BUTTON_FRAME      CGRectMake(10, self.view.bounds.size.height - 40, 50, 50)
#define CANCEL_BUTTON_NAME       @"Close_Image.png"
#define CANCEL_BUTTON_NAME_WHITE @"white_arrow.png"
#define BACK_BUTTON_NAME         @"Pre_Image.png"

#define ATTACHMENT_BUTTON_FRAME CGRectMake(self.view.frame.size.width-110, self.view.frame.size.height - 40, 50, 50)
#define ATTACHMENT_BUTTON_NAME  @"Attachment_Image.png"

#define ADD_BUTTON_FRAME        CGRectMake(self.view.frame.size.width - 60, self.view.frame.size.height - 40, 50, 50)
#define ADD_BUTTON_NAME         @"plus.png"


#define ATTACHED_IMAGE_FRAME    CGRectMake(0, 0, self.view.frame.size.width, 200)

#define DETAIL_LABLE_FRAME      CGRectMake(40,410, 230,162)


#define kheightForRowAtIndexPath 210.0f
#define kCellHeightAtIndexZero   100
#define kCellHeightAtIndexfive   125
#define kCellHeight              75

#define kCellHeightWithImage     700
#define kCellHeightWithoutImage  600
#define kCellHeightNormal        175




#define GET_USERID              [[NSUserDefaults standardUserDefaults] valueForKey:@"USERID"]

#define CONTENT_TYPE_HTML       [NSSet setWithObject:@"text/html"]
#define PLEASE_WAIT             @"Please wait..."

#define     R                   @"R"
#define     Y                   @"Y"
#define     G                   @"G"
#define     B                   @"B"

#define ImageArray @[@"CoAppImage.png",@"Create_New_Idea_Image.png",@"Create_New_Brief_Image.png",@"Search_Image.png",@"Profile_Image.png",@"Latest_Idea_And_Briefs.png"]
#define  CellTitleText  @[@" CO\\Lab",@"  Create New Idea",@"  Create New Briefs",@"  Search",@"  Profile",@"  Latest Idea & Brifes"]

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
    PP101=101,
    PP102,
    PP103
} ViewTagType;



//typedef enum{
//    R,
//    Y,
//    G,
//    B
//} CardType;

typedef enum {
    PPNoInternetConnection=-1005,
}ErrorCodeType;


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
@end
