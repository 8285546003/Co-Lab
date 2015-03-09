//
//  ExpendableTableViewController.h
//  Co\Lab 
//
//  Created by magnon on 25/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVTableView.h"
@interface ExpendableTableViewController : UIViewController<HVTableViewDelegate, HVTableViewDataSource>
@property (weak, nonatomic) IBOutlet HVTableView *table;
@end
