//
//  ExpendableTableViewController.h
//  Co\Lab 
//
//  Created by magnon on 25/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVTableView.h"
#import "OverlayView.h"
#import <MessageUI/MessageUI.h>

@interface ExpendableTableViewController : UIViewController<HVTableViewDelegate, HVTableViewDataSource,OverlayViewDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet HVTableView *table;
@property (retain, nonatomic) OverlayView *tmpOverlayObj;
//@property (nonatomic, assign) BOOL isCurrentControllerPresented;
@end
