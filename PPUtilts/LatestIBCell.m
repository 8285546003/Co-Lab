//
//  LatestIBCell.m
//  Co\Lab 
//
//  Created by magnon on 25/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "LatestIBCell.h"

@implementation LatestIBCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.lblDescription sizeToFit];
}

@end
