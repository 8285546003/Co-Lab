//
//  NoteView.m
//  iBrief
//
//  Created by Magnon International on 14/01/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "NoteView.h"
#import "PPUtilts.h"

@implementation NoteView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.6f alpha:1.0f];
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont boldSystemFontOfSize:34.0f];
        
    }
    return self;
}

- (void)setFontName:(NSString *)fName size:(NSInteger)size{
    self.font = [UIFont fontWithName:fName size:size];

}

@end