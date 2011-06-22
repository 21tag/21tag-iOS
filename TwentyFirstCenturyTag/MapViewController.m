//
//  MapViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController
@synthesize currentMapView;
@synthesize locationController;

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
    [currentMapView release];
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
    // Do any additional setup after loading the view from its nib.
    CLLocationCoordinate2D location;
    location.latitude = 37.250556;
    location.longitude = -96.358333;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 1.04*(126.766667 - 66.95) ;
    span.longitudeDelta = 1.04*(49.384472 - 24.520833) ;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = location;
    
    [currentMapView setRegion:region animated:NO];
    
    [currentMapView regionThatFits:region];

    locationController = [LocationController sharedInstance];
    locationController.delegate = self;
}

- (void)locationUpdate:(CLLocation*)location
{
    CLLocationCoordinate2D currentLocation = location.coordinate;
 
    NSLog(@"c: %f, %f",currentLocation.latitude, currentLocation.longitude);
    
    MKCoordinateSpan span;
    span.latitudeDelta = .01;
    span.longitudeDelta = .01;
    
    NSLog(@"s: %f, %f",span.latitudeDelta, span.longitudeDelta);

    
    MKCoordinateRegion region;
    region.span = span;
    region.center = currentLocation;
        
    [currentMapView setRegion:region animated:YES];
    
    [currentMapView regionThatFits:region];

}
- (void)locationError:(NSError *)error
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [locationController.locationManager stopUpdatingLocation];
}

- (void)viewDidUnload
{
    [self setCurrentMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)locationButtonPressed:(id)sender 
{
    [locationController.locationManager startUpdatingLocation];
}
@end
