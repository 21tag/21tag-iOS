//
//  GameRequestViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011. All rights reserved.
//

#import "GameRequestViewController.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@interface GameRequestViewController()

- (void)setupButtons;

@end

@implementation GameRequestViewController
@synthesize scrollView;
@synthesize schoolTextField;
@synthesize locationTextField;
@synthesize emailTextField;
@synthesize navigationItem;
@synthesize navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = NO;
	scrollView.pagingEnabled = YES;
    
    scrollView.contentSize = CGSizeMake(640, 416);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];
    scrollViewOriginalState = scrollView.contentOffset;
    isScrolledUp = NO;
    
    [self setupButtons];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
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
    [button addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    button = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonImage = [UIImage imageNamed:@"done_button.png"];
    buttonImagePressed = [UIImage imageNamed:@"done_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    doneButton = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setSchoolTextField:nil];
    [self setLocationTextField:nil];
    [self setEmailTextField:nil];
    [self setScrollView:nil];
    [self setNavigationItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)leftButtonPressed:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)sendRequestPressed:(id)sender 
{
    //			httpGet(HOST+"/ragsignup?app=true&campus="+URLEncoder.encode(campus, "UTF-8")+"&email="+email);
    if([schoolTextField.text isEqualToString:@""] || [locationTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"More Information" message:@"Please fill in the school and location fields and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Sending";
        
        [HUD show:YES];

        NSURL *url = [NSURL URLWithString:@"http://192.168.1.33:8888/api/v2/poi/"]; //V1 "/tagsignup"
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        NSString *campus = [NSString stringWithFormat:@"%@, %@",schoolTextField.text,locationTextField.text];
        NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:@"true" forKey:@"app"];
        [dictionary setObject:campus forKey:@"campus"];
        [dictionary setObject:emailTextField.text forKey:@"email"];
        [request appendPostData:[dictionary JSONData]];
        //[request setPostValue:@"true" forKey:@"app"];
        //[request setPostValue:campus forKey:@"campus"];
        //[request setPostValue:emailTextField.text forKey:@"email"];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(!isScrolledUp)
    {
        isScrolledUp = YES;
        CGPoint pt;
        //CGRect rc = [textField bounds];
        //rc = [textField convertRect:rc toView:scrollView];
        //pt = rc.origin;
        pt.x = 0.0f;
        pt.y = 127.0f;
        //NSLog(@"%f, %f",pt.x,pt.y);
        [scrollView setContentOffset:pt animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [scrollView setContentOffset:scrollViewOriginalState animated:YES];
    isScrolledUp = NO;
    [textField resignFirstResponder];
    return YES;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    self.navigationBar.topItem.title = @"Thanks!";
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    self.navigationItem.leftBarButtonItem = doneButton;

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}

@end
