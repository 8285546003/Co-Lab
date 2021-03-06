//
//  LatestIdeaBriefsViewController.m
//  Co\Lab 
//
//  Created by magnon on 18/02/15.
//  Copyright (c) 2015 Magnon International. All rights reserved.
//

#import "LatestIdeaBriefsViewController.h"
#import "UIColor+PPColor.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "PPUtilts.h"



#define KEYBOARD_HEIGHT 216

#define kPP_FIRST   CGRectMake(headerView.frame.size.width-85 , 8, 25, 25)
#define kPP_SECOND  CGRectMake(headerView.frame.size.width-55 , 8, 25, 25)
#define kPP_THIRD   CGRectMake(headerView.frame.size.width-25 , 8, 25, 25)


#define kPP_FRAME_CLOSE CGRectMake(0, self.view.bounds.size.height - 60, 50, 50)
#define kPP_FRAME_ADD   CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - 60, 50, 50)


typedef enum{
    R,
    Y,
    G,
    B
} CardType;

typedef enum{
    Back,
    Add
} NavigationType;

typedef enum{
    CreateNewIdea,
    CreateNewBrief,
    AnswerTheBrief,
    Cancel
} ActionType;

@interface LatestIdeaBriefsViewController ()
@end

@implementation LatestIdeaBriefsViewController
@synthesize attachmentImage,allLatestIdeaAndBrief;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [PPUtilts sharedInstance].connected?[self getLatestIdeaBrief]:kCustomAlert(@"No NetWork", @"Something went wrong please check your WIFI connection");
    isAttachment = NO;
    self.attachmentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self settingBarButton];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)getLatestIdeaBrief{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = @"Please wait...";
    hud.detailsLabelText=@"Latest idea and brief will be populating";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
    
    NSDictionary *parameters = @{@"apicall":@"LatestIdeaBrief"};
    
    [manager POST:BASE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject valueForKey:@"Message"] isEqualToString:@"Success"]&&[[responseObject valueForKey:@"Error"] isEqualToString:@"false"]) {
            self.allLatestIdeaAndBrief=responseObject;
            [latestIdeaBrifTableView reloadData];
        }
        else{
            
        }

     [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
         [hud hide:YES];
        
    }];
    
    
//    NSDictionary *parameters = @{@"apicall":@"LatestIdeaBrief"};
//    
//    [[PPUtilts sharedInstance] GetData:parameters completionBlock:^(NSArray *data, NSError *error) {
//         self.allLatestIdeaAndBrief = data;
//        if(!error) {
//            dispatch_sync(dispatch_get_main_queue(), ^(void) {
//                [latestIdeaBrifTableView reloadData];
//            });
//        } else {
//            NSLog(@"error %@", error);
//        }
//    }];
    
    
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

    return [[self.allLatestIdeaAndBrief valueForKey:@"LatestIdeaBrief"] count];
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
        [[cell.contentView viewWithTag:indexPath.row+2] removeFromSuperview];
    }
    

    
    
    self.note = [[NoteView alloc] initWithFrame:CGRectMake(40, 0, cell.frame.size.width - 80, 200)];
    self.note.tag = indexPath.row+1;
    self.note.text = [[[self.allLatestIdeaAndBrief  valueForKey:@"LatestIdeaBrief"] valueForKey:@"headline"] objectAtIndex:indexPath.section];
    self.note.editable=NO;
    
    [cell.contentView addSubview:self.note];
    
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSString *strColorType=[[[self.allLatestIdeaAndBrief valueForKey:@"LatestIdeaBrief"] valueForKey:@"color_code"] objectAtIndex:indexPath.section];
    typedef void (^CaseBlockForColor)();
    NSDictionary *colorType = @{
                        @"R":
                            ^{[cell setBackgroundColor:[UIColor    PPRedColor]];},
                        @"Y":
                            ^{[cell setBackgroundColor:[UIColor    PPYellowColor]];},
                        @"G":
                            ^{ [cell setBackgroundColor:[UIColor    PPGreenColor]];},
                        @"B":
                            ^{ [cell setBackgroundColor:[UIColor    PPBlueColor]];}
                        };
    ((CaseBlockForColor)colorType[strColorType])(); // invoke the correct block of code
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-50,40)];
    UITextField* txtheader = [[UITextField alloc] init];
    txtheader.frame = CGRectMake(40,5, self.view.frame.size.width -80, 30);
    txtheader.textColor = [UIColor blackColor];
    txtheader.font = [UIFont systemFontOfSize:10.0];
    txtheader.text = [[[self.allLatestIdeaAndBrief valueForKey:@"LatestIdeaBrief"] valueForKey:@"tag"] objectAtIndex:section];
    txtheader.textAlignment = NSTextAlignmentLeft;
    [txtheader setBackgroundColor:[UIColor clearColor]];
    [txtheader setBorderStyle:UITextBorderStyleBezel];
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, txtheader.frame.size.height - borderWidth, txtheader.frame.size.width, txtheader.frame.size.height);
    border.borderWidth = borderWidth;
    [txtheader setEnabled:NO];
    [txtheader.layer addSublayer:border];
    txtheader.layer.masksToBounds = YES;
    
    
    BOOL isHot=[[[[self.allLatestIdeaAndBrief valueForKey:@"LatestIdeaBrief"] valueForKey:@"is_hot"] objectAtIndex:section] isEqualToString:@"No"]?NO:YES;
   //BOOL isBrief=[[[[self.allLatestIdeaAndBrief valueForKey:@"LatestIdeaBrief"] valueForKey:@"is_brief"] objectAtIndex:section] isEqualToString:@"No"]?NO:YES;
    
    
    NSString *strColorType=[[[self.allLatestIdeaAndBrief valueForKey:@"LatestIdeaBrief"] valueForKey:@"color_code"] objectAtIndex:section];
    typedef void (^CaseBlockForColor)();
    
    
    NSDictionary *colorType = @{
                                @"R":
                                    ^{
                                        [headerView setBackgroundColor:[UIColor    PPRedColor]];
        
                                        UIImageView* IdeaImage = [[UIImageView alloc] init];
                                        IdeaImage.image=[UIImage imageNamed:@"Create_New_Idea_Image.png"];
                                        IdeaImage.frame = CGRectMake(headerView.frame.size.width-85, 8, 25, 25);
                                        [headerView addSubview:IdeaImage];
                                        
                                        if (isHot) {
                                            UIImageView* hotImage = [[UIImageView alloc] init];
                                            hotImage.image=[UIImage imageNamed:@"red_plus_up.png"];
                                            hotImage.frame = CGRectMake(headerView.frame.size.width-55, 8, 25, 25);
                                            [headerView addSubview:hotImage];
                                        }
                                        
                                    },
                                @"Y":
                                    ^{
                                        [headerView setBackgroundColor:[UIColor    PPYellowColor]];
                                        
                                        UIImageView* newBriefImage = [[UIImageView alloc] init];
                                        newBriefImage.image=[UIImage imageNamed:@"Create_New_Idea_Image.png"];
                                        newBriefImage.frame = CGRectMake(headerView.frame.size.width-85 , 8, 25, 25);
                                        [headerView addSubview:newBriefImage];
                                        
                                        UIImageView* IdeaImage = [[UIImageView alloc] init];
                                        IdeaImage.image=[UIImage imageNamed:@"Create_New_Brief_Image.png"];
                                        IdeaImage.frame = CGRectMake(headerView.frame.size.width-55, 8, 25, 25);
                                        [headerView addSubview:IdeaImage];
                                        
                                        if (isHot) {
                                            UIImageView* hotImage = [[UIImageView alloc] init];
                                            hotImage.image=[UIImage imageNamed:@"red_plus_up.png"];
                                            hotImage.frame = CGRectMake(headerView.frame.size.width-25, 8, 25, 25);
                                            [headerView addSubview:hotImage];
                                        }
                                        
                                        
                                    },
                                @"G":
                                    ^{
                                        [headerView setBackgroundColor:[UIColor    PPGreenColor]];
                                    
                                    
                                        
                                        UIImageView* IdeaImage = [[UIImageView alloc] init];
                                        IdeaImage.image=[UIImage imageNamed:@"Create_New_Brief_Image.png"];
                                        IdeaImage.frame = CGRectMake(headerView.frame.size.width-85, 8, 25, 25);
                                        [headerView addSubview:IdeaImage];
                                        
                                        UIImageView* newBriefImage = [[UIImageView alloc] init];
                                        newBriefImage.image=[UIImage imageNamed:@"Create_New_Idea_Image.png"];
                                        newBriefImage.frame = CGRectMake(headerView.frame.size.width-55 , 8, 25, 25);
                                        [headerView addSubview:newBriefImage];
                                        
                                        if (isHot) {
                                            UIImageView* hotImage = [[UIImageView alloc] init];
                                            hotImage.image=[UIImage imageNamed:@"red_plus_up.png"];
                                            hotImage.frame = CGRectMake(headerView.frame.size.width-25, 8, 25, 25);
                                            [headerView addSubview:hotImage];
                                        }
                                        
                                        
                                    },
                                @"B":
                                    ^{
                                        [headerView setBackgroundColor:[UIColor    PPBlueColor]];
                                        
                                        UIImageView* IdeaImage = [[UIImageView alloc] init];
                                        IdeaImage.image=[UIImage imageNamed:@"Create_New_Brief_Image.png"];
                                        IdeaImage.frame = CGRectMake(headerView.frame.size.width-85, 8, 25, 25);
                                        [headerView addSubview:IdeaImage];
                                    
                                        if (isHot) {
                                            UIImageView* hotImage = [[UIImageView alloc] init];
                                            hotImage.image=[UIImage imageNamed:@"red_plus_up.png"];
                                            hotImage.frame = CGRectMake(headerView.frame.size.width-55, 8, 25, 25);
                                            [headerView addSubview:hotImage];
                                        }
                                        
                                    }
                                };
    
    ((CaseBlockForColor)colorType[strColorType])(); // invoke the correct block of code
    
     [headerView addSubview:txtheader];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.00f;
}

- (void)settingBarButton{
  
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, self.view.bounds.size.height - 60, 50, 50)];
    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"Close_Image.png"] forState:UIControlStateSelected];
    [closeButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.tag = 0;
    [self.view addSubview:closeButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(self.view.frame.size.width - 65, self.view.frame.size.height - 60, 50, 50)];
    [nextButton setImage:[UIImage imageNamed:@"red_plus_down.png"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"red_plus_down.png"] forState:UIControlStateSelected];
    [nextButton addTarget:self action:@selector(settingBarMethod:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = 1;
    [self.view addSubview:nextButton];
}

- (void)settingBarMethod:(UIButton *)settingBtn{
    NSLog(@"Button tag == %ld",(long)settingBtn.tag);
    switch (settingBtn.tag) {
        case Back:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case Add:
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
@end
