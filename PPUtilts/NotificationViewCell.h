//
//  NotificationViewCell.h
//  Co\Lab 
//
//  Created by magnon on 03/03/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel     *lblNotificationDescription;
@property(nonatomic,weak)IBOutlet UILabel     *lblTime;
@end
