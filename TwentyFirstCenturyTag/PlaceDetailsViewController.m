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
#import "JSONKit.h"

#define kCellIdentifier @"Cell"

@implementation PlaceDetailsViewController
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
@synthesize checkinButton;
@synthesize checkoutButton;
@synthesize venueId;

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
    if(request.tag == 1) //Checkin
    {
        NSLog(@"checkin:\n%@",[request responseString]);
        
        
        //HOST+"/getuser?fbauthcode="+TagPreferences.AUTHCODE+"&user="+userid :
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/%@/?fbauthcode=%@",[APIUtil host],[defaults objectForKey:@"user_id"],[defaults objectForKey:@"FBAccessTokenKey"] ]]; //V1 "/getuser"
        ASIHTTPRequest *userRequest = [ASIHTTPRequest requestWithURL:url];
        //[userRequest setPostValue:[defaults objectForKey:@"FBAccessTokenKey"] forKey:@"fbauthcode"];
        //[userRequest setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
        [userRequest setRequestMethod:@"GET"];
        [userRequest setDelegate:self];
        [userRequest setTag:2];
        [userRequest startAsynchronous];
    }
    else if(request.tag == 2)
    {
        NSLog(@"update user after checkin: %@",[request responseString]);
        
        [HUD hide:YES];
        
        dashboardController.user = [[User alloc] initWithData:[request responseData]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Checked In" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Cool!", nil];
        [alert show];
        
        if(mapViewController)
        {
            [mapViewController centerMapOnLocation:dashboardController.currentLocation];
            [mapViewController refreshAnnotations];
        }
        
        [dashboardController.contentList replaceObjectAtIndex:0 withObject:[NSArray arrayWithObject:dashboardController.user.currentVenueName]];
        [dashboardController.navigationTableView reloadData];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"send_distance_notification"];
        [defaults setObject:[NSDate date] forKey:@"checkin_time"];
        
        dashboardController.currentVenue = poiResponse.poi;
        dashboardController.checkinTime = [NSDate date];
        dashboardController.nameLabel.text = @"Currently Checked In";
        dashboardController.navigationItem.rightBarButtonItem = dashboardController.checkoutButton;
        self.navigationItem.rightBarButtonItem = checkoutButton;
        
        NSLog(@"checkin timer from place: %@",dashboardController.checkinTimer);
        if(dashboardController.checkinTimer)
        {
            [dashboardController.checkinTimer invalidate];
            dashboardController.checkinTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:dashboardController selector:@selector(checkinUpdate:) userInfo:nil repeats:YES];
        }
        else
            dashboardController.checkinTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:dashboardController selector:@selector(checkinUpdate:) userInfo:nil repeats:YES];

    }
    /*else if(request.tag == 3)
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
     */
    else if(request.tag == 4) //team info
    {
        NSLog(@"team info:\n%@",[request responseString]);
        
        Team * team = [[Team alloc] initWithData:[request responseData]];
        
        if ([team.poiPoints objectForKey:[venue getId]])
             yourTeamPointsLabel.text = [team.poiPoints objectForKey:[venue getId]];
        else
            yourTeamPointsLabel.text = @"0";
             
    }
    else if(request.tag == 5) //poi info
    {
        poiResponse = [[POIDetailResp alloc] initWithData:[request responseData]];
        venue = poiResponse.poi;
        [self updateData];
    }
    else if(request.tag == 6) //user info
    {
        user = [[User alloc] initWithData:[request responseData]];
        dashboardController.user = user;
        [self updateData];
    }
            
}

-(void) updateUser
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/%@/",[APIUtil host],  [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTag:6];
    [request startAsynchronous];
    
}

-(void) updateData
{
    placeNameLabel.text = venue.name;
    owningTeamNameLabel.text = poiResponse.ownerName;
    owningTeamPointsLabel.text = [NSString stringWithFormat:@"%ld",poiResponse.points];
    
    yourTeamNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"team_name"];
    
    if([poiResponse.ownerName isEqualToString:yourTeamNameLabel.text])
        yourTeamPointsLabel.text = owningTeamPointsLabel.text;
    
    NSLog(@"Venue as: %@",user);
    
    if([user.poiPoints objectForKey:[NSString stringWithFormat:@"%@", venue.getId]])
        yourPointsLabel.text = [user.poiPoints objectForKey:[venue getId]];
    else
        yourPointsLabel.text=@"0";
    
    //Load events
    NSMutableArray *eventsList = [[NSMutableArray alloc] initWithCapacity:[poiResponse.history count]];
    
    NSLog(@"History count: %d",[poiResponse.history count]);
    
    for(Event *event in poiResponse.history)
    {
        NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
        [cellInfo setObject:event.msg forKey:@"textLabel"];
        NSString *timeString;
        timeString = [APIUtil stringWithTimeDifferenceBetweenThen:event.time];
        
        [cellInfo setObject:[NSString stringWithFormat:@"%@ ago",timeString] forKey:@"detailTextLabel"];
        [eventsList addObject:cellInfo];
        
    }
    contentList = eventsList;
    [detailsTableView reloadData];

}

-(void)checkoutButtonPressed
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Check Out" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.destructiveButtonIndex == buttonIndex)
    {
        [dashboardController checkout];
        
        self.navigationItem.rightBarButtonItem = checkinButton;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
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
    
    checkinButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonImage = [UIImage imageNamed:@"checkout_button.png"];
    buttonImagePressed = [UIImage imageNamed:@"checkout_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(checkoutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    checkoutButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    if([dashboardController.nameLabel.text isEqualToString:@"Currently Checked In"])
        self.navigationItem.rightBarButtonItem = checkoutButton;
    else
        self.navigationItem.rightBarButtonItem = checkinButton;    
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
    
    //CGSize size = CGSizeMake(320.0f, 480.0f);
    
    //NSLog(@"\n\n%f,%f %f,%f %f,%f\n\n", detailsTableView.bounds.size.width, detailsTableView.bounds.size.height, detailsTableView.contentOffset.x, detailsTableView.contentOffset.y, detailsTableView.contentSize.height, detailsTableView.contentSize.width);
    
    //[detailsScrollView setContentSize:size];
    
    placeNameLabel.text = venue.name;
    owningTeamNameLabel.text = poiResponse.ownerName;
    owningTeamPointsLabel.text = [NSString stringWithFormat:@"%ld",poiResponse.points];
    
    //owningTeamNameLabel.text = poiResponse.owner.name;

    //[activityIndicator startAnimating];
    
    //String user, String team, String venue, long time, int num
    /*NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getevents",[APIUtil host]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[venue getId] forKey:@"venue"];
    [request setPostValue:[NSString stringWithFormat:@"%d",1000 * 60 * 60 * 24 * 3] forKey:@"time"];
    [request setPostValue:@"10" forKey:@"num"];
    [request setTag:3];
    [request setDelegate:self];
    [request startAsynchronous];
     */
    user = dashboardController.user;
    [self updateUser];
    
    /*
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/team/%@/?details=true",[APIUtil host],user.teamId]]; //V1 "/getteam"
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTag:4];
    [request startAsynchronous];
     */
    
    NSLog(@"get events for venue id: %@",[venue getId]);
    
    yourTeamNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"team_name"];
    
    if([poiResponse.ownerName isEqualToString:yourTeamNameLabel.text])
        yourTeamPointsLabel.text = owningTeamPointsLabel.text;
    else
    {
        NSLog(@"inside else");
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/team/%@/?details=true",[APIUtil host],[[NSUserDefaults standardUserDefaults] objectForKey:@"team_id"]]]; //V1 "/getteam"
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request setDelegate:self];
        [request setTag:4];
        [request startAsynchronous];
        
    }
    
    if (!venue) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/poi/%@/",[APIUtil host],venueId]]; //V1 "/getteam"
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request setDelegate:self];
        [request setTag:5];
        [request startAsynchronous];
    }
    
    if([user.poiPoints objectForKey:[venue getId]])
        yourPointsLabel.text = [user.poiPoints objectForKey:[venue getId]];
    else
        yourPointsLabel.text=@"0";
    
    NSLog(@"events list: %@",poiResponse.history);
    
    //Load events
    NSMutableArray *eventsList = [[NSMutableArray alloc] initWithCapacity:[poiResponse.history count]];
    
    NSLog(@"History count: %d",[poiResponse.history count]);
    
    for(Event *event in poiResponse.history)
    {
        NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
        [cellInfo setObject:event.msg forKey:@"textLabel"];
        NSString *timeString;
        timeString = [APIUtil stringWithTimeDifferenceBetweenThen:event.time];
        
        [cellInfo setObject:[NSString stringWithFormat:@"%@ ago",timeString] forKey:@"detailTextLabel"];
        [eventsList addObject:cellInfo];
        
    }
    contentList = eventsList;
    NSLog(@"Content List: %@",contentList);
    [detailsTableView reloadData];
    
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
    if(dashboardController.currentLocation)
    {
        if(distanceToVenue <= [APIUtil minDistanceMeters])
        {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.delegate = self;
            HUD.labelText = @"Checking In...";
            
            [HUD show:YES];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/%@/",[APIUtil host],[defaults objectForKey:@"user_id"]]]; //V1 /checkin
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            //[request setPostValue:[venue getId] forKey:@"poi"];
            //[request setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
            NSDictionary * dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[venue getId],@"poi", nil];
            [request appendPostData:[dictionary JSONData]];
            [request addRequestHeader:@"Content-Type" value:@"application/json"];
            [request setRequestMethod:@"PATCH"];
            [request setDelegate:self];
            [request setTag:1];
            [request startAsynchronous];
        }
        else
        {
            //1 meter = 3.2808399 feet
            int distanceInFeet = (int)(distanceToVenue * 3.2808399);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Too Far" message:[NSString stringWithFormat:@"You are currently %d feet from this location. You must be within %d feet to check in. Try getting closer!",distanceInFeet, [APIUtil minDistanceFeet]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Error" message:@"We haven't found an accurate enough location yet. Try connecting to Wifi or moving closer to a window." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
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
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
	}
	
	// get the view controller's info dictionary based on the indexPath's row
    NSDictionary *cellDictionary = [contentList objectAtIndex:indexPath.row];
	cell.textLabel.text = [cellDictionary objectForKey:@"textLabel"];
    cell.detailTextLabel.text = [[cellDictionary objectForKey:@"detailTextLabel"] description];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
	return cell;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}

@end
