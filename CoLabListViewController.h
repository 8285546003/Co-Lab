//
//  CoLabListViewController.h
//  Co\Lab 
//
//  Created by magnon on 26/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteView.h"
#import "OverlayView.h"

@interface CoLabListViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,OverlayViewDelegate>{
    __weak IBOutlet UITableView *latestIdeaBrifTableView;
    UIImageView *attachmentImage;
    BOOL isAttachment;
    OverlayView *tmpOverlayObj;
}

@property (nonatomic, strong) NoteView *note;
@property (nonatomic, strong) UIImageView *attachmentImage;
@property (nonatomic, strong) NSMutableDictionary *allData;
@property (nonatomic, weak) IBOutlet UITableView *allDataTableView;




@end
