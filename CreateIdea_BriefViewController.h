//
//  CreateIdea&BriefViewController.h
//  Co\Lab 
//
//  Created by magnon on 24/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"
#import "NoteView.h"
#import "UIColor+PPColor.h"
#import "AFHTTPRequestOperationManager.h"
#import "PPUtilts.h"


@interface CreateIdea_BriefViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    IBOutlet UIScrollView *baseScrollView;
    UILabel *titleCharCountLbl;
    UILabel *dicCharCountLbl;
    OverlayView *tmpOverlayObj;
    UIAlertView *errorAlert;
    UIImageView *attachmentImage;
    
    NSMutableDictionary *mainDataDictionary;
    
    BOOL isAttachment;
    CGFloat height;
    
    
    BOOL isIdeaSubmitScreen;
   
}
@property (nonatomic, assign) BOOL isIdeaSubmitScreen;
@property (nonatomic, strong) NSMutableDictionary *mainDataDictionary;
@property (nonatomic, strong) IBOutlet UIScrollView *baseScrollView;
@property (nonatomic, strong) UIImageView *attachmentImage;
@end
