//
//  CreateIdeaViewController.h
//  iBrief
//
//  Created by Magnon International on 15/01/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteView.h"
#import "RNExpandingButtonBar.h"
#import "OverlayView.h"

#define YELLOWCOLOUR [UIColor colorWithRed:239.0/255.0 green:227.0/255.0 blue:60.0/255.0 alpha:1];


@interface CreateIdeaViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
   __weak IBOutlet UITableView *ideaTableView;
    UIImageView *attachmentImage;
    BOOL isAttachment;
    
    NSArray *headerTitleArray;
    
    UILabel *titleCharCountLbl;
    UILabel *dicCharCountLbl;
    OverlayView *tmpOverlayObj;
    UIAlertView *errorAlert;
}

@property (nonatomic, strong) UILabel *titleCharCountLbl;
@property (nonatomic, strong) UILabel *dicCharCountLbl;

@property (nonatomic, strong) NoteView *note;
@property (nonatomic, strong) UIImageView *attachmentImage;
@end
