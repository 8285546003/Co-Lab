//
//  CreateIdea&BriefViewController.m
//  Co\Lab 
//
//  Created by magnon on 24/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "CreateIdea_BriefViewController.h"
#import "MBProgressHUD.h"
#import "CoLabListViewController.h"
#import "AFNInjector.h"
#import "StatusModel.h"
#import "StatusModelDetails.h"


@interface CreateIdea_BriefViewController (){
    StatusModel    *statusModel;
    StatusModelDetails* status;
}

@end

@implementation CreateIdea_BriefViewController
@synthesize baseScrollView;
@synthesize attachmentImage,mainDataDictionary,isIdeaSubmitScreen,isCurrentControllerPresented,isAnswerTheBriefs;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    isAttachment = NO;
    height = 0.0f;
    self.mainDataDictionary = [[NSMutableDictionary alloc] init];
    [self.mainDataDictionary setValue:@"" forKey:@"HEADER"];
    [self.mainDataDictionary setValue:@"" forKey:@"DESCRIPTION"];
    [self.mainDataDictionary setValue:@"" forKey:@"TAGS"];
    [self.mainDataDictionary setValue:@"" forKey:@"IMAGE"];

    self.baseScrollView.frame=CGRectMake(0, 55, self.view.frame.size.width, self.view.frame.size.height);
    if (self.isIdeaSubmitScreen) {
        if (isAnswerTheBriefs) {
            lbltitle.text=@"Answer The Briefs";

        }
        else{
            lbltitle.text=@"Create New Idea";

        }
        headerImage.image=[UIImage imageNamed:@"Create_New_Idea_Image.png"];
        self.view.backgroundColor=[UIColor PPYellowColor];
        self.baseScrollView.backgroundColor = [UIColor PPYellowColor];
    }else{
        lbltitle.text=@"Create New Brief";
        headerImage.image=[UIImage imageNamed:@"Create_New_Brief_Image.png"];
        self.view.backgroundColor=[UIColor PPBlueColor];
        self.baseScrollView.backgroundColor = [UIColor PPBlueColor];
    }
    
    self.baseScrollView.scrollEnabled = YES;
    self.baseScrollView.scrollsToTop  = YES;
    [self rearrengeScrollView:isAttachment];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    NoteView *n1=(NoteView *)[self.view viewWithTag:PPkHeader];
    n1.text=nil;
    n1.text=@"";
    NoteView *n2=(NoteView *)[self.view viewWithTag:PPkDescription];
    n2.text=nil;
    n2.text=@"";
    NoteView *n3=(NoteView *)[self.view viewWithTag:PPkTags];
    n3.text=nil;
    n3.text=@"";
    [self.baseScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, 0.0f)];

    dicCharCountLbl.text=@"200";
    titleCharCountLbl.text = @"80";
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self settingBarButton];
    [super viewDidAppear:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self settingBarButton];
    [super viewWillAppear:YES];
}

- (void)rearrengeScrollView:(BOOL)isAttached{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    height = 0.0f;
    [self removeAllObjectsFromScrollview];
    [self.baseScrollView addSubview:[self addHeader]];
    [self.baseScrollView addSubview:[self addDisc]];
    [self.baseScrollView addSubview:[self addTags]];
    [self.baseScrollView setContentSize:CGSizeMake(screenWidth, height)];
 }
- (BOOL)prefersStatusBarHidden {
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void) hideKeyboard {
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addImageAttachment{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    self.attachmentImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, height, screenWidth - 80, 200)];
    [self.baseScrollView addSubview:self.attachmentImage];
    height += 200;
}


- (UIView *)addHeader{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    UIView *headerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, height, screenWidth, 225)];
    headerBaseView.backgroundColor = [UIColor clearColor];
    
    noteView = [[NoteView alloc] initWithFrame:CGRectMake(40, 25, screenWidth - 80, 200)];
    [noteView setFontName:@"Helvetica" size:24];
    noteView.tag = PPkHeader;
     NSString *hStr = [self.mainDataDictionary valueForKey:@"HEADER"];
    if (hStr.length) {
        noteView.text = hStr;
    }
    noteView.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [noteView setDelegate:self];
    [headerBaseView addSubview:noteView];
    [headerBaseView addSubview:[self addHeaderTitle]];
    height += 225;
    if (isAttachment) {
        [self addImageAttachment];
    }
    return headerBaseView;
}
- (UIView *)addHeaderTitle{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat borderWidth = 2.0;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(38, 0, screenWidth - 76, 25)];
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = borderWidth;
    
    
    UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(2, 0, screenWidth-80, 25)];
    mask.backgroundColor = [UIColor blackColor];
    view.layer.mask = mask.layer;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [view addGestureRecognizer:gestureRecognizer];
    
    //Adding header title
    
    titleCharCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(view.bounds.size.width-32, 2, 30, 20)];
    titleCharCountLbl.text = @"80";
    titleCharCountLbl.textAlignment = NSTextAlignmentRight;
    [view addSubview:titleCharCountLbl];
        
        
     UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 200, 20)];
    titleLbl.text = @"1. Add headline";
    [view addSubview:titleLbl];
    
    return view;

}

- (UIView *)addDisc{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    UIView *headerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, height, screenWidth, 225)];
    headerBaseView.backgroundColor = [UIColor clearColor];
    
    noteView = [[NoteView alloc] initWithFrame:CGRectMake(40, 25, screenWidth - 80, 200)];
    [noteView setFontName:@"Helvetica" size:24];
    noteView.autocorrectionType = FALSE; // or use  UITextAutocorrectionTypeNo
    [noteView setDelegate:self];
    NSString *hStr = [self.mainDataDictionary valueForKey:@"DESCRIPTION"];
    if (hStr.length) {
        noteView.text = hStr;
    }
    
    noteView.tag = PPkDescription;
    [headerBaseView addSubview:noteView];
    [headerBaseView addSubview:[self addDiscTitle]];
    height += 225;
    return headerBaseView;
}
- (UIView *)addDiscTitle{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat borderWidth = 2.0;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(38, 0, screenWidth - 76, 25)];
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = borderWidth;
    
    
    UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(2, 0, screenWidth - 80, 25)];
    mask.backgroundColor = [UIColor blackColor];
    view.layer.mask = mask.layer;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [view addGestureRecognizer:gestureRecognizer];
    
    //Adding header title
    
    dicCharCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(view.bounds.size.width-32, 2, 30, 20)];
    dicCharCountLbl.text = @"200";
    dicCharCountLbl.textAlignment = NSTextAlignmentRight;
    [view addSubview:dicCharCountLbl];
    
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 200, 20)];
    titleLbl.text = @"2. Add description";
    [view addSubview:titleLbl];
    
    return view;
    
}

- (UIView *)addTags{
    
    CGRect  screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    UIView *headerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, height, screenWidth, 225)];
    headerBaseView.backgroundColor = [UIColor clearColor];
    
    noteView = [[NoteView alloc] initWithFrame:CGRectMake(40, 25, screenWidth - 80, 200)];
    [noteView setFontName:@"Helvetica" size:24];
    noteView.tag = PPkTags;
    [noteView setDelegate:self];
    NSString *hStr = [self.mainDataDictionary valueForKey:@"TAGS"];
    if (hStr.length) {
        noteView.text = hStr;
    }

    [headerBaseView addSubview:noteView];
    [headerBaseView addSubview:[self addTagsTitle]];
    height += 225;
    return headerBaseView;
}
- (UIView *)addTagsTitle{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat borderWidth = 2.0;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(38, 0, screenWidth - 76, 25)];
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = borderWidth;
    
    
    UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(2, 0, screenWidth - 80, 25)];
    mask.backgroundColor = [UIColor blackColor];
    view.layer.mask = mask.layer;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [view addGestureRecognizer:gestureRecognizer];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 200, 20)];
    titleLbl.text = @"3. Add tags";
    [view addSubview:titleLbl];
    
    return view;
    
}


#pragma Setting bar button
- (void)settingBarButton{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CANCEL_BUTTON_FRAME];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateSelected];
    [cancelButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = PPkCancel;
    [self.view addSubview:cancelButton];
    
    UIButton *attachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [attachButton setFrame:ATTACHMENT_BUTTON_FRAME
];
    [attachButton setImage:[UIImage imageNamed:ATTACHMENT_BUTTON_NAME] forState:UIControlStateNormal];
    [attachButton setImage:[UIImage imageNamed:ATTACHMENT_BUTTON_NAME] forState:UIControlStateSelected];
    [attachButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    attachButton.tag = PPkAttachment;
    [self.view addSubview:attachButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:ADD_BUTTON_FRAME];
    [nextButton setImage:[UIImage imageNamed:@"Next_Image.png"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"Next_Image.png"] forState:UIControlStateSelected];
    [nextButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = PPkAddOrNext;
    [self.view addSubview:nextButton];
}

- (void)removeSettingButtonFromSuperView{
    [[self.view viewWithTag:PPkCancel] removeFromSuperview];
    [[self.view viewWithTag:PPkAttachment] removeFromSuperview];
    [[self.view viewWithTag:PPkAddOrNext] removeFromSuperview];
}
- (void)settingBarMethod:(UIButton *)settingBtn{
    switch (settingBtn.tag) {
        case PPkCancel:
            isCurrentControllerPresented?[self dismissViewControllerAnimated:YES completion:nil]:[self.navigationController popViewControllerAnimated:YES];
             break;
        case PPkAttachment:[self AddOverLay];
            break;
        case PPkAddOrNext:[self isValidUserId];
            break;
        default:
            break;
    }
}
-(void)isValidUserId{
        if (GET_USERID) {
            [self saveDataToServer];
        }
        else{
            kCustomAlert(@"Failed to Login", @"Something went wrong please go to profile->Loout to re-login", @"Ok");
        }
}
-(void)AddOverLay{
    tmpOverlayObj = [[OverlayView alloc] initOverlayView];
    tmpOverlayObj.tag=1000;
    [tmpOverlayObj setDelegate:(id)self];
    [self.view addSubview:tmpOverlayObj];
    [tmpOverlayObj renderingScreenAccordingToFrame];
}

- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    isAttachment = YES;
    
    [self rearrengeScrollView:isAttachment];
    self.attachmentImage.image = [self imageWithImage:chosenImage convertToSize:CGSizeMake(150, 150)];
    [tmpOverlayObj closeMethod:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma UITextViewDalegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.baseScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.baseScrollView.frame.size.height+280)];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range  replacementText:(NSString *)text{
    if (textView.tag == PPkHeader) {
        int finalCOunt = 80 - (int)[textView.text length];
        titleCharCountLbl.text = [NSString stringWithFormat:@"%d",finalCOunt];
        NSString *tmpSTring = [textView.text uppercaseString];
        textView.text = tmpSTring;
        
        if (!text.length) {
            return YES;
        }
        if (finalCOunt == 0) {
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Char count error!"
                                                    message:@"You have exceeded maximum number of character"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
            if (!errorAlert.isVisible) {
                [errorAlert show];
            }
            
            return NO;
        }
        
    }else if (textView.tag == PPkDescription){
        int finalCOunt = 200 - (int)[textView.text length];
        dicCharCountLbl.text = [NSString stringWithFormat:@"%d",finalCOunt];
        if (!text.length) {
            return YES;
        }
        if (finalCOunt == 0) {
            
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Char count error!"
                                                    message:@"You have exceeded maximum number of character"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
            if (!errorAlert.isVisible) {
                [errorAlert show];
            }
            return NO;
        }
        
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSString *finalString = textView.text;
    
    switch (textView.tag) {
        case PPkHeader:[self.mainDataDictionary setValue:finalString forKey:@"HEADER"];
        break;
        case PPkDescription:[self.mainDataDictionary setValue:finalString forKey:@"DESCRIPTION"];
            break;
        case PPkTags:[self.mainDataDictionary setValue:finalString forKey:@"TAGS"];
            break;
        default:
            break;
    }
    return YES;
}

- (void)removeAllObjectsFromScrollview{
    height = 0.0f;
    for (UIView *tmpView in [self.baseScrollView subviews]) {
        [tmpView removeFromSuperview];
    }
}

- (void)saveDataToServer{
    NSString *imageString = [UIImagePNGRepresentation(self.attachmentImage.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    if (!imageString.length) {
        imageString = @"";
    }
    
    
    
    if([[self.mainDataDictionary valueForKey:@"HEADER"] isEqualToString:@""]){
        kCustomAlert(@"", @"Please enter header.",@"Ok");
        return;
    }
    else if([[self.mainDataDictionary valueForKey:@"DESCRIPTION"] isEqualToString:@""]){
        kCustomAlert(@"", @"Please enter description.",@"Ok");
        return;
        
    }
    else if([[self.mainDataDictionary valueForKey:@"TAGS"] isEqualToString:@""]){
        kCustomAlert(@"", @"Please enter tags.",@"Ok");
        return;
        
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = @"Please wait...";
    
    
    NSString *strBriefId=ZERO;
    NSString *strIsBrief=BOOL_YES;
    if (isIdeaSubmitScreen) {
        strIsBrief=BOOL_NO;
        if (isAnswerTheBriefs) {
            strBriefId=[PPUtilts sharedInstance].LatestIDId;
        }
    }
    NSDictionary *parameters = @{kApiCall:kApiCallCreateNewIdeaBrief,kTag:[self.mainDataDictionary valueForKey:@"TAGS"],@"headline":[self.mainDataDictionary valueForKey:@"HEADER"],@"description_idea_brief": [self.mainDataDictionary valueForKey:@"DESCRIPTION"],@"image":imageString,@"brief_id":strBriefId,@"is_brief":strIsBrief,kUserid:GET_USERID};
    
    AFNInjector *objAFN = [AFNInjector new];
    [objAFN parameters:parameters completionBlock:^(id data, NSError *error) {
        if(!error) {
            statusModel = [[StatusModel alloc] initWithDictionary:data error:nil];
            status = statusModel.StatusArr[[ZERO integerValue]];
            if ([status.Error isEqualToString:kResultError]) {
                if ([status.Message isEqualToString:kResultMessage]) {
                    if (!isAnswerTheBriefs) {
                        if (isCurrentControllerPresented) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                        else{
                            [PPUtilts sharedInstance].apiCall=kApiCallLatestIdeaBrief;
                            CoLabListViewController *objLatestIB = [CoLabListViewController new];
                            [self.navigationController pushViewController:objLatestIB animated:YES];
                        }

                    }
                    else{
                        if (isCurrentControllerPresented) {
                            [self  dismissViewControllerAnimated:YES completion:nil];
                        }
                    }
                    
                }
                else{
                    kCustomAlert(@"", status.Message, @"Ok");
                }
            }
            else{
                kCustomAlert(@"", status.Message, @"Ok");
            }
            [self settingBarButton];
            [hud hide:YES];
            NSLog(@"%@",data);
        } else {
            [self settingBarButton];
            if (PPNoInternetConnection) {
                kCustomErrorAlert;
            }
            [hud hide:YES];
            NSLog(@"error %@", error);
        }
    }];
    
}

@end
