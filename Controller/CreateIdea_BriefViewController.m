//
//  CreateIdea&BriefViewController.m
//  Co\Lab 
//
//  Created by magnon on 24/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "CreateIdea_BriefViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"


@interface CreateIdea_BriefViewController ()

@end

@implementation CreateIdea_BriefViewController
@synthesize baseScrollView;
@synthesize attachmentImage,mainDataDictionary,isIdeaSubmitScreen,isCurrentControllerPresented;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isAttachment = NO;
    height = 0.0f;
    self.mainDataDictionary = [[NSMutableDictionary alloc] init];
    [self.mainDataDictionary setValue:@"" forKey:@"HEADER"];
    [self.mainDataDictionary setValue:@"" forKey:@"DESCRIPTION"];
    [self.mainDataDictionary setValue:@"" forKey:@"TAGS"];
    [self.mainDataDictionary setValue:@"" forKey:@"IMAGE"];

    self.baseScrollView.frame=CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height);
  //  [self.baseScrollView setFrame:self.view.bounds];
    if (self.isIdeaSubmitScreen) {
        lbltitle.text=@"Create New Idea";
        headerImage.image=[UIImage imageNamed:@"Create_New_Idea_Image.png"];
        self.view.backgroundColor=[UIColor PPYellowColor];
        self.baseScrollView.backgroundColor = [UIColor PPYellowColor];
    }else{
        lbltitle.text=@"Create New Brief";
        headerImage.image=[UIImage imageNamed:@"Create_New_Brief_Image.png"];
        self.view.backgroundColor=[UIColor PPBlueColor];
        self.baseScrollView.backgroundColor = [UIColor PPBlueColor];
    }
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.baseScrollView addGestureRecognizer:gestureRecognizer];
    self.baseScrollView.scrollEnabled = YES;
    self.baseScrollView.scrollsToTop  = YES;
    [self rearrengeScrollView:isAttachment];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)rearrengeScrollView:(BOOL)isAttached{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    height = 0.0f;
    [self removeAllObjectsFromScrollview];
    if (isAttached) {
        [self.baseScrollView addSubview:[self addHeader]];
        [self.baseScrollView addSubview:[self addDisc]];
        [self.baseScrollView addSubview:[self addTags]];
        [self.baseScrollView setContentSize:CGSizeMake(screenWidth, height)];
        [self settingBarButton];

    }else{
        [self.baseScrollView addSubview:[self addHeader]];
        [self.baseScrollView addSubview:[self addDisc]];
        [self.baseScrollView addSubview:[self addTags]];
        [self.baseScrollView setContentSize:CGSizeMake(screenWidth, height)];
        [self settingBarButton];

    }
}
- (BOOL)prefersStatusBarHidden {
    return YES;
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
    
    NoteView *noteView = [[NoteView alloc] initWithFrame:CGRectMake(40, 25, screenWidth - 80, 200)];
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
    
    NoteView *noteView = [[NoteView alloc] initWithFrame:CGRectMake(40, 25, screenWidth - 80, 200)];
    [noteView setFontName:@"Helvetica" size:24];
    noteView.autocorrectionType = FALSE; // or use  UITextAutocorrectionTypeNo
    noteView.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
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
    
    NoteView *noteView = [[NoteView alloc] initWithFrame:CGRectMake(40, 25, screenWidth - 80, 200)];
    [noteView setFontName:@"Helvetica" size:24];
    noteView.tag = PPkTags;
    noteView.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
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

    [self removeSettingButtonFromSuperView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CANCEL_BUTTON_FRAME];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:CANCEL_BUTTON_NAME] forState:UIControlStateSelected];
    [cancelButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = PPkCancel;
    [self.view addSubview:cancelButton];
    [cancelButton bringSubviewToFront:self.view];
    
    UIButton *attachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [attachButton setFrame:ATTACHMENT_BUTTON_FRAME];
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
    NSLog(@"Button tag == %ld",(long)settingBtn.tag);
    switch (settingBtn.tag) {
        case PPkCancel:
            isCurrentControllerPresented?[[self presentingViewController] dismissViewControllerAnimated:NO completion:nil]:[self.navigationController popViewControllerAnimated:YES];
             break;
        case PPkAttachment:[self AddOverLay];
            break;
        case PPkAddOrNext:[self saveDataToServer];
            break;
        default:
            break;
    }
}
-(void)AddOverLay{
    tmpOverlayObj = [[OverlayView alloc] initOverlayView];
    [tmpOverlayObj setDelegate:(id)self];
    [self.baseScrollView addSubview:tmpOverlayObj];
    [tmpOverlayObj renderingScreenAccordingToFrame:self.view];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    isAttachment = YES;
    
    [self rearrengeScrollView:isAttachment];
    self.attachmentImage.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma UITextViewDalegate
#pragma UITextfieldDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range  replacementText:(NSString *)text{
    NSLog(@"back %ld",(long)textView.tag);
    if (textView.tag == PPkHeader) {
        
        int finalCOunt = 80 - (int)[textView.text length];
        NSLog(@"Textfield %d and text is == %lu",finalCOunt,(unsigned long)textView.text.length);
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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
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
    //hud.detailsLabelText=@"Latest idea and brief will be populating";
    
    NSDictionary *parameters;
    if (isIdeaSubmitScreen) {
        parameters = @{@"apicall":@"CreateNewIdeaBrief",@"tag":[self.mainDataDictionary valueForKey:@"TAGS"],@"headline":[self.mainDataDictionary valueForKey:@"HEADER"],@"description": [self.mainDataDictionary valueForKey:@"DESCRIPTION"],@"image":imageString,@"brief_id":@"0",@"is_brief":@"No",@"user_id":@"2"};
    }else{
        parameters = @{@"apicall":@"CreateNewIdeaBrief",@"tag":[self.mainDataDictionary valueForKey:@"TAGS"],@"headline":[self.mainDataDictionary valueForKey:@"HEADER"],@"description": [self.mainDataDictionary valueForKey:@"DESCRIPTION"],@"image":imageString,@"brief_id":@"0",@"is_brief":@"Yes",@"user_id":@"2"};
    }
    
    [manager POST:BASE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        [hud hide:YES];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        [hud hide:YES];
        
    }];
}

@end
