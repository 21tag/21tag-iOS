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
//@synthesize user;
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

/*- (void)setUser:(User *)newUser
{
    user = newUser;
    dashboardController.user = newUser;
}*/

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

    locationController = [LocationController sharedInstance];
    locationController.delegate = dashboardController;
    [locationController.locationManager startUpdatingLocation];
    
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

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/poi",[APIUtil host]]]; //V1 "/getpoisdetails"
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setPostValue:[NSString stringWithFormat:@"%f",dashboardController.currentLocation.coordinate.latitude] forKey:@"lat"];
    [request setPostValue:[NSString stringWithFormat:@"%f",dashboardController.currentLocation.coordinate.longitude] forKey:@"lon"];
    [request setPostValue:@"50" forKey:@"num"];
    [request setDelegate:self];
    [request setTag:1];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    
    retreivedVenues = YES;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag == 1) // venues response
    {
        NSLog(@"venues:\n%@",[request responseString]);
        
        //venuesResponse = [[VenuesResp alloc] initWithData:[request responseData]];
        multiPOIResponse = [[MultiPOIDetailResp alloc] initWithData:[request responseData]];
        
        //[self addAnnotations];
        [self refreshAnnotations];
    }
}

- (void)addAnnotations
{
    NSArray *venues = multiPOIResponse.pois;
    
    annotations = [[NSMutableArray alloc] initWithCapacity:[venues count]];
    for(int i = 0; i < [venues count]; i++)
    {
        PlaceAnnotation *annotation = [[[PlaceAnnotation alloc] initWithPOIDetailResp:[venues objectAtIndex:i]] autorelease];
        annotation.tag = i;
        [currentMapView addAnnotation:annotation];
        [annotations addObject:annotation];
    }
}

- (void)refreshAnnotations
{
    [currentMapView removeAnnotations:annotations];
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
    //[locationController.locationManager stopUpdatingLocation];
}

-(void)dashPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)allPlacesPressed:(id)sender 
{
    AllPlacesViewController *allPlacesController = [[AllPlacesViewController alloc] init];
    allPlacesController.multiPOIresponse = multiPOIResponse;
    allPlacesController.dashboardController = dashboardController;
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
    [dashboardController.locationController.locationManager startUpdatingLocation];
    
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
    if([dashboardController.user.currentVenueName isEqualToString:currentPlaceAnnotation.poiResponse.poi.name])
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
    
    PlaceDetailsViewController *placeDetailsController = [[PlaceDetailsViewController alloc] init];
    
    placeDetailsController.poiResponse = ann.poiResponse;
    placeDetailsController.mapViewController = self;
    placeDetailsController.dashboardController = dashboardController;
    [self.navigationController pushViewController:placeDetailsController animated:YES];
    [placeDetailsController release];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

@end
