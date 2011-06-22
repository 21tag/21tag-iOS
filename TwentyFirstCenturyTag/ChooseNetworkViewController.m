//
//  ChooseNetworkViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChooseNetworkViewController.h"
#import "TwentyFirstCenturyTagAppDelegate.h"
#import "GameRequestViewController.h"
#import "LocationErrorViewController.h"
#import "JoinTeamViewController.h"
#import "DashboardViewController.h"
#import "FacebookController.h"

@implementation ChooseNetworkViewController

@synthesize facebook;

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
    [super dealloc];
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
}

- (void)facebookPressed
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
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
    JoinTeamViewController *joinTeamController = [[JoinTeamViewController alloc] init];
    DashboardViewController *dashboardController = [[DashboardViewController alloc] init];
    NSArray *controllerArray = [NSArray arrayWithObjects:dashboardController, joinTeamController, nil];
    [locationController.locationManager stopUpdatingLocation];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setViewControllers:controllerArray animated:YES];
    [joinTeamController release];
    [dashboardController release];
}

- (void)locationError:(NSError *)error
{
    LocationErrorViewController *locationErrorController = [[LocationErrorViewController alloc] init];
    [locationController.locationManager stopUpdatingLocation];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:locationErrorController animated:YES];
    [locationErrorController release];
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
    locationController = [LocationController sharedInstance];
    [locationController.locationManager startUpdatingLocation];
    locationController.delegate = self;
}

- (IBAction)campusRequestPressed:(id)sender 
{
    GameRequestViewController *gameRequestController = [[GameRequestViewController alloc] init];
    [self presentModalViewController:gameRequestController animated:YES];
}
@end