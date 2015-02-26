//
//  OverlayView.m
//  Co\Lab 
//
//  Created by magnon on 23/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "OverlayView.h"


@implementation OverlayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initOverlayView{
    if (self = [super init]) {
        
        return self;
    }
    return nil;
}
- (void)renderingScreenAccordingToFrame :(UIView *)tmpView isBrief:(BOOL)Brief{
    [self setAlpha:0.0f];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.backgroundColor = [UIColor blackColor];
    [self setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self setAlpha:0.9f];
    } completion:^(BOOL finished) {
        if (Brief) {
            answerBriefBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [answerBriefBtn setFrame:CGRectMake( 40, screenHeight - 180, 150, 40)];
            [answerBriefBtn setImage:[UIImage imageNamed:@"CHooseAPhoto.png"] forState:UIControlStateNormal];
            [answerBriefBtn addTarget:self.delegate action:@selector(answerBrief) forControlEvents:UIControlEventTouchUpInside];
            answerBriefBtn.alpha = 1.0f;
            [tmpView addSubview:answerBriefBtn];
        }
        takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [takePhotoBtn setFrame:CGRectMake( 40, screenHeight - 80, 150, 40)];
        [takePhotoBtn setImage:[UIImage imageNamed:@"TakeAPhoto.png"] forState:UIControlStateNormal];
        [takePhotoBtn addTarget:self.delegate action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        takePhotoBtn.alpha = 1.0f;
        [tmpView addSubview:takePhotoBtn];
        
        galaryPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [galaryPhotoBtn setFrame:CGRectMake( 40, screenHeight - 130, 150, 40)];
        [galaryPhotoBtn setImage:[UIImage imageNamed:@"CHooseAPhoto.png"] forState:UIControlStateNormal];
        [galaryPhotoBtn addTarget:self.delegate action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
        galaryPhotoBtn.alpha = 1.0f;
        [tmpView addSubview:galaryPhotoBtn];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake( screenWidth - 80, screenHeight - 80, 40, 40)];
        [closeBtn setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeMethod:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.alpha = 1.0f;
        [tmpView addSubview:closeBtn];

    }];
 
    
}
- (void)closeMethod:(UIButton *)sender{
    [takePhotoBtn removeFromSuperview];
    [galaryPhotoBtn removeFromSuperview];
    [closeBtn removeFromSuperview];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
- (void)takePhoto{
    NSLog(@"take photo");
    
}
- (void)selectPhoto{
    NSLog(@"select photo");
}
- (void)answerBrief{
    NSLog(@"answer brief");
}

@end
