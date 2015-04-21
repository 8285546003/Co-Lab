//
//  HomeViewController.h
//  iBrief
//
//  Created by Magnon International on 14/01/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateIdea_BriefViewController.h"

@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate>
- (IBAction)btnCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLIB;
@property (weak, nonatomic) IBOutlet UIView   *viewLIB;
@property (weak, nonatomic) IBOutlet UILabel   *lblLIB;


@end
