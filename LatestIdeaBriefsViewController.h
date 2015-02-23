//
//  LatestIdeaBriefsViewController.h
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteView.h"
#import "RNExpandingButtonBar.h"
#define YELLOWCOLOUR [UIColor colorWithRed:239.0/255.0 green:227.0/255.0 blue:60.0/255.0 alpha:1];

@interface LatestIdeaBriefsViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    __weak IBOutlet UITableView *latestIdeaBrifTableView;
    UIImageView *attachmentImage;
    BOOL isAttachment;
}

@property (nonatomic, strong) NoteView *note;
@property (nonatomic, strong) UIImageView *attachmentImage;
@property (nonatomic, strong)NSMutableDictionary *allLatestIdeaAndBrief;


@end
