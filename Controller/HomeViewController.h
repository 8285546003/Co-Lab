//
//  HomeViewController.h
//  iBrief
//
//  Created by Magnon International on 14/01/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateIdea_BriefViewController.h"

#import "NoteView.h"
#import "OverlayView.h"

@class RGMPagingScrollView;
@interface HomeViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,OverlayViewDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate>
- (IBAction)btnCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLIB;
@property (weak, nonatomic) IBOutlet UIView   *viewLIB;

@property (nonatomic, strong) IBOutlet RGMPagingScrollView *pagingScrollView;


@property (nonatomic, strong) NoteView *note;
@property (nonatomic, strong) UIImageView *attachmentImage;
@property (nonatomic, assign) BOOL isCurrentControllerPresented;

@end
