//
//  OverlayView.h
//  Co\Lab 
//
//  Created by magnon on 23/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OverlayViewDelegate <NSObject>

//- (void) photoFromCamraOrGalary;

@end

@interface OverlayView : UIView{
    NSInteger buttonType;
    UIButton *takePhotoBtn;
    UIButton *galaryPhotoBtn;
    UIButton *closeBtn;
    UIButton *createIdeaBtn;
    UIButton *createBriefBtn;
    UIButton *answerBriefBtn;
}

@property (nonatomic, weak) id <OverlayViewDelegate>delegate;

- (id)initOverlayView;
- (void)renderingScreenAccordingToFrame;

- (void)createOrAnswerIB:(BOOL)Answer;
- (void)closeIBView:(UIButton *)sender;

- (void)closeMethod:(UIButton *)sender;
- (void)takePhoto;
- (void)selectPhoto;

- (void)createIdea;
- (void)createBrief;
- (void)answerBrief;
@end
