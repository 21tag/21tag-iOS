//
//  ChooseNetworkViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011. All rights reserved.
//

#import "ChooseNetworkViewController.h"
#import "TwentyFirstCenturyTagAppDelegate.h"
#import "GameRequestViewController.h"
#import "LocationErrorViewController.h"
#import "JoinTeamViewController.h"
#import "DashboardViewController.h"
#import "FacebookController.h"

@implementation ChooseNetworkViewController

@synthesize facebook,harvardButton,campusesButton;

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
    self.title = @"Choose Network";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"facebook_minibutton.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(facebookPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* facebookButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = facebookButton;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];

    FacebookController *facebookController = [FacebookController sharedInstance];
    facebook = facebookController.facebook;
    UILabel * harvardLabel = [[UILabel alloc] initWithFrame:CGRectMake(3,0,240,56)];
    harvardLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
    harvardLabel.textColor = [UIColor darkGrayColor];
	harvardLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    harvardLabel.text = @"I'm on Harvard or MIT campuses";
    harvardLabel.backgroundColor = [UIColor clearColor];
    
    UILabel * campusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,215,47)];
    campusLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
    campusLabel.textColor = [UIColor darkGrayColor];
	campusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    campusLabel.text = @"I want to play on my campus!";
    campusLabel.backgroundColor = [UIColor clearColor];
    
    [harvardButton addSubview:harvardLabel];
    [campusesButton addSubview:campusLabel];
    //[self.harvardButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    //[self.campusesButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}

- (void)facebookPressed
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.destructiveButtonIndex == buttonIndex)
    {
        TwentyFirstCenturyTagAppDelegate *delegate = (TwentyFirstCenturyTagAppDelegate*)[[UIApplication sharedApplication] delegate];
        [facebook logout:delegate];
    }
}

- (void)locationUpdate:(CLLocation *)location
{
    [HUD hide:YES];
    
    //JoinTeamViewController *joinTeamController = [[JoinTeamViewController alloc] init];
    TwentyFirstCenturyTagAppDelegate *delegate = (TwentyFirstCenturyTagAppDelegate*)[[UIApplication sharedApplication] delegate];
    DashboardViewController *dashboardController = [[DashboardViewController alloc] init];
    delegate.dashboardController = dashboardController;
    
    NSArray *controllerArray = [NSArray arrayWithObjects:dashboardController, nil];
    [locationController.locationManager stopUpdatingLocation];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setViewControllers:controllerArray animated:YES];
    //[joinTeamController release];
}

- (void)locationError:(NSError *)error
{
    LocationErrorViewController *locationErrorController = [[LocationErrorViewController alloc] init];
    [locationController.locationManager stopUpdatingLocation];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:locationErrorController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (IBAction)harvardPressed:(id)sender 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"harvard" forKey:@"network"];
    [defaults synchronize];
    
    locationController = [LocationController sharedInstance];
    [locationController.locationManager startUpdatingLocation];
    locationController.delegate = self;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading...";
    
    [HUD show:YES];
}

- (IBAction)campusRequestPressed:(id)sender 
{
    GameRequestViewController *gameRequestController = [[GameRequestViewController alloc] init];
    [self presentModalViewController:gameRequestController animated:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}
@end
