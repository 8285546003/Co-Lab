//
//  PPUtilts.h
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL @"http://miprojects2.com.php53-6.ord1-1.websitetestlink.com/colab/api/version1"
#define BASE_URL_IMAGE @"http://miprojects2.com.php53-6.ord1-1.websitetestlink.com/colab/"


#define kCustomAlert(title,msg,ok) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:ok otherButtonTitles:nil, nil] show]


#define CANCEL_BUTTON_FRAME     CGRectMake(40, self.view.bounds.size.height - 60, 50, 50)
#define CANCEL_BUTTON_NAME      @"Close_Image.png"

#define ATTACHMENT_BUTTON_FRAME CGRectMake(self.view.frame.size.width-140, self.view.frame.size.height - 60, 50, 50)
#define ATTACHMENT_BUTTON_NAME  @"Attachment_Image.png"

#define ADD_BUTTON_FRAME        CGRectMake(self.view.frame.size.width - 90, self.view.frame.size.height - 60, 50, 50)
#define ADD_BUTTON_NAME         @"plus.png"


#define ImageArray @[@"CoAppImage.png",@"Create_New_Idea_Image.png",@"Create_New_Brief_Image.png",@"Search_Image.png",@"Profile_Image.png",@"Latest_Idea_And_Briefs.png"]
#define  CellTitleText  @[@" CO\\Lab",@"  Create New Idea",@"  Create New Briefs",@"  Search",@"  Profile",@"  Latest Idea & Brifes"]


static NSString *kApiCallLogin               =@"UserLogin";
static NSString *kApiCallCreateNewIdeaBrief  =@"CreateNewIdeaBrief";
static NSString *kApiCallLatestIdeaBrief     =@"LatestIdeaBrief";
static NSString *kApiCallTagSearch           =@"TagSearch";
static NSString *kApiCallMyBrief             =@"MyBrief";
static NSString *kApiCallMyIdea              =@"MyIdea";
static NSString *kApiCallSearchAuto          =@"SearchAuto";
static NSString *kApiCallDetail              =@"Detail";
static NSString *kApiCallLogOut              =@"LogOut";
static NSString *kApiCallNotifications       =@"Notifications";


static NSString *kResultMessage             =@"Success";
static NSString *kResultError               =@"false";
static NSString *kResultNoRecord            =@"No record found.";

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



typedef enum{
    R,
    Y,
    G,
    B
} CardType;

typedef enum {
    PPNoInternetConnection=-1005,
}ErrorCodeType;


@interface PPUtilts : NSObject
@property (nonatomic,retain)  NSString *deviceTocken;
@property (nonatomic,retain)  NSString *userID;
@property (nonatomic, strong) NSString *colorCode;
@property (nonatomic, strong) NSString *LatestIDId;
@property (nonatomic, strong) NSString *apiCall;
@property (nonatomic, strong) NSString *tagSearch;
+ (instancetype)sharedInstance;
- (BOOL)connected;
- (BOOL)isNotificationViewHidden;

+ (BOOL)isiPhone5;
+ (BOOL)isiPhone6;
+ (BOOL)isiPhone6Plus;
@end
