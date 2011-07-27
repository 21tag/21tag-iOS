//
//  MapViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/22/11.
//  Copyright 2011. All rights reserved.
//

#import "MapViewController.h"
#import "AllPlacesViewController.h"
#import "PlaceDetailsViewController.h"
#import "PlaceAnnotation.h"
#import "ASIFormDataRequest.h"
#import "APIUtil.h"
#import "VenuesResp.h"

@implementation MapViewController
@synthesize currentMapView;
@synthesize locationController;
@synthesize user;
@synthesize dashboardController;
//@synthesize currentLocation;

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

- (void)setUser:(User *)newUser
{
    user = newUser;
    dashboardController.user = newUser;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"dash_button.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"dash_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(dashPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *dashButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = dashButton;

    self.title = @"Map and Activity";
    
    
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

    //locationController = [LocationController sharedInstance];
    //locationController.delegate = self;
    
    //PlaceAnnotation *someAnnotation = [[[PlaceAnnotation alloc] initWithLatitude:37.786521 longitude:-122.397850 ] autorelease];
    
    //[currentMapView addAnnotation:someAnnotation];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(locationUpdate:)
     name:@"LocationUpdateNotification"
     object:nil ];
}

- (void)locationUpdate:(CLLocation*)location
{
    //currentLocation = dashboardController.currentLocation;
    //dashboardController.currentLocation = location;

    //DEBUG: 42.377663,-71.116691 cambridge, ma
    //CLLocation *fakeLocation = [[CLLocation alloc] initWithLatitude:42.37672746056762 longitude:-71.11735687794877];
    //currentLocation = fakeLocation;
    
    
    if(!retreivedVenues)
        [self centerMapOnLocation:dashboardController.currentLocation];
}

-(void)centerMapOnLocation:(CLLocation *)location
{
    CLLocationCoordinate2D currentLocationCoordinate = location.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta = .01;
    span.longitudeDelta = .01;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = currentLocationCoordinate;
    
    [currentMapView setRegion:region animated:YES];
    
    [currentMapView regionThatFits:region];
    
    if(!retreivedVenues)
        [self getVenues];
}

-(void)getVenues
{
    //		return handleResponse(httpGet(HOST+"/getpois?lat="+lat+"&lon="+lng+"&num="+limit), new VenuesResp());

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getpois",[APIUtil host]]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setPostValue:[NSString stringWithFormat:@"%f",dashboardController.currentLocation.coordinate.latitude] forKey:@"lat"];
    [request setPostValue:[NSString stringWithFormat:@"%f",dashboardController.currentLocation.coordinate.longitude] forKey:@"lon"];
    [request setPostValue:@"50" forKey:@"num"];
    [request setDelegate:self];
    [request setTag:1];
    [request startAsynchronous];
    
    retreivedVenues = YES;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag == 1) // venues response
    {
        NSLog(@"venues:\n%@",[request responseString]);
        
        venuesResponse = [[VenuesResp alloc] initWithData:[request responseData]];

        //[self addAnnotations];
        [self refreshAnnotations];
    }
    else if(request.tag == 2) // venue details
    {
        PlaceDetailsViewController *placeDetailsController = [[PlaceDetailsViewController alloc] init];
        POIDetailResp *poiResponse = [[POIDetailResp alloc] initWithData:[request responseData]];
        
        placeDetailsController.poiResponse = poiResponse;
        placeDetailsController.mapViewController = self;
        [self.navigationController pushViewController:placeDetailsController animated:YES];
        [placeDetailsController release];
    }
}

- (void)addAnnotations
{
    NSArray *venues = venuesResponse.venues;
        NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:[venues count]];
    for(int i = 0; i < [venues count]; i++)
    {
        PlaceAnnotation *annotation = [[[PlaceAnnotation alloc] initWithVenue:[venues objectAtIndex:i]] autorelease];
        annotation.tag = i;
        [currentMapView addAnnotation:annotation];
        [annotations addObject:annotation];
    }
}

- (void)refreshAnnotations
{
    [currentMapView removeAnnotations:[currentMapView annotations]];
    [self addAnnotations];
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

- (void)locationError:(NSError *)error
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [locationController.locationManager stopUpdatingLocation];
}

-(void)dashPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)allPlacesPressed:(id)sender 
{
    AllPlacesViewController *allPlacesController = [[AllPlacesViewController alloc] init];
    allPlacesController.venuesResponse = venuesResponse;
    allPlacesController.mapViewController = self;
    allPlacesController.currentLocation = dashboardController.currentLocation;
    [self.navigationController pushViewController:allPlacesController animated:YES];
    [allPlacesController release];
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
    //[locationController.locationManager startUpdatingLocation];
    
    //[self locationUpdate:nil];
    [self getVenues];
    if(dashboardController.currentLocation)
        [self centerMapOnLocation:dashboardController.currentLocation];
}

- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id ) annotation {
    if (annotation == mapView.userLocation) { 
        return nil; 
    } 

    
	MKPinAnnotationView *customAnnotationView=[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil] autorelease];
	//UIImage *pinImage = [UIImage imageNamed:@"ReplacementPinImage.png"];
	//[customAnnotationView setImage:pinImage];
    PlaceAnnotation *currentPlaceAnnotation = (PlaceAnnotation*)annotation;
    //if([user.currentVenueId isEqualToString:[currentPlaceAnnotation.venue getId]])
    if([user.currentVenueName isEqualToString:currentPlaceAnnotation.venue.name])
    {
        customAnnotationView.pinColor = MKPinAnnotationColorGreen;
    }
    
    customAnnotationView.canShowCallout = YES;
    customAnnotationView.animatesDrop = NO;
	//UIImageView *leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"team_icon_placeholder.png"]];
	//customAnnotationView.leftCalloutAccessoryView = leftIconView;
	UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    PlaceAnnotation *placeAnnotation = (PlaceAnnotation*)annotation;
    [rightButton setTag:placeAnnotation.tag];
	[rightButton addTarget:self action:@selector(annotationViewClick:) forControlEvents:UIControlEventTouchUpInside];
	customAnnotationView.rightCalloutAccessoryView = rightButton;
    return customAnnotationView;
}
- (IBAction) annotationViewClick:(id) sender 
{
    PlaceAnnotation *ann = [currentMapView.selectedAnnotations objectAtIndex:([currentMapView.selectedAnnotations count]-1)];
    
    
    NSLog(@"Selected:%d", [ann tag]);
    
    Venue *venue = [[venuesResponse venues] objectAtIndex:ann.tag];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getpoidetails",[APIUtil host]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:[venue getId] forKey:@"poi"];
    [request setDelegate:self];
    [request setTag:2];
    [request startAsynchronous];
    

}

@end
