//
//  LatestIdeaBriefsViewController.m
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "LatestIdeaBriefsViewController.h"
#import "UIColor+PPColor.h"

#define KEYBOARD_HEIGHT 216

typedef enum {
    
    PPkRedColor,
    PPkYellowColor,
    PPkGreenColor,
    PPkBlueColor,
    
}ColorType;

@interface LatestIdeaBriefsViewController ()

@end

@implementation LatestIdeaBriefsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    isAttachment = NO;
    self.attachmentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    latestIdeaBrifTableView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [latestIdeaBrifTableView addGestureRecognizer:gestureRecognizer];
    [self settingBarButton];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void) hideKeyboard {
    [self.view endEditing:YES];
    //[self.note resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([cell.contentView viewWithTag:indexPath.row+1]) {
        [[cell.contentView viewWithTag:indexPath.row+1] removeFromSuperview];
    }

    
    self.note = [[NoteView alloc] initWithFrame:CGRectMake(40, 0, cell.frame.size.width - 80, 200)];
    self.note.tag = indexPath.row+1;
    //self.note.delegate = self;
    self.note.text = @"This is the first line.\nThis is the second line.\nThis is the ... line.\nThis is the ... line.\nThis is the ... line.\nThis is the ... line.\nThis is the ... line.\n";
    //[self.view addSubview:self.note];
    [cell.contentView setFrame:CGRectMake(0, 0, cell.frame.size.width, 200)];
    [cell.contentView addSubview:self.note];
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case PPkRedColor:cell.backgroundColor    = [UIColor    PPRedColor];
            break;
        case PPkYellowColor:cell.backgroundColor = [UIColor  PPYellowColor];
            break;
        case PPkGreenColor:cell.backgroundColor  = [UIColor    PPGreenColor];
            break;
        case PPkBlueColor:cell.backgroundColor   = [UIColor    PPBlueColor];
            break;
        default:
            break;
    }
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-50,40)];
    
    // 2. Set a custom background color and a border
    //headerView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
   // headerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
   // headerView.layer.borderWidth = 1.5;
    
    // 3. Add a label
    UITextField* txtheader = [[UITextField alloc] init];
    txtheader.frame = CGRectMake(40,5, self.view.frame.size.width -80, 30);
   // headerLabel.backgroundColor = [UIColor clearColor];
    txtheader.textColor = [UIColor blackColor];
    txtheader.font = [UIFont systemFontOfSize:10.0];
    txtheader.text = @"Nissan, Cars, Stunt, Event";
    txtheader.textAlignment = NSTextAlignmentLeft;
    [txtheader setBackgroundColor:[UIColor clearColor]];
    [txtheader setBorderStyle:UITextBorderStyleBezel];
    
    
    switch (section) {
        case PPkRedColor:[headerView setBackgroundColor:[UIColor PPRedColor]];
            break;
        case PPkYellowColor:[headerView setBackgroundColor:[UIColor PPYellowColor]];
            break;
        case PPkGreenColor:[headerView setBackgroundColor:[UIColor PPGreenColor]];
            break;
        case PPkBlueColor:[headerView setBackgroundColor:[UIColor PPBlueColor]];
            break;
        default:
            break;
    }
    
    // 3. Add a Image for new brief with blue image.
    
    UIImageView* newBriefImage = [[UIImageView alloc] init];
    newBriefImage.image=[UIImage imageNamed:@"Create_New_Brief_Image.png"];
    newBriefImage.frame = CGRectMake(headerView.frame.size.width-85 , 8, 25, 25);
    [headerView addSubview:newBriefImage];
    
    
    
    
    UIImageView* newIdeaImage = [[UIImageView alloc] init];
    newIdeaImage.image=[UIImage imageNamed:@"Create_New_Idea_Image.png"];
    newIdeaImage.frame = CGRectMake(headerView.frame.size.width-55, 8, 25, 25);
    [headerView addSubview:newIdeaImage];
    
    
    UIImageView* hotIdeaImage = [[UIImageView alloc] init];
    hotIdeaImage.image=[UIImage imageNamed:@"red_plus_up.png"];
    hotIdeaImage.frame = CGRectMake(headerView.frame.size.width-25, 8, 25, 25);
    [headerView addSubview:hotIdeaImage];
    
    
    // 4. Add the label to the header view
    [headerView addSubview:txtheader];
    
    // 5. Finally return
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.00f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 2)
//        return 50.0f;
//    else
//        return 0.0f;
//}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 2) //hear u can make decision
    {
        //        /* ---------------------------------------------------------
        //         * Now we've changed [self view] to contain our tableView and our bar.
        //         * ---------------------------------------------------------*/
        //        UIImage *image = [UIImage imageNamed:@"red_plus_up.png"];
        //        UIImage *selectedImage = [UIImage imageNamed:@"red_plus_down.png"];
        //        UIImage *toggledImage = [UIImage imageNamed:@"red_x_up.png"];
        //        UIImage *toggledSelectedImage = [UIImage imageNamed:@"red_x_down.png"];
        //        CGPoint center = CGPointMake(30.0f, 370.0f);
        //
        //        CGRect buttonFrame = CGRectMake(0, 0, 50.0f, 50.0f);
        //        UIButton *b1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        [b1 setFrame:buttonFrame];
        //        [b1 setTitle:@"One" forState:UIControlStateNormal];
        //        UIButton *b2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        [b2 setTitle:@"Two" forState:UIControlStateNormal];
        //        [b2 setFrame:buttonFrame];
        //        UIButton *b3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        [b3 setTitle:@"Three" forState:UIControlStateNormal];
        //        [b3 setFrame:buttonFrame];
        //        NSArray *buttons = [NSArray arrayWithObjects:b1, b2, b3, nil];
        //
        //        RNExpandingButtonBar *bar = [[RNExpandingButtonBar alloc] initWithImage:image selectedImage:selectedImage toggledImage:toggledImage toggledSelectedImage:toggledSelectedImage buttons:buttons center:center];
        //        [bar setHorizontal:YES];
        //        [bar setExplode:YES];
        //return bar;
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        tmpView.backgroundColor = [UIColor clearColor];
        return tmpView;
    }
    
    return nil;
}

- (void)settingBarButton{
    
    NSLog(@"View height == %f",self.view.bounds.size.height);
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, self.view.bounds.size.height - 60, 50, 50)];
    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateSelected];
    [closeButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.tag = 1000;
    [self.view addSubview:closeButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - 60, 50, 50)];
    [nextButton setImage:[UIImage imageNamed:@"Next_Image.png"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"Next_Image.png"] forState:UIControlStateSelected];
    [nextButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = 3000;
    [self.view addSubview:nextButton];
}

- (void)settingBarMethod:(UIButton *)settingBtn{
    NSLog(@"Button tag == %ld",(long)settingBtn.tag);
    switch (settingBtn.tag) {
        case 1000:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2000:{
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Take a photo!" delegate:nil cancelButtonTitle:@"Cancel"           destructiveButtonTitle:nil otherButtonTitles:@"From Galary", @"From Camra", nil];
            [actionSheet showInView:self.view];
        }
            break;
        case 3000:{
            
        }
            break;
        default:
            break;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0)
        
    {
        
        NSLog(@"Delete Button Clicked");
        [self selectPhoto];
        
    }
    
    else if(buttonIndex == 1)
        
    {
        [self takePhoto];
        NSLog(@"Create Button Clicked");
        
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
    //self.imageView.image = chosenImage;
    isAttachment = YES;
    //self.attachmentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    //self.attachmentImage.image = [UIImage imageNamed:@"Close_Image.png"];
    self.attachmentImage.image = chosenImage;
    [latestIdeaBrifTableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//-(UIView*)newBriefBlueColorWithImage:(UIView*)headerView{
//    // 3. Add a Image for new brief with blue image.
//    
//    UIImageView* newBriefImage = [[UIImageView alloc] init];
//    newBriefImage.image=[UIImage imageNamed:@"Create_New_Brief_Image.png"];
//    newBriefImage.frame = CGRectMake(headerView.frame.size.width , 5, 40, 40);
//    [headerView addSubview:newBriefImage];
//    
//    
//    
//    
//    UIImageView* newIdeaImage = [[UIImageView alloc] init];
//    newIdeaImage.image=[UIImage imageNamed:@"Create_New_Idea_Image.png"];
//    newIdeaImage.frame = CGRectMake(headerView.frame.size.width, 5, 40, 40);
//    [headerView addSubview:newIdeaImage];
//    
//    
//    UIImageView* hotIdeaImage = [[UIImageView alloc] init];
//    hotIdeaImage.image=[UIImage imageNamed:@"red_plus_up.png"];
//    hotIdeaImage.frame = CGRectMake(headerView.frame.size.width, 5, 40, 40);
//    [headerView addSubview:hotIdeaImage];
//    
//    
//    return headerView;
//}

@end
