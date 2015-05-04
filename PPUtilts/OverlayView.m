//
//  OverlayView.m
//  Co\Lab 
//
//  Created by magnon on 23/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "OverlayView.h"
#import "PPUtilts.h"


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
    
    [UIView animateWithDuration:0.01 animations:^{
        [self setAlpha:0.85f];
    } completion:^(BOOL finished) {
        takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];

//        [takePhotoBtn setFrame:CGRectMake( 20, screenHeight - 120, 165, 45)];
//        [takePhotoBtn setImage:[UIImage imageNamed:@"take_a_photo.png"] forState:UIControlStateNormal];
        [takePhotoBtn addTarget:self.delegate action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        takePhotoBtn.alpha = 1.0f;
      //  [self addSubview:takePhotoBtn];
        
        galaryPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [galaryPhotoBtn setFrame:CGRectMake( 20, screenHeight - 70, 165, 45)];
//        [galaryPhotoBtn setImage:[UIImage imageNamed:@"choose_a_photo.png"] forState:UIControlStateNormal];
        [galaryPhotoBtn addTarget:self.delegate action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
        galaryPhotoBtn.alpha = 1.0f;
       // [self addSubview:galaryPhotoBtn];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [closeBtn setFrame:CGRectMake( screenWidth - 115, screenHeight - 45, 45, 45)];
//        [closeBtn setImage:[UIImage imageNamed:@"cancel_white.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeMethod:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.alpha = 1.0f;
        
        
        
        if ([PPUtilts isiPhone6]||[PPUtilts isiPhone6Plus]) {
            [takePhotoBtn setFrame:CGRectMake( 20, screenHeight - 170, 190, 52)];
            [takePhotoBtn setImage:[UIImage imageNamed:@"take_a_photo6.png"] forState:UIControlStateNormal];
            
            
            [galaryPhotoBtn setFrame:CGRectMake( 20, screenHeight - 110, 190, 52)];
            [galaryPhotoBtn setImage:[UIImage imageNamed:@"choose_a_photo6.png"] forState:UIControlStateNormal];
            
            
            [closeBtn setFrame:CGRectMake( screenWidth - 85, screenHeight - 52, 52, 52)];
            [closeBtn setImage:[UIImage imageNamed:@"cancel_white6.png"] forState:UIControlStateNormal];
            
            
        }
        else{
            [takePhotoBtn setFrame:CGRectMake( 20, screenHeight - 120, 165, 45)];
            [takePhotoBtn setImage:[UIImage imageNamed:@"take_a_photo.png"] forState:UIControlStateNormal];
            
            
            [galaryPhotoBtn setFrame:CGRectMake( 20, screenHeight - 70, 165, 45)];
            [galaryPhotoBtn setImage:[UIImage imageNamed:@"choose_a_photo.png"] forState:UIControlStateNormal];
            
            
            [closeBtn setFrame:CGRectMake( screenWidth - 115, screenHeight - 45, 45, 45)];
            [closeBtn setImage:[UIImage imageNamed:@"cancel_white.png"] forState:UIControlStateNormal];
            
            
        }
        
        [self addSubview:galaryPhotoBtn];

        [self addSubview:takePhotoBtn];

        [self addSubview:closeBtn];

    }];
 
    
}
- (void)closeMethod:(UIButton *)sender{
    [takePhotoBtn removeFromSuperview];
    [galaryPhotoBtn removeFromSuperview];
    [closeBtn removeFromSuperview];
    [UIView animateWithDuration:0.01 animations:^{
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
    
    [UIView animateWithDuration:0.01 animations:^{
        [self setAlpha:0.85f];
    } completion:^(BOOL finished) {
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([PPUtilts isiPhone6Plus]||[PPUtilts isiPhone6]) {
            [closeBtn setImage:[UIImage imageNamed:@"cancel_white6.png"] forState:UIControlStateNormal];

        }
        else{
            [closeBtn setImage:[UIImage imageNamed:@"cancel_white.png"] forState:UIControlStateNormal];

        }
        [closeBtn addTarget:self action:@selector(closeIBView:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.alpha = 1.0f;
        [self addSubview:closeBtn];
        
        
        if (Answer) {
            answerBriefBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [answerBriefBtn setFrame:CGRectMake( 20, screenHeight - 80, 215, 45)];
//            [answerBriefBtn setImage:[UIImage imageNamed:@"answer_the_brief.png"] forState:UIControlStateNormal];
            [answerBriefBtn addTarget:self.delegate action:@selector(answerIB) forControlEvents:UIControlEventTouchUpInside];
            answerBriefBtn.alpha = 1.0f;
            [self addSubview:answerBriefBtn];
            
            
            if ([PPUtilts isiPhone6Plus]||[PPUtilts isiPhone6]) {
                [answerBriefBtn setFrame:CGRectMake( 20, screenHeight - 80, 248, 52)];
                [answerBriefBtn setImage:[UIImage imageNamed:@"answer_the_brief6.png"] forState:UIControlStateNormal];
               // [closeBtn setFrame:CGRectMake( screenWidth - 65, screenHeight - 52, 52, 52)];

                
            }
            else{
                [answerBriefBtn setFrame:CGRectMake( 20, screenHeight - 80, 215, 45)];
                [answerBriefBtn setImage:[UIImage imageNamed:@"answer_the_brief.png"] forState:UIControlStateNormal];
                //[closeBtn setFrame:CGRectMake( screenWidth - 65, screenHeight - 45, 45, 45)];

            }
            

        }
      


      
        
        
        
        createIdeaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      //  if ([PPUtilts isIPad]) {
        //    [createIdeaBtn setFrame:CGRectMake( 40, screenHeight - 180, 500, 80)];
//}
       // else{
//            [createIdeaBtn setFrame:CGRectMake( 20, screenHeight - 180, 215, 45)];
//     //   }
//        [createIdeaBtn setImage:[UIImage imageNamed:@"create_new_idea.png"] forState:UIControlStateNormal];
        [createIdeaBtn addTarget:self.delegate action:@selector(createIdea) forControlEvents:UIControlEventTouchUpInside];
        createIdeaBtn.alpha = 1.0f;
        [self addSubview:createIdeaBtn];
        
        createBriefBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [createBriefBtn setFrame:CGRectMake( 20, screenHeight - 130, 215, 45)];
//        [createBriefBtn setImage:[UIImage imageNamed:@"create_new_brief.png"] forState:UIControlStateNormal];
        [createBriefBtn addTarget:self.delegate action:@selector(createBrief) forControlEvents:UIControlEventTouchUpInside];
        createIdeaBtn.alpha = 1.0f;
        [self addSubview:createBriefBtn];
        
        
        
        if ([PPUtilts isiPhone6Plus]||[PPUtilts isiPhone6]) {
            [closeBtn setFrame:CGRectMake( screenWidth - 85, screenHeight - 52, 52, 52)];
            
            
            [createIdeaBtn setFrame:CGRectMake( 20, screenHeight - 200, 248, 52)];
            [createIdeaBtn setImage:[UIImage imageNamed:@"create_new_idea6.png"] forState:UIControlStateNormal];
            
            [createBriefBtn setFrame:CGRectMake( 20, screenHeight - 140, 248, 52)];
            [createBriefBtn setImage:[UIImage imageNamed:@"create_new_brief6.png"] forState:UIControlStateNormal];
            
            
            
            
            
        }
        else{
            [closeBtn setFrame:CGRectMake( screenWidth - 65, screenHeight - 45, 45, 45)];
            
            [createIdeaBtn setFrame:CGRectMake( 20, screenHeight - 180, 215, 45)];
            [createIdeaBtn setImage:[UIImage imageNamed:@"create_new_idea.png"] forState:UIControlStateNormal];
            
            [createBriefBtn setFrame:CGRectMake( 20, screenHeight - 130, 215, 45)];
            [createBriefBtn setImage:[UIImage imageNamed:@"create_new_brief.png"] forState:UIControlStateNormal];
            
            
            
        }
        

        
    }];
    
    
}
- (void)closeIBView:(UIButton *)sender{
    
    [createIdeaBtn removeFromSuperview];
    [createBriefBtn removeFromSuperview];
    [answerBriefBtn removeFromSuperview];
    [closeBtn removeFromSuperview];
    [UIView animateWithDuration:0.01 animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}



@end
