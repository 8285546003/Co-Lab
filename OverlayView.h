//
//  OverlayView.h
//  Co\Lab 
//
//  Created by magnon on 23/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OverlayViewDelegate <NSObject>

- (void) photoFromCamraOrGalary;

@end

@interface OverlayView : UIView{
    NSInteger buttonType;
    UIButton *takePhotoBtn;
    UIButton *galaryPhotoBtn;
    UIButton *closeBtn;
    UIButton *answerBriefBtn;
}

@property (nonatomic, strong) id <OverlayViewDelegate>delegate;

- (id)initOverlayView;
- (void)renderingScreenAccordingToFrame :(UIView *)tmpView isBrief:(BOOL)Brief;
- (void)closeMethod:(UIButton *)sender;
- (void)takePhoto;
- (void)selectPhoto;
-(void)answerBrief;
@end
