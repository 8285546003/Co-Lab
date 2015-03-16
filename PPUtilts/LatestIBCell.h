//
//  LatestIBCell.h
//  Co\Lab 
//
//  Created by magnon on 25/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LatestIBCell : UITableViewCell
@property(nonatomic,retain)IBOutlet UILabel     *lblTag;
@property(nonatomic,retain)IBOutlet UILabel     *lblHeading;
@property(nonatomic,retain)IBOutlet UILabel     *lblDescription;
@property(nonatomic,retain)IBOutlet UIImageView *imgMain;
@property(nonatomic,retain)IBOutlet UIButton    *btnEmail;
@end
