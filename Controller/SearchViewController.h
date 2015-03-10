//
//  SearchViewController.h
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITableView *allDataTableView;
@property (nonatomic, weak) IBOutlet UITextField *txtSearch;
@end
