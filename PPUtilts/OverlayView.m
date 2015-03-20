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
- (void)renderingScreenAccordingToFrame{
    [self setAlpha:0.0f];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.backgroundColor = [UIColor blackColor];
    [self setFrame:CGRectMake(0, 0, screenWidth, screenHeight+100)];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self setAlpha:0.9f];
    } completion:^(BOOL finished) {
        takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [takePhotoBtn setFrame:CGRectMake( 40, screenHeight - 160, 150, 40)];
        [takePhotoBtn setImage:[UIImage imageNamed:@"TakeAPhoto.png"] forState:UIControlStateNormal];
        [takePhotoBtn addTarget:self.delegate action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        takePhotoBtn.alpha = 1.0f;
        [self addSubview:takePhotoBtn];
        
        galaryPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [galaryPhotoBtn setFrame:CGRectMake( 40, screenHeight - 110, 150, 40)];
        [galaryPhotoBtn setImage:[UIImage imageNamed:@"ChooseAPhoto.png"] forState:UIControlStateNormal];
        [galaryPhotoBtn addTarget:self.delegate action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
        galaryPhotoBtn.alpha = 1.0f;
        [self addSubview:galaryPhotoBtn];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake( screenWidth - 110, screenHeight - 110, 40, 40)];
        [closeBtn setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeMethod:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.alpha = 1.0f;
        [self addSubview:closeBtn];

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
- (void)createOrAnswerIB:(BOOL)Answer{
    
    [self setAlpha:0.0f];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.backgroundColor = [UIColor blackColor];
    [self setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self setAlpha:0.9f];
    } completion:^(BOOL finished) {
        
        if (Answer) {
            answerBriefBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [answerBriefBtn setFrame:CGRectMake( 40, screenHeight - 80, 150, 40)];
            [answerBriefBtn setImage:[UIImage imageNamed:@"answer_brief.png"] forState:UIControlStateNormal];
            [answerBriefBtn addTarget:self.delegate action:@selector(answerIB) forControlEvents:UIControlEventTouchUpInside];
            answerBriefBtn.alpha = 1.0f;
            [self addSubview:answerBriefBtn];
        }
        createIdeaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [createIdeaBtn setFrame:CGRectMake( 40, screenHeight - 180, 150, 40)];
        [createIdeaBtn setImage:[UIImage imageNamed:@"createnewidea.png"] forState:UIControlStateNormal];
        [createIdeaBtn addTarget:self.delegate action:@selector(createIdea) forControlEvents:UIControlEventTouchUpInside];
        createIdeaBtn.alpha = 1.0f;
        [self addSubview:createIdeaBtn];
        
        createBriefBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [createBriefBtn setFrame:CGRectMake( 40, screenHeight - 130, 150, 40)];
        [createBriefBtn setImage:[UIImage imageNamed:@"newbreif.png"] forState:UIControlStateNormal];
        [createBriefBtn addTarget:self.delegate action:@selector(createBrief) forControlEvents:UIControlEventTouchUpInside];
        createIdeaBtn.alpha = 1.0f;
        [self addSubview:createBriefBtn];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake( screenWidth - 110, screenHeight - 80, 40, 40)];
        [closeBtn setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeIBView:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.alpha = 1.0f;
        [self addSubview:closeBtn];
        
    }];
    
    
}
- (void)closeIBView:(UIButton *)sender{
    
    [createIdeaBtn removeFromSuperview];
    [createBriefBtn removeFromSuperview];
    [answerBriefBtn removeFromSuperview];
    [closeBtn removeFromSuperview];
    [UIView animateWithDuration:1.0 animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}



@end
