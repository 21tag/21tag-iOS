//
//  NewTeamViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/21/11.
//  Copyright 2011. All rights reserved.
//

#import "NewTeamViewController.h"
#import "ASIFormDataRequest.h"
#import "APIUtil.h"
#import "Team.h"
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"

@interface NewTeamViewController()
-(void) setupButtons;
@end

@implementation NewTeamViewController
@synthesize teamImageView;
@synthesize nameTextField;
@synthesize mottoTextField;
@synthesize navigationBar;
@synthesize navigationItem;
@synthesize cancelButton;
@synthesize saveButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 1) {
        
    
        NSLog(@"new team:\n%@",[request responseString]);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        Team *team = [[Team alloc] initWithData:[request responseData]];
        
        [defaults setObject:team.name forKey:@"team_name"];
        [defaults setObject:team.getId forKey:@"team_id"];
        [defaults synchronize];
        
        if(teamImageView.image)
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/uploadavatar/",[APIUtil host]]]; //V1 "/createteam"
            ASIFormDataRequest *imageRequest = [ASIFormDataRequest requestWithURL:url];
            NSLog(@"Send Image with New Team");
            //[request setData:UIImageJPEGRepresentation(teamImageView.image, .7) forKey:@"image"];
            UIImage *tempTeamImage = [NewTeamViewController imageByScalingAndCroppingForSize:CGSizeMake(100.0f, 100.0f) Image:teamImageView.image];

            [imageRequest setData:UIImageJPEGRepresentation(tempTeamImage, 1) withFileName:[NSString stringWithFormat:@"%@.jpg",team.getId] andContentType:@"image/jpeg" forKey:@"image"];
            [imageRequest setPostValue:[NSString stringWithFormat:@"%@",team.getId] forKey:@"team_id"];
            [imageRequest setDelegate:self];
            [imageRequest setPostFormat:ASIMultipartFormDataPostFormat];
            [imageRequest addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
            [imageRequest setTag:2];
            [imageRequest startAsynchronous];
        }
        else {
            [self dismissModalViewControllerAnimated:YES];
            
        }
    }
    else
    {
        NSLog(@"Image response: %@",[request responseString]);
        [self dismissModalViewControllerAnimated:YES];
    }
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize Image: (UIImage *) image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;        
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else 
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }       
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];

    [self setupButtons];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)viewDidUnload
{
    [self setTeamImageView:nil];
    [self setNameTextField:nil];
    [self setMottoTextField:nil];
    [self setNavigationBar:nil];
    [self setNavigationItem:nil];
    [self setCancelButton:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupButtons
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"cancel_button.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"cancel_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
    
    cancelButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonImage = [UIImage imageNamed:@"save_button.png"];
    buttonImagePressed = [UIImage imageNamed:@"save_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(savePressed) forControlEvents:UIControlEventTouchUpInside];
    
    saveButton = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)cancelPressed
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)savePressed
{
    //return handleResponse(httpGet(HOST+"/createteam?user="+TagPreferences.USER+"&team="+team), new Team());
    nameTextField.text = [nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(![nameTextField.text isEqualToString:@""])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/team/",[APIUtil host]]]; //V1 "/createteam"
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        NSDictionary * dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[defaults objectForKey:@"user_id"],@"user_id",nameTextField.text,@"name",mottoTextField.text, @"motto", nil];
        NSLog(@"User: %@",[defaults objectForKey:@"user_id"]);
        NSLog(@"Team name: %@",nameTextField.text);
        NSLog(@"Team motto: %@",mottoTextField.text);
        NSLog(@"new team dict: %@",dictionary);
        [request appendPostData:[dictionary JSONData]];
        //[request setData:[dictionary JSONData] forKey:@"JSON"];
        if(teamImageView.image)
        {
            
            //[request setData:UIImageJPEGRepresentation(teamImageView.image, .7) forKey:@"image"];
            //[request setData:UIImageJPEGRepresentation(teamImageView.image, .7) withFileName:@"file" andContentType:@"image/jpeg" forKey:@"image"];
        }
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //[request setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
        //[request setPostValue:nameTextField.text forKey:@"team"];
        [request setRequestMethod:@"POST"];
        
        [request setTag:1];
        [request setDelegate:self];
        [request startAsynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Team Name Required" message:@"Please enter a team name and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    

}

- (IBAction)pickTeamImagePressed:(id)sender 
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Image from Camera",@"Image from Library",nil];
    [actionSheet showInView:self.view];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    
    if ([info objectForKey:@"UIImagePickerControllerEditedImage"]) //gets editedimage
        image =[info objectForKey:@"UIImagePickerControllerEditedImage"];
    else
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"]; //gets original image
    image = [NewTeamViewController imageByScalingAndCroppingForSize:CGSizeMake(100.0f, 100.0f) Image:image];
    teamImageView.image = image;
    teamImageView.layer.masksToBounds = YES;
    teamImageView.layer.cornerRadius = 7.0;
    [teamImageView setNeedsDisplay];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
        
    if(buttonIndex == 0) // Camera picked
    {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera Required" message:@"This device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    if(buttonIndex == 1) // Library picked
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentModalViewController:picker animated:YES];
}

@end
