//
//  CreateIdea&BriefViewController.m
//  Co\Lab 
//
//  Created by magnon on 24/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "CreateIdea_BriefViewController.h"


@interface CreateIdea_BriefViewController ()

@end

@implementation CreateIdea_BriefViewController
@synthesize baseScrollView;
@synthesize attachmentImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isAttachment = NO;
    height = 0.0f;
    self.mainDataDictionary = [[NSMutableDictionary alloc] init];
    [self.mainDataDictionary setValue:@"" forKey:@"HEADER"];
    [self.mainDataDictionary setValue:@"" forKey:@"DICRIPTION"];
    [self.mainDataDictionary setValue:@"" forKey:@"TAGS"];
    [self.mainDataDictionary setValue:@"" forKey:@"IMAGE"];

    
    [self.baseScrollView setFrame:self.view.bounds];
    if (self.isIdeaSubmitScreen) {
        self.baseScrollView.backgroundColor = [UIColor PPYellowColor];
    }else{
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
    CGFloat screenHeight = screenRect.size.height;
    height = 0.0f;
    [self removeAllObjectsFromScrollview];
    if (isAttached) {
        [self.baseScrollView addSubview:[self addHeader]];
       // [self addImageAttachment];
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
- (void) hideKeyboard {
    NSLog(@"Hidding keyboards");
    [self.view endEditing:YES];
    //[tmpOverlayObj closeMethod:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addImageAttachment{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.attachmentImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, height, screenWidth - 80, 200)];
    [self.baseScrollView addSubview:self.attachmentImage];
    height += 200;
}


- (UIView *)addHeader{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UIView *headerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, height, screenWidth, 225)];
    headerBaseView.backgroundColor = [UIColor clearColor];
    
    NoteView *noteView = [[NoteView alloc] initWithFrame:CGRectMake(40, 25, screenWidth - 80, 200)];
    [noteView setFontName:@"Helvetica" size:24];
    noteView.tag = 101;
    
   NSString *hStr = [self.mainDataDictionary valueForKey:@"HEADER"];
    if (hStr.length) {
        noteView.text = hStr;
    }
    noteView.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [noteView setDelegate:self];
    [headerBaseView addSubview:noteView];
    //noteView.backgroundColor = [UIColor redColor];
    
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
    CGFloat screenHeight = screenRect.size.height;
    
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
    titleLbl.text = @"Add headline";
    [view addSubview:titleLbl];
    
    return view;

}

- (UIView *)addDisc{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *headerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, height, screenWidth, 225)];
    headerBaseView.backgroundColor = [UIColor clearColor];
    
    NoteView *noteView = [[NoteView alloc] initWithFrame:CGRectMake(40, 25, screenWidth - 80, 200)];
    [noteView setFontName:@"Helvetica" size:24];
    noteView.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [noteView setDelegate:self];
    NSString *hStr = [self.mainDataDictionary valueForKey:@"DICRIPTION"];
    if (hStr.length) {
        noteView.text = hStr;
    }
    
    noteView.tag = 102;
    [headerBaseView addSubview:noteView];
    //noteView.backgroundColor = [UIColor redColor];
    
    [headerBaseView addSubview:[self addDiscTitle]];
    height += 225;
    return headerBaseView;
}
- (UIView *)addDiscTitle{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
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
    titleLbl.text = @"Add discription";
    [view addSubview:titleLbl];
    
    return view;
    
}

- (UIView *)addTags{
    
    CGRect  screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    UIView *headerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, height, screenWidth, 225)];
    headerBaseView.backgroundColor = [UIColor clearColor];
    
    NoteView *noteView = [[NoteView alloc] initWithFrame:CGRectMake(40, 25, screenWidth - 80, 200)];
    [noteView setFontName:@"Helvetica" size:24];
    noteView.tag = 103;
    noteView.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [noteView setDelegate:self];
    NSString *hStr = [self.mainDataDictionary valueForKey:@"TAGS"];
    if (hStr.length) {
        noteView.text = hStr;
    }

    [headerBaseView addSubview:noteView];
    //noteView.backgroundColor = [UIColor redColor];
    
    [headerBaseView addSubview:[self addTagsTitle]];
    height += 225;
    return headerBaseView;
}
- (UIView *)addTagsTitle{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

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
    titleLbl.text = @"Add tags";
    [view addSubview:titleLbl];
    
    return view;
    
}


#pragma Setting bar button
- (void)settingBarButton{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    [self removeSettingButtonFromSuperView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(40, screenHeight - 60, 40, 40)];
    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateSelected];
    [closeButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.tag = 1000;
    [self.view addSubview:closeButton];
    [closeButton bringSubviewToFront:self.view];
    
    UIButton *attachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [attachButton setFrame:CGRectMake(screenWidth-130, screenHeight - 60, 40, 40)];
    [attachButton setImage:[UIImage imageNamed:@"Attachment_Image.png"] forState:UIControlStateNormal];
    [attachButton setImage:[UIImage imageNamed:@"Attachment_Image.png"] forState:UIControlStateSelected];
    [attachButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    attachButton.tag = 2000;
    [self.view addSubview:attachButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(screenWidth - 80, screenHeight - 60, 40, 40)];
    [nextButton setImage:[UIImage imageNamed:@"Next_Image.png"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"Next_Image.png"] forState:UIControlStateSelected];
    [nextButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = 3000;
    [self.view addSubview:nextButton];
}

- (void)removeSettingButtonFromSuperView{
    [[self.view viewWithTag:1000] removeFromSuperview];
    [[self.view viewWithTag:2000] removeFromSuperview];
    [[self.view viewWithTag:3000] removeFromSuperview];
}
- (void)settingBarMethod:(UIButton *)settingBtn{
    NSLog(@"Button tag == %ld",(long)settingBtn.tag);
    switch (settingBtn.tag) {
        case 1000:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2000:{
            tmpOverlayObj = [[OverlayView alloc] initOverlayView];
            tmpOverlayObj.tag = 1000;
            [tmpOverlayObj setDelegate:self];
            [self.baseScrollView addSubview:tmpOverlayObj];
            [tmpOverlayObj renderingScreenAccordingToFrame:self.view];
        }
            break;
        case 3000:{
            [self saveDataToServer];
        }
            break;
        default:
            break;
    }
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
    NSLog(@"back %d",textView.tag);
    if (textView.tag == 101) {
        
        int finalCOunt = 80 - (int)[textView.text length];
        NSLog(@"Textfield %d and text is == %d",finalCOunt,textView.text.length);
        titleCharCountLbl.text = [NSString stringWithFormat:@"%d",finalCOunt];
        if (!text.length) {
            return YES;
        }
        if (finalCOunt == 0) {
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Char count error!"
                                                    message:@"You have exided maximum number of character"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
            if (!errorAlert.isVisible) {
                [errorAlert show];
            }
            
            return NO;
        }
        
    }else if (textView.tag == 102){
        int finalCOunt = 200 - (int)[textView.text length];
        dicCharCountLbl.text = [NSString stringWithFormat:@"%d",finalCOunt];
        if (!text.length) {
            return YES;
        }
        if (finalCOunt == 0) {
            
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Char count error!"
                                                    message:@"You have exided maximum number of character"
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
        case 101:{
            [self.mainDataDictionary setValue:finalString forKey:@"HEADER"];

        }
        break;
        case 102:{
            [self.mainDataDictionary setValue:finalString forKey:@"DICRIPTION"];

        }
            break;
        case 103:{
            [self.mainDataDictionary setValue:finalString forKey:@"TAGS"];

        }
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

    //[self.mainDataDictionary valueForKey:@"IMAGE"];
    NSString *imageString = [UIImagePNGRepresentation(self.attachmentImage.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (!imageString.length) {
        imageString = @"";
    }
    NSDictionary *parameters;
    if (isIdeaSubmitScreen) {
        parameters = @{@"apicall":@"CreateNewIdeaBrief",@"tag":@"politics, movie",@"headline":[self.mainDataDictionary valueForKey:@"HEADER"],@"description": [self.mainDataDictionary valueForKey:@"DICRIPTION"],@"image":imageString,@"brief_id":@"0",@"is_brief":@"No",@"user_id":@"2"};
    }else{
        parameters = @{@"apicall":@"CreateNewIdeaBrief",@"tag":@"politics, movie",@"headline":[self.mainDataDictionary valueForKey:@"HEADER"],@"description": [self.mainDataDictionary valueForKey:@"DICRIPTION"],@"image":imageString,@"brief_id":@"0",@"is_brief":@"Yes",@"user_id":@"2"};
    }
    
    [manager POST:@"http://miprojects2.com.php53-6.ord1-1.websitetestlink.com/colab/api/version" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
}
@end
