//
//  LatestIBCell.h
//  Co\Lab 
//
//  Created by magnon on 25/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LatestIBCell : UITableViewCell{
//    __weak IBOutlet UILabel     *lblTag;
//    __weak IBOutlet UIImageView *imgIdea;
//    __weak IBOutlet UIImageView *imgBrief;
//    __weak IBOutlet UIImageView *imgHot;
}
@property(nonatomic,retain)IBOutlet UILabel     *lblTag;
@property(nonatomic,retain)IBOutlet UILabel     *lblHeading;
@property(nonatomic,retain)IBOutlet UIImageView *imgIdea;
@property(nonatomic,retain)IBOutlet UIImageView *imgBrief;
@property(nonatomic,retain)IBOutlet UIImageView *imgHot;
@end
