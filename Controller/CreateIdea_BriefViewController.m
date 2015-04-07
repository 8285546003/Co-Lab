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
    UITextView *activeTextField;
    int value;
    int valueForDesc;
}

@end

@implementation CreateIdea_BriefViewController
@synthesize baseScrollView;
@synthesize attachmentImage,mainDataDictionary,isIdeaSubmitScreen,isCurrentControllerPresented,isAnswerTheBriefs;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self update];
}
-(void)update{
    isAttachment = NO;
    height = 0.0f;
    
    lbltitle.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    
    self.mainDataDictionary = [[NSMutableDictionary alloc] init];
    [self.mainDataDictionary setValue:@"" forKey:@"HEADER"];
    [self.mainDataDictionary setValue:@"" forKey:@"DESCRIPTION"];
    [self.mainDataDictionary setValue:@"" forKey:@"TAGS"];
    [self.mainDataDictionary setValue:@"" forKey:@"IMAGE"];
    self.baseScrollView.frame=CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height);
    if (self.isIdeaSubmitScreen) {
        if (isAnswerTheBriefs) {
            lbltitle.text=@"Answer The Brief";
            isCurrentControllerPresented=YES;
            // self.view.backgroundColor=[UIColor PPYellowColor];
            // self.baseScrollView.backgroundColor = [UIColor PPYellowColor];
        }
        else{
            //self.view.backgroundColor=[UIColor PPRedColor];
            //self.baseScrollView.backgroundColor = [UIColor PPRedColor];
            lbltitle.text=@"Create New Idea";
        }
        headerImage.image=[UIImage imageNamed:@"my_ideas.png"];
        self.view.backgroundColor=[UIColor PPYellowColor];
        self.baseScrollView.backgroundColor = [UIColor PPYellowColor];
    }else{
        lbltitle.text=@"Create New Brief";
        headerImage.image=[UIImage imageNamed:@"my_brief.png"];
        self.view.backgroundColor=[UIColor PPBlueColor];
        self.baseScrollView.backgroundColor = [UIColor PPBlueColor];
    }
    self.baseScrollView.scrollEnabled = YES;
    self.baseScrollView.scrollsToTop = YES;
    [self rearrengeScrollView:isAttachment];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (!isCurrentControllerPresented) {
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
        self.attachmentImage=nil;
        [self update];
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self settingBarButton];
    [super viewDidAppear:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    //[self settingBarButton];
    [super viewWillAppear:YES];
}

- (void)rearrengeScrollView:(BOOL)isAttached{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
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
   // CGRect screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenWidth = screenRect.size.width;
   // self.attachmentImage.frame=CGRectMake(40, textView.contentSize.height+25, 250, 200);
    self.attachmentImage.alpha=1.0f;
    self.attachmentImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, height, 240, 170)];
    [self.baseScrollView addSubview:self.attachmentImage];
    height += 200;
}


- (UIView *)addHeader{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    UIView *headerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, height, screenWidth, 255)];
    headerBaseView.backgroundColor = [UIColor clearColor];
    
    noteView = [[NoteView alloc] initWithFrame:CGRectMake(40, 25, screenWidth - 80, 230)];
    [noteView setFontName:@"HelveticaNeue-CondensedBold" size:36];
    noteView.text = @"ADD HEADLINE";
    noteView.tag = PPkHeader;
    noteView.autocorrectionType = UITextAutocorrectionTypeNo;
    noteView.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
     NSString *hStr = [self.mainDataDictionary valueForKey:@"HEADER"];
    
    if (hStr.length) {
        noteView.text = hStr;
    }
    if ([noteView.text isEqualToString:@"ADD HEADLINE"]) {
        noteView.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
    }else{
        noteView.textColor = [UIColor PPTextColor];
    }
    noteView.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [noteView setDelegate:self];
    [headerBaseView addSubview:noteView];
    [headerBaseView addSubview:[self addHeaderTitle]];
    height += 255;
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
    titleCharCountLbl.textColor = [UIColor PPTextColor];
    titleCharCountLbl.textAlignment = NSTextAlignmentRight;
  //  HelveticaNeue-CondensedBold
    titleCharCountLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    [view addSubview:titleCharCountLbl];
        
        
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 200, 20)];
    titleLbl.text = @"1. Add headline";
    titleLbl.textColor = [UIColor darkGrayColor];

    titleLbl.font = [UIFont systemFontOfSize:11.0f];
    [view addSubview:titleLbl];
    
    return view;

}

- (UIView *)addDisc{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    UIView *headerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, height, screenWidth, 225)];
    headerBaseView.backgroundColor = [UIColor clearColor];
    
    noteView = [[NoteView alloc] initWithFrame:CGRectMake(40, 25, screenWidth - 80, 200)];
    [noteView setFontName:@"HelveticaNeue-Light" size:15];
    noteView.text = @"Add Description";
    noteView.autocorrectionType = UITextAutocorrectionTypeNo;

   // noteView.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
    noteView.autocorrectionType = FALSE; // or use  UITextAutocorrectionTypeNo
    [noteView setDelegate:self];
    NSString *hStr = [self.mainDataDictionary valueForKey:@"DESCRIPTION"];
    
    
    if (hStr.length) {
        noteView.text = hStr;
    }
    if ([noteView.text isEqualToString:@"Add Description"]) {
        noteView.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];

    }else{
        noteView.textColor = [UIColor PPTextColor];
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
    dicCharCountLbl.textColor = [UIColor PPTextColor];

    dicCharCountLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];

    dicCharCountLbl.textAlignment = NSTextAlignmentRight;
    [view addSubview:dicCharCountLbl];
    
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 200, 20)];
    titleLbl.text = @"2. Add description";
    titleLbl.textColor = [UIColor grayColor];

    titleLbl.font = [UIFont systemFontOfSize:11.0f];
    [view addSubview:titleLbl];
    
    return view;
    
}

- (UIView *)addTags{
    
    CGRect  screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    UIView *headerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, height, screenWidth, 225)];
    headerBaseView.backgroundColor = [UIColor clearColor];
    
    noteView = [[NoteView alloc] initWithFrame:CGRectMake(40, 25, screenWidth - 80, 200)];
    [noteView setFontName:@"HelveticaNeue-Light" size:15];
    noteView.tag = PPkTags;
    [noteView setDelegate:self];
    noteView.autocorrectionType = UITextAutocorrectionTypeNo;
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
    titleLbl.textColor = [UIColor darkGrayColor];
    titleLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];

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
    [nextButton setImage:[UIImage imageNamed:@"right_arrow.png"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"right_arrow.png"] forState:UIControlStateSelected];
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
    isCurrentControllerPresented=YES;
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
    isCurrentControllerPresented=YES;
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
    self.attachmentImage.image = chosenImage;

    //self.attachmentImage.image = [self imageWithImage:chosenImage convertToSize:CGSizeMake(150, 150)];
    [tmpOverlayObj closeMethod:nil];
    isCurrentControllerPresented=NO;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma UITextViewDalegate
- (void) slideUp {
    [UIView beginAnimations:nil context:nil];
    self.view.frame = CGRectMake(0.0, -200.0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}


- (void) slideDown {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay: 0.01];
    self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    activeTextField = textView;
    if (textView.tag == 101) {
        if ([textView.text isEqualToString:@"ADD HEADLINE"]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }else if(textView.tag == 102){
        if ([textView.text isEqualToString:@"Add Description"]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.tag == 103 || textView.tag == 102) {
        [self slideUp];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    int len = textView.text.length;
    
    if (textView.tag == PPkHeader) {
        titleCharCountLbl.text=[NSString stringWithFormat:@"%i",80-len];
    }else if (textView.tag == PPkDescription){
        dicCharCountLbl.text=[NSString stringWithFormat:@"%i",200-len];
    }else if (textView.tag == PPkTags){
       
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range  replacementText:(NSString *)text{
    NSLog(@"======%@",text);
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (textView.tag == PPkHeader) {
           height=textView.contentSize.height;
          self.attachmentImage.frame=CGRectMake(40, height+25, 240, 180);
        if([text length] == 0)
        {
            if([textView.text length] != 0)
            {
                return YES;
            }
        }
        else if([[textView text] length] >= 80)
        {
            if (!errorAlert.isVisible) {
                errorAlert = [[UIAlertView alloc] initWithTitle:@"Char count error!"
                                                        message:@"You have exceeded maximum number of character"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                [errorAlert show];
            }
            
            return NO;
        }
        return YES;
        
    }else if (textView.tag == PPkDescription){
        if([text length] == 0)
        {
            if([textView.text length] != 0)
            {
                return YES;
            }
        }
        else if([[textView text] length] >= 200)
        {
            if (!errorAlert.isVisible) {
            errorAlert = [[UIAlertView alloc] initWithTitle:@"Char count error!"
                                                    message:@"You have exceeded maximum number of character"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
            [errorAlert show];
            }
            return NO;
        }
        return YES;
        
    }else if (textView.tag == PPkTags){
        float nLine = [self numberOfLines:textView fontSize:24];
        //NSLog(@"Number of line == %f",nLine);
        if (nLine > 3.0 && nLine != value) {
            value = nLine;
            self.baseScrollView.contentOffset = CGPointMake(0, self.baseScrollView.contentOffset.y + 24);
        }
    }
    
    return YES;
   // return YES;
}

- (int)numberOfLines:(UITextView *)textView fontSize:(float)fSize{
    UIFont *font = [UIFont boldSystemFontOfSize:fSize];
    CGSize size = [textView.text sizeWithFont:font
                     constrainedToSize:textView.frame.size
                         lineBreakMode:UILineBreakModeWordWrap]; // default mode
    
    int numberOfLines = size.height / font.lineHeight;
    return  numberOfLines;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSString *finalString = textView.text;
    
    switch (textView.tag) {
        case PPkHeader:{
            [self.mainDataDictionary setValue:finalString forKey:@"HEADER"];
            NSString *trimmedString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (![trimmedString length]) {
                textView.text = @"ADD HEADLINE";
                textView.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
            }
        }
        break;
        case PPkDescription:{
            [self.mainDataDictionary setValue:finalString forKey:@"DESCRIPTION"];
            NSString *trimmedString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (![trimmedString length]) {
                textView.text = @"Add Description";
                textView.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
            }
            [self slideDown];

        }
            break;
        case PPkTags:[self.mainDataDictionary setValue:finalString forKey:@"TAGS"];
            [self slideDown];
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
            [hud hide:YES];
            NSLog(@"error %@", error);
        }
    }];
    
}


// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.baseScrollView.contentInset = contentInsets;
    self.baseScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y-kbSize.height);
        [self.baseScrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.baseScrollView.contentInset = contentInsets;
    self.baseScrollView.scrollIndicatorInsets = contentInsets;
}
@end
