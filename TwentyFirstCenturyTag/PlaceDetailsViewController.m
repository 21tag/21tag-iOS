//
//  PlaceDetailsViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011. All rights reserved.
//

#import "PlaceDetailsViewController.h"
#import "ASIFormDataRequest.h"
#import "APIUtil.h"

#define kCellIdentifier @"Cell"

@implementation PlaceDetailsViewController
@synthesize activityIndicator;
@synthesize detailsScrollView;
@synthesize detailsImageView;
@synthesize placeNameLabel;
@synthesize yourPointsLabel;
@synthesize yourCheckinsLabel;
@synthesize yourTeamPointsLabel;
@synthesize yourTeamNameLabel;
@synthesize owningTeamNameLabel;
@synthesize owningTeamPointsLabel;
@synthesize detailsTableView;
@synthesize contentList;
@synthesize venue;
@synthesize dashboardController;
@synthesize poiResponse;
@synthesize mapViewController;

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
    [detailsScrollView release];
    [detailsImageView release];
    [placeNameLabel release];
    [yourPointsLabel release];
    [yourCheckinsLabel release];
    [yourTeamPointsLabel release];
    [yourTeamNameLabel release];
    [owningTeamNameLabel release];
    [owningTeamPointsLabel release];
    [detailsTableView release];
    [contentList release];
    [activityIndicator release];
    [super dealloc];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag == 1)
    {
        NSLog(@"checkin:\n%@",[request responseString]);
        
        
        //HOST+"/getuser?fbauthcode="+TagPreferences.AUTHCODE+"&user="+userid :
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getuser",[APIUtil host]]];
        ASIFormDataRequest *userRequest = [ASIFormDataRequest requestWithURL:url];
        [userRequest setPostValue:[defaults objectForKey:@"FBAccessTokenKey"] forKey:@"fbauthcode"];
        [userRequest setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
        [userRequest setDelegate:self];
        [userRequest setTag:2];
        [userRequest startAsynchronous];
    }
    else if(request.tag == 2)
    {
        NSLog(@"update user after checkin: %@",[request responseString]);
        
        
        dashboardController.user = [[User alloc] initWithData:[request responseData]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Checked In" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Cool!", nil];
        [alert show];
        [alert release];
        
        if(mapViewController)
        {
            [mapViewController centerMapOnLocation:dashboardController.currentLocation];
            [mapViewController refreshAnnotations];
        }
        
        [dashboardController.contentList replaceObjectAtIndex:0 withObject:[NSArray arrayWithObject:dashboardController.user.currentVenueName]];
        [dashboardController.navigationTableView reloadData];

    }
    else if(request.tag == 3)
    {
        NSLog(@"events: %@",[request responseString]);
        
        eventsResponse = [[Events alloc] initWithData:[request responseData]];
        
        NSMutableArray *eventsList = [[NSMutableArray alloc] initWithCapacity:[eventsResponse.events count]];
        for(Event *event in eventsResponse.events)
        {
            NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
            [cellInfo setObject:event.msg forKey:@"textLabel"];

            NSTimeInterval currentVenueTime =  event.time;
            NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
            
            NSTimeInterval time = currentTime - currentVenueTime;
            
            int hour, minute, second, day;
            hour = time / 3600;
            minute = (time - hour * 3600) / 60;
            second = (time - hour * 3600 - minute * 60);
            NSString *timeString;
            if(hour >= 24)
            {
                day = hour / 24;
                hour = hour - (day * 24);
                timeString = [NSString stringWithFormat:@"%d days %d hours", day, hour];
            }
            else
                timeString = [NSString stringWithFormat:@"%d hours %d minutes", hour, minute];
            
            [cellInfo setObject:[NSString stringWithFormat:@"%@ ago",timeString] forKey:@"detailTextLabel"];
            [eventsList addObject:cellInfo];

        }
        contentList = eventsList;
        [detailsTableView reloadData];
    }
            
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

-(void)setupButtons
{
    if(mapViewController)
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
        
        UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.leftBarButtonItem = mapButton;
        
        [mapButton release];
    }
    else
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonImage = [UIImage imageNamed:@"back_button.png"];
        UIImage *buttonImagePressed = [UIImage imageNamed:@"back_button_pressed.png"];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
        CGRect buttonFrame = [button frame];
        buttonFrame.size.width = buttonImage.size.width;
        buttonFrame.size.height = buttonImage.size.height;
        [button setFrame:buttonFrame];
        [button addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.leftBarButtonItem = backButton;
        
        [backButton release];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"checkin_button.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"checkin_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(checkinButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *checkinButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = checkinButton;
    
    [checkinButton release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Place Details";
    venue = poiResponse.poi;
    
    NSMutableDictionary *recentActivityDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
    [recentActivityDictionary setObject:@"Loading..." forKey:@"textLabel"];
    [recentActivityDictionary setObject:[NSDate date] forKey:@"detailTextLabel"];
    
    contentList = [[NSMutableArray alloc] initWithObjects:recentActivityDictionary, recentActivityDictionary, recentActivityDictionary, recentActivityDictionary, recentActivityDictionary, nil];
    
    detailsTableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];
    
    [self setupButtons];
    
    CGSize size = CGSizeMake(320.0f, 800.0f);
    [detailsScrollView setContentSize:size];
    
    placeNameLabel.text = venue.name;
    owningTeamNameLabel.text = poiResponse.owner.name;
    owningTeamPointsLabel.text = [NSString stringWithFormat:@"%ld",poiResponse.points];
    
    //owningTeamNameLabel.text = poiResponse.owner.name;

    //[activityIndicator startAnimating];
    
    //String user, String team, String venue, long time, int num
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getevents",[APIUtil host]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[venue getId] forKey:@"venue"];
    [request setPostValue:@"100" forKey:@"time"];
    [request setPostValue:@"10" forKey:@"num"];
    [request setTag:3];
    [request setDelegate:self];
    [request startAsynchronous];
    
    NSLog(@"get events for venue id: %@",[venue getId]);
    
    yourTeamNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"team_name"];
    
    if([poiResponse.owner.name isEqualToString:yourTeamNameLabel.text])
        yourTeamPointsLabel.text = owningTeamPointsLabel.text;
    else
    {
        
        
    }
    
    User *user = dashboardController.user;
    yourPointsLabel.text = [[user.points objectForKey:[venue getId]] description];
} 

- (IBAction)checkinButtonPressed:(id)sender 
{
    //params.add(new BasicNameValuePair("poi",venueid));
    //params.add(new BasicNameValuePair("user",TagPreferences.USER));
    //return handleResponse(httpPost(HOST+"/checkin", params), new SimpleResp());
    
    CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:venue.geolat longitude:venue.geolong];
    CLLocationDistance distanceToVenue = [dashboardController.currentLocation distanceFromLocation:venueLocation];
    //200 feet = 60.96 meters
    //distanceToVenue = 0; // DEBUG value
    if(distanceToVenue < 60.96 && dashboardController.currentLocation)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/checkin",[APIUtil host]]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:[venue getId] forKey:@"poi"];
        [request setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
        [request setDelegate:self];
        [request setTag:1];
        [request startAsynchronous];
        
        if(dashboardController.checkinTimer)
        {
            [dashboardController.checkinTimer invalidate];
            dashboardController.checkinTimer = [[NSTimer scheduledTimerWithTimeInterval:60 target:dashboardController selector:@selector(checkinUpdate:) userInfo:nil repeats:YES] retain];
        }
        else
            dashboardController.checkinTimer = [[NSTimer scheduledTimerWithTimeInterval:60 target:dashboardController selector:@selector(checkinUpdate:) userInfo:nil repeats:YES] retain];
        dashboardController.currentVenue = poiResponse.poi;
        dashboardController.checkinTime = [[NSDate date] retain];
    }
    else
    {
        //1 meter = 3.2808399 feet
        int distanceInFeet = (int)(distanceToVenue * 3.2808399);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Too Far" message:[NSString stringWithFormat:@"You are currently %d feet from this location. You must be within 200 feet to check in. Try getting closer!",distanceInFeet] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
    
    
}

-(void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setDetailsScrollView:nil];
    [self setDetailsImageView:nil];
    [self setPlaceNameLabel:nil];
    [self setYourPointsLabel:nil];
    [self setYourCheckinsLabel:nil];
    [self setYourTeamPointsLabel:nil];
    [self setYourTeamNameLabel:nil];
    [self setOwningTeamNameLabel:nil];
    [self setOwningTeamPointsLabel:nil];
    [self setDetailsTableView:nil];
    [self setContentList:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [contentList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
	}
	
	// get the view controller's info dictionary based on the indexPath's row
    NSDictionary *cellDictionary = [contentList objectAtIndex:indexPath.row];
	cell.textLabel.text = [cellDictionary objectForKey:@"textLabel"];
    cell.detailTextLabel.text = [[cellDictionary objectForKey:@"detailTextLabel"] description];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
	return cell;
}

@end
