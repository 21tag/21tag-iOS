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

- (void)dealloc
{
    [teamImageView release];
    [nameTextField release];
    [mottoTextField release];
    [navigationBar release];
    [navigationItem release];
    [cancelButton release];
    [saveButton release];
    [super dealloc];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"new team:\n%@",[request responseString]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    Team *team = [[Team alloc] initWithData:[request responseData]];
    
    [defaults setObject:team.name forKey:@"team_name"];
    [defaults synchronize];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    if(![nameTextField.text isEqualToString:@""])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/createteam",[APIUtil host]]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
        [request setPostValue:nameTextField.text forKey:@"team"];
        [request setDelegate:self];
        [request startAsynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Team Name Required" message:@"Please enter a team name and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)pickTeamImagePressed:(id)sender 
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Image from Camera",@"Image from Library",nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    teamImageView.image = image;
    teamImageView.layer.masksToBounds = YES;
    teamImageView.layer.cornerRadius = 4.0;
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
            [alert release];
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
    [picker release];
}

@end
