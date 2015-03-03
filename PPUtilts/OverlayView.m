//
//  OverlayView.m
//  Co\Lab 
//
//  Created by magnon on 23/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "OverlayView.h"


@implementation OverlayView

- (id)initOverlayView{
    if (self = [super init]) {
        
        return self;
    }
    return nil;
}
- (void)renderingScreenAccordingToFrame:(UIView *)tmpView{
    [self setAlpha:0.0f];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.backgroundColor = [UIColor blackColor];
    [self setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self setAlpha:0.9f];
    } completion:^(BOOL finished) {
        takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [takePhotoBtn setFrame:CGRectMake( 40, screenHeight - 110, 150, 40)];
        [takePhotoBtn setImage:[UIImage imageNamed:@"TakeAPhoto.png"] forState:UIControlStateNormal];
        [takePhotoBtn addTarget:self.delegate action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        takePhotoBtn.alpha = 1.0f;
        [tmpView addSubview:takePhotoBtn];
        
        galaryPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [galaryPhotoBtn setFrame:CGRectMake( 40, screenHeight - 160, 150, 40)];
        [galaryPhotoBtn setImage:[UIImage imageNamed:@"CHooseAPhoto.png"] forState:UIControlStateNormal];
        [galaryPhotoBtn addTarget:self.delegate action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
        galaryPhotoBtn.alpha = 1.0f;
        [tmpView addSubview:galaryPhotoBtn];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake( screenWidth - 80, screenHeight - 110, 40, 40)];
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
- (void)createIdea{
    
}
- (void)createBrief{
    
    
}







- (void)createOrAnswerIB:(UIView *)inView With:(BOOL)Answer{
    
    [self setAlpha:0.0f];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.backgroundColor = [UIColor blackColor];
    [self setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self setAlpha:0.9f];
    } completion:^(BOOL finished) {
        
        createIdeaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [createIdeaBtn setFrame:CGRectMake( 40, screenHeight - 110, 150, 40)];
        [createIdeaBtn setImage:[UIImage imageNamed:@"createnewidea.png"] forState:UIControlStateNormal];
        [createIdeaBtn addTarget:self.delegate action:@selector(createIdea) forControlEvents:UIControlEventTouchUpInside];
        createIdeaBtn.alpha = 1.0f;
        [inView addSubview:createIdeaBtn];
        
        createBriefBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [createBriefBtn setFrame:CGRectMake( 40, screenHeight - 160, 150, 40)];
        [createBriefBtn setImage:[UIImage imageNamed:@"newbreif.png"] forState:UIControlStateNormal];
        [createBriefBtn addTarget:self.delegate action:@selector(createBrief) forControlEvents:UIControlEventTouchUpInside];
        galaryPhotoBtn.alpha = 1.0f;
        [inView addSubview:createBriefBtn];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake( screenWidth - 80, screenHeight - 110, 40, 40)];
        [closeBtn setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeIBView:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.alpha = 1.0f;
        [inView addSubview:closeBtn];
        
    }];
    
    
}
- (void)closeIBView:(UIButton *)sender{
    
    [createIdeaBtn removeFromSuperview];
    [createBriefBtn removeFromSuperview];
    [closeBtn removeFromSuperview];
    [UIView animateWithDuration:1.0 animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}



@end
