//
//  AllPlacesViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/23/11.
//  Copyright 2011. All rights reserved.
//

#import "AllPlacesViewController.h"
#import "SearchPlacesViewController.h"
#import "PlaceDetailsViewController.h"
#import "ASIFormDataRequest.h"
#import "APIUtil.h"
#import "POIDetailResp.h"
#define kCellIdentifier @"Cell"

@implementation AllPlacesViewController
@synthesize placesTableView;
@synthesize venuesResponse;
@synthesize mapViewController;
@synthesize currentLocation;

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

    POIDetailResp *poiResponse = [[POIDetailResp alloc] initWithData:[request responseData]];
    
    NSMutableDictionary *cellInfo = [[contentList objectAtIndex:1] objectAtIndex:request.tag];
    
    Venue *venue = poiResponse.poi;
    CLLocation *venueLocation = [venue getLocation];
    CLLocationDistance distanceToVenue = [mapViewController.dashboardController.currentLocation distanceFromLocation:venueLocation];
    //200 feet = 60.96 meters
    //1 meter = 3.2808399 feet
    //int distanceInFeet = (int)(distanceToVenue * 3.2808399);
    
    NSString *detailTextLabel;
    if(poiResponse.owner.name)
        detailTextLabel = [NSString stringWithFormat:@"%d pts %@",poiResponse.points,poiResponse.owner.name];
    else
        detailTextLabel = [NSString stringWithFormat:@"%d pts",poiResponse.points,poiResponse.owner.name];
        
    [cellInfo setObject:detailTextLabel forKey:@"detailTextLabel"];
    [cellInfo setObject:poiResponse forKey:@"poiResponse"];
    
    if(distanceToVenue < 60.96)
    {
        [[contentList objectAtIndex:0] addObject:cellInfo];
    }
    [placesTableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[contentList objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Nearby Places";
    else
        return @"All Places";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
	}
	
	// get the view controller's info dictionary based on the indexPath's row
	NSArray *section = [contentList objectAtIndex:indexPath.section];
    NSDictionary *cellInfo = [section objectAtIndex:indexPath.row];
	cell.textLabel.text = [cellInfo objectForKey:@"textLabel"];
    cell.detailTextLabel.text = [cellInfo objectForKey:@"detailTextLabel"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *section = [contentList objectAtIndex:indexPath.section];
    NSDictionary *cellInfo = [section objectAtIndex:indexPath.row];
    
    if([cellInfo objectForKey:@"poiResponse"])
    {
        PlaceDetailsViewController *placeDetailsController = [[PlaceDetailsViewController alloc] init];        
        placeDetailsController.poiResponse = [cellInfo objectForKey:@"poiResponse"];
        placeDetailsController.mapViewController = mapViewController;
        [self.navigationController pushViewController:placeDetailsController animated:YES];
        [placeDetailsController release];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc
{
    [placesTableView release];
    [contentList release];
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
    
    self.title = @"All Places";
    
        
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];
    
    NSMutableArray *allPlacesList = [[NSMutableArray alloc] initWithCapacity:[venuesResponse.venues count]];
    contentList = [[NSMutableArray alloc] initWithCapacity:2];
    
    for(int i = 0; i < [venuesResponse.venues count]; i++)
    {
        Venue *venue = ((Venue*)[venuesResponse.venues objectAtIndex:i]);

        NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
        [cellInfo setObject:venue.name forKey:@"textLabel"];
        [cellInfo setObject:@"Loading..." forKey:@"detailTextLabel"];
        [allPlacesList addObject:cellInfo];
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getpoidetails",[APIUtil host]]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request addPostValue:[venue getId] forKey:@"poi"];
        [request setDelegate:self];
        [request setTag:i];
        [request startAsynchronous];
    }
    
    [contentList addObject:[[NSMutableArray alloc] init]];
    [contentList addObject:allPlacesList];
    [placesTableView reloadData];
    placesTableView.backgroundColor = [UIColor clearColor];
    
    [self setupButtons];
}

-(void)setupButtons
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"map_button.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"map_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = backButton;

    button = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonImage = [UIImage imageNamed:@"search_button.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(searchPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = searchButton;

    [backButton release];
    [searchButton release];
}

-(void)searchPressed
{
    SearchPlacesViewController *searchPlacesController = [[SearchPlacesViewController alloc] init];
    //searchPlacesController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //[self presentModalViewController:searchPlacesController animated:YES];
    searchPlacesController.mapViewController = mapViewController;
    searchPlacesController.venuesResponse = venuesResponse;
    [self.navigationController pushViewController:searchPlacesController animated:YES];
    [searchPlacesController release];
}

- (void)viewDidUnload
{
    [self setPlacesTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
