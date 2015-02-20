//
//  CreateBriefViewController.m
//  Co\Lab 
//
//  Created by magnon on 19/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "CreateBriefViewController.h"
#import "UIColor+PPColor.h"
#define KEYBOARD_HEIGHT 216

typedef enum {
    
    PPkRedColor,
    PPkYellowColor,
    PPkGreenColor,
    PPkBlueColor,
    
}ColorType;

@interface CreateBriefViewController ()

@end

@implementation CreateBriefViewController
@synthesize attachmentImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    isAttachment = NO;
    self.attachmentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    createBrifTableView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [createBrifTableView addGestureRecognizer:gestureRecognizer];
    [self settingBarButton];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void) hideKeyboard {
    [self.note resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (isAttachment) {
        return 4;
    }
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
    NSLog(@"Is attachment value ===== %d",isAttachment);
    //    if ([cell.contentView  viewWithTag:indexPath.row + 1]) {
    //        [[cell.contentView viewWithTag:indexPath.row + 1] removeFromSuperview];
    //    }
    if (isAttachment) {
        if (indexPath.row == 1) {
            [cell.contentView setFrame:CGRectMake(0, 0, cell.frame.size.width, 200)];
            
            //self.attachmentImage.backgroundColor = [UIColor redColor];
            [cell.contentView addSubview:self.attachmentImage];
            //[self.attachmentImage bringSubviewToFront:cell.contentView];
            // Configure the cell...
            cell.backgroundColor = [UIColor redColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    
    //        if (indexPath.row == 0) {
    //            [cell.contentView setFrame:CGRectMake(0, 0, cell.frame.size.width, 200)];
    //            self.attachmentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    //            self.attachmentImage.image = [UIImage imageNamed:@"Close_Image.png"];
    //            [cell addSubview:self.attachmentImage];
    //            //[self.attachmentImage bringSubviewToFront:cell.contentView];
    //            // Configure the cell...
    //            cell.backgroundColor = [UIColor redColor];
    //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //            return cell;
    //        }
    
    
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
    
    
    if (section == 0) {
        UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Section1_Image.png"]];
        return headerImage;
    }else{
        UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Section2_Image.png"]];
        return headerImage;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.00f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
        return 50.0f;
    else
        return 0.0f;
}
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
    [closeButton bringSubviewToFront:self.view];
    
    UIButton *attachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [attachButton setFrame:CGRectMake(self.view.frame.size.width-120, self.view.frame.size.height - 60, 50, 50)];
    [attachButton setImage:[UIImage imageNamed:@"Attachment_Image.png"] forState:UIControlStateNormal];
    [attachButton setImage:[UIImage imageNamed:@"Attachment_Image.png"] forState:UIControlStateSelected];
    [attachButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    attachButton.tag = 2000;
    [self.view addSubview:attachButton];
    
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
    [createBrifTableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 
 */

@end
