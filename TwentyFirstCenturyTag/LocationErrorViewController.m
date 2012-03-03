//
//  LocationErrorViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011. All rights reserved.
//

#import "LocationErrorViewController.h"
#import "JoinTeamViewController.h"
#import "DashboardViewController.h"

@implementation LocationErrorViewController

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

- (void)locationUpdate:(CLLocation *)location
{
    JoinTeamViewController *joinTeamController = [[JoinTeamViewController alloc] init];
    DashboardViewController *dashboardController = [[DashboardViewController alloc] init];
    NSArray *controllerArray = [NSArray arrayWithObjects:dashboardController, joinTeamController, nil];
    [locationController.locationManager stopUpdatingLocation];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setViewControllers:controllerArray animated:YES];
}

- (void)locationError:(NSError *)error
{
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];
    locationController = [LocationController sharedInstance];
    locationController.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)checkLocationPressed:(id)sender 
{
    [locationController.locationManager startUpdatingLocation];
}
@end
