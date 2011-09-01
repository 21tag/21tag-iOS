//
//  DashboardViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011. All rights reserved.
//

#import "DashboardViewController.h"
#import "FacebookController.h"
#import "TeamInfoViewController.h"
#import "MapViewController.h"
#import "ProfileViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PlaceDetailsViewController.h"
#import "NetworkRankingsViewController.h"
#import "APIUtil.h"
#import "JoinTeamViewController.h"
#import "POIDetailResp.h"
#import "TwentyFirstCenturyTagAppDelegate.h"
#import "SettingsViewController.h"

#import <QuartzCore/QuartzCore.h>

#define kCellIdentifier @"Cell"

@implementation DashboardViewController
@synthesize nameLabel;
@synthesize facebook;
@synthesize navigationTableView;
@synthesize contentList;
@synthesize user;
@synthesize checkinTimer;
@synthesize currentVenue;
@synthesize currentLocation;
@synthesize checkinTime;
@synthesize locationController;
@synthesize checkinButton;
@synthesize checkoutButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)locationUpdate:(CLLocation*)location
{
    if(location)
    {
        currentLocation = location;
        [currentLocation retain];
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LocationUpdateNotification"
     object:nil];
    
    //NSLog(@"location update: %f, %f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    

}

- (void)locationError:(NSError *)error
{
    
}

-(void)updateDashboard:(NSTimer *)timer
{
    [navigationTableView reloadData];
}

- (void) checkinUpdate:(NSTimer *) timer
{
    CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:currentVenue.geolat longitude:currentVenue.geolong];
    CLLocationDistance distanceToVenue = [currentLocation distanceFromLocation:venueLocation];
    //200 feet = 60.96 meters
    //distanceToVenue = 0; // DEBUG value
    //NSLog(@"checkinUpdate");
    if(distanceToVenue < 91.44)
    {
        if(fiveMinuteCounter == 5)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/checkin",[APIUtil host]]];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request setPostValue:[currentVenue getId] forKey:@"poi"];
            [request setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
            //[request setDelegate:self];
            //[request setTag:1];
            [request startAsynchronous];
            NSLog(@"dashboard checkin");
        }
    }
    else
    {
        //1 meter = 3.2808399 feet
        
        
        
        if(currentVenue.name)
        {
            int distanceInFeet = (int)(distanceToVenue * 3.2808399);
            
            [self checkout];
                        
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if([[defaults objectForKey:@"send_distance_notification"] boolValue])
            {
                UILocalNotification * theNotification = [[UILocalNotification alloc] init];
                theNotification.alertBody = [NSString stringWithFormat:@"You are currently %d feet from %@. You must be within 300 feet to check in. You will be checked out automatically if you don't get closer and check-in again! You have one minute to return to the location and check-in again.",distanceInFeet,currentVenue.name];
                theNotification.alertAction = @"Check-In";
                
                theNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
                
                [[UIApplication sharedApplication] scheduleLocalNotification:theNotification];
                
                [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"send_distance_notification"];

            }
            
        }
    }
    
    if(fiveMinuteCounter == 5)
        fiveMinuteCounter = 0;
    else
        fiveMinuteCounter++;

    //[navigationTableView reloadData];

}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 420)
    {
        if(buttonIndex == 1) // check-in
        {
            /*if(checkinTimer)
            {
                [checkinTimer invalidate];
                checkinTimer = [[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(checkinUpdate:) userInfo:nil repeats:NO] retain];
            }
            else
                checkinTimer = [[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(checkinUpdate:) userInfo:nil repeats:NO] retain];*/
            [self viewCurrentVenue];
        }
    }
}

// Facebook request result
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if(isRequestingFriendsList)
    {
        NSArray *data = [result objectForKey:@"data"];
        NSMutableString *friendIDs = [[NSMutableString alloc] init];
        NSDictionary *friend;
        
        for(int i = 0; i < [data count]; i++)
        {
            if(i != 0) [friendIDs appendString:@","];
            friend = [data objectAtIndex:i];
            [friendIDs appendString:[friend objectForKey:@"id"]];
        }
        [defaults setObject:friendIDs forKey:@"friends"];
        [defaults synchronize];
        [friendIDs release];
        isRequestingFriendsList = NO;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FriendsUpdatedNotification"
         object:nil ];
    }
    else
    {
        
        NSString *facebookID = [result objectForKey:@"id"];
        facebookRequestResults = [(NSDictionary*) result retain];

        // try to log in
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/login",[APIUtil host]]];    
        ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
        [formRequest addPostValue:[defaults objectForKey:@"FBAccessTokenKey"] forKey:@"fbauthcode"];
        [formRequest setDelegate:self];
        [formRequest setTag:1];
        [formRequest startAsynchronous];

        NSArray *name = [NSArray arrayWithObject:[result objectForKey:@"name"]];
        [contentList replaceObjectAtIndex:2 withObject:name];
        
        NSString *avatarURLString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square",facebookID];
        NSURL *avatarURL = [NSURL URLWithString:avatarURLString];
        ASIHTTPRequest *pictureRequest = [ASIHTTPRequest requestWithURL:avatarURL];
        [pictureRequest setDelegate:self];
        [pictureRequest setTag:0];
        [pictureRequest startAsynchronous];
        
        [facebook requestWithGraphPath:@"me/friends" andDelegate:self];
        isRequestingFriendsList = YES;
    }

};

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag == 0)
    {
        avatarImage = [[UIImage imageWithData:[request responseData]] retain];
        [navigationTableView reloadData];
        
        profileFinishedLoading = YES;
        
        if(locationFinishedLoading && profileFinishedLoading)
            [HUD hide:YES];
    }
    else if(request.tag == 1) 
    {
        int statusCode = [request responseStatusCode];

        NSLog(@"%d: %@",statusCode, [request responseString]);
        
        if(statusCode == 403) // create new acct
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *result = facebookRequestResults;
            NSString *facebookID = [result objectForKey:@"id"];
            NSString *email = [result objectForKey:@"email"];
            NSString *first_name = [result objectForKey:@"first_name"];
            NSString *last_name = [result objectForKey:@"last_name"];
            
            NSLog(@"%@",facebookID);
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/adduser",[APIUtil host]]];
            
            ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
            [formRequest addPostValue:[defaults objectForKey:@"FBAccessTokenKey"] forKey:@"fbauthcode"];
            [formRequest addPostValue:@"true" forKey:@"nohtml"];
            [formRequest addPostValue:email forKey:@"email"];
            [formRequest addPostValue:first_name forKey:@"firstname"];
            [formRequest addPostValue:facebookID forKey:@"fid"];
            [formRequest addPostValue:last_name forKey:@"lastname"];
            [formRequest setDelegate:self];
            [formRequest setTag:2];
            [formRequest startAsynchronous];
        }
        else // log in response
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            user = [[User alloc] initWithData:[request responseData]];
            [defaults setObject:[user getId] forKey:@"user_id"];
            [defaults synchronize];
            
            NSLog(@"logged in: %@", [user getId]);
            
            if(user.currentVenueName)
            {
                [contentList replaceObjectAtIndex:0 withObject:[NSArray arrayWithObject:user.currentVenueName]];
                [navigationTableView reloadData];
            }
            else
            {
                [contentList replaceObjectAtIndex:0 withObject:[NSArray arrayWithObject:@"Not Checked In"]];
                [navigationTableView reloadData];

            }
            
            locationFinishedLoading = YES;
            
            if(locationFinishedLoading && profileFinishedLoading)
                [HUD hide:YES];
        }
        

    }
    else if(request.tag == 2) // create new account response
    {
        NSLog(@"new account: %@",[request responseString]);
        if(![[request responseString] isEqualToString:@""]) // create new acct
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            user = [[User alloc] initWithData:[request responseData]];
            [defaults setObject:[user getId] forKey:@"user_id"];
            [defaults removeObjectForKey:@"team_name"];
            [defaults synchronize];
            
            NSLog(@"new acct: %@", [user getId]);
            
            locationFinishedLoading = YES;
            
            if(locationFinishedLoading && profileFinishedLoading)
                [HUD hide:YES];
        }
        else // reset fb auth code
        {    
        
        //		return handleResponse(httpGet(HOST+"/resetfbauth?uid="+TagPreferences.USER+"&fbid="+fbid+"&fbauthcode="+newFbAuthCode), new User());
         
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         NSDictionary *result = facebookRequestResults;
         NSString *facebookID = [result objectForKey:@"id"];
         //NSString *user_id = [defaults objectForKey:@"user_id"];
         
         NSLog(@"resetting fbauth : %@",facebookID);
         
         NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/resetfbauth",[APIUtil host]]];
         
         ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
         [formRequest addPostValue:[defaults objectForKey:@"FBAccessTokenKey"] forKey:@"fbauthcode"];
         [formRequest addPostValue:facebookID forKey:@"fbid"];
         //[formRequest addPostValue:user_id forKey:@"uid"];
         [formRequest setDelegate:self];
         [formRequest setTag:4];
         [formRequest startAsynchronous];
         }
    }
    else if(request.tag == 3) // request venue data
    {
        NSLog(@"poi resp: %@",[request responseString]);
        
        POIDetailResp *poiResponse = [[POIDetailResp alloc] initWithData:[request responseData]];
        
        PlaceDetailsViewController *placeDetailsController = [[PlaceDetailsViewController alloc] init];
        placeDetailsController.poiResponse = poiResponse;
        //MapViewController *mapController = [[MapViewController alloc] init];
        //placeDetailsController.mapViewController = mapController;
        //mapController.dashboardController = self;
        //mapController.user = user;
        placeDetailsController.dashboardController = self;
        
        [HUD hide:YES];
        
        [self.navigationController pushViewController:placeDetailsController animated:YES];
        [placeDetailsController release];        
    }
    else if(request.tag == 4) // reset auth code
    {
        if([request responseStatusCode] == 403)
        {
            NSLog(@"reset fbauth error: %@", [request responseString]);

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Couldn't log in because resetfbauth doesn't work properly yet. Things will probably crash if you use the app beyond this point." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Bummer", nil];
            [alert show];
            [alert release];
        }
        else
        {
            NSLog(@"reset fbauth complete: %@", [request responseString]);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            user = [[User alloc] initWithData:[request responseData]];
            [defaults setObject:[user getId] forKey:@"user_id"];
            [defaults setObject:user.team forKey:@"team_name"];
            [defaults synchronize];
            
            NSLog(@"logged in: %@", [user getId]);
            
            if(user.currentVenueName)
            {
                [contentList replaceObjectAtIndex:0 withObject:[NSArray arrayWithObject:user.currentVenueName]];
                [navigationTableView reloadData];
            }
            else
            {
                [contentList replaceObjectAtIndex:0 withObject:[NSArray arrayWithObject:@"Not Checked In"]];
                [navigationTableView reloadData];
                nameLabel.text = @"Not Checked In";
            }
            
            locationFinishedLoading = YES;
            
            if(locationFinishedLoading && profileFinishedLoading)
                [HUD hide:YES];
        }      
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
    
    if(HUD)
        [HUD hide:YES];
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
};

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [contentList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[contentList objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
        if(indexPath.section == 0)
            cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
        else
            cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
	}
	
	// get the view controller's info dictionary based on the indexPath's row
	NSArray *section = [contentList objectAtIndex:indexPath.section];
	cell.textLabel.text = [section objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0) // Map and activity
        {
            cell.imageView.image = [UIImage imageNamed:@"map_icon.png"];
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.cornerRadius = 5.0;
        }
        else if(indexPath.row == 1) // Your vault
        {
            cell.imageView.image = [UIImage imageNamed:@"safe_icon.png"];
        }
        else if(indexPath.row == 2) // Your team
        {
            cell.imageView.image = [UIImage imageNamed:@"team_icon.png"];
        }
        else    // Game Standings
        {
            cell.imageView.image = [UIImage imageNamed:@"list_icon.png"];
        }
    }
    else if(indexPath.section == 2) // avatar
    {
        cell.imageView.image = avatarImage;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 5.0;
    }
    else    // check in location
    {
        if(checkinTime)
        {
            NSString *timeString = [APIUtil stringWithTimeDifferenceBetweenNow:[[NSDate date] timeIntervalSince1970] then:[checkinTime timeIntervalSince1970]];
            
            cell.detailTextLabel.text = timeString;
            nameLabel.text = @"Currently Checked In";
        }
        else if(user.currentVenueTime)
        {
            NSString *timeString = [APIUtil stringWithTimeDifferenceBetweenNow:[[NSDate date] timeIntervalSince1970] then:user.currentVenueTime];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Last checked in: %@ ago",timeString];
            nameLabel.text = @"Not Checked In";
        }
    }
    
	return cell;
}

- (void)dealloc
{
    [contentList release];
    [nameLabel release];
    [navigationTableView release];
    [avatarImage release];
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
    FacebookController *facebookController = [FacebookController sharedInstance];
    facebook = facebookController.facebook;
    
    [facebook requestWithGraphPath:@"me" andDelegate:self];

    [self setupButtons];

    self.title = @"21st Century Tag";
    
    contentList = [[NSMutableArray alloc] init];
    NSArray *checkedInLocation = [NSArray arrayWithObject:@"Loading..."];
    
    [contentList addObject:checkedInLocation];
    
    NSArray *navigationOptions = [NSArray arrayWithObjects:@"Map and Activity", @"Your Vault", @"Your Team", @"Game Standings", nil];
    [contentList addObject:navigationOptions];
    
    NSArray *profileOption = [NSArray arrayWithObject:@"Profile"];
    [contentList addObject:profileOption];
    
    navigationTableView.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(![defaults objectForKey:@"team_name"])
    {
        JoinTeamViewController *joinTeamController = [[JoinTeamViewController alloc] init];
        [self.navigationController pushViewController:joinTeamController animated:NO];
        [joinTeamController release];
    }

    locationController = [LocationController sharedInstance];
    locationController.delegate = self;
    [locationController.locationManager startUpdatingLocation];
    
    fiveMinuteCounter = 0;
    
    dashboardTimer = [[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateDashboard:) userInfo:nil repeats:YES] retain];
    
    profileFinishedLoading = NO;
    locationFinishedLoading = NO;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = @"Loading";
	
    [HUD show:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"view will appear");
    [locationController.locationManager startUpdatingLocation];
    
    if([nameLabel.text isEqualToString:@"Currently Checked In"])
    {
        NSLog(@"set checkout button");

        self.navigationItem.rightBarButtonItem = checkoutButton;
    }
    else
    {
        NSLog(@"set checkin button");

        self.navigationItem.rightBarButtonItem = checkinButton;
    }
    
    [self.navigationController.navigationBar setNeedsDisplay];
}

-(void)setupButtons
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"checkin_button.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"checkin_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(checkinPressed) forControlEvents:UIControlEventTouchUpInside];
    checkinButton = [[UIBarButtonItem alloc] initWithCustomView:button];    
    self.navigationItem.rightBarButtonItem = checkinButton;
    
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

    button = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonImage = [UIImage imageNamed:@"settings_button.png"];
    buttonImagePressed = [UIImage imageNamed:@"settings_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(settingsPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:button];    
    self.navigationItem.leftBarButtonItem = settingsButton;
    [settingsButton release];
}

- (void)checkinPressed
{
    MapViewController *mapController = [[MapViewController alloc] init];
    //mapController.user = user;
    mapController.dashboardController = self;
    [self.navigationController pushViewController:mapController animated:YES];
    [mapController release];
}

-(void)checkout
{
    [checkinTimer invalidate];
    checkinTime = nil;
    [navigationTableView reloadData];
    
    self.navigationItem.rightBarButtonItem = checkinButton;
  
}

-(void)checkoutButtonPressed
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Check Out" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    
    [actionSheet release];  
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.destructiveButtonIndex == buttonIndex)
    {
        [self checkout];
    }
}

- (void)settingsPressed
{
    SettingsViewController *settingsController = [[SettingsViewController alloc] init];
    [self presentModalViewController:settingsController animated:YES];
    [settingsController release];
}

- (void) viewCurrentVenue
{
    if(user.currentVenueName)
    {
        //placeDetailsController
        //		return handleResponse(httpGet(HOST+"/getpoidetails?"+(poi != null ? "poi="+poi : "") +(ses != null ? (poi != null ? "&" : "") + "ses="+ses : "")), new POIDetailResp());
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        
        [HUD show:YES];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getpoidetails",[APIUtil host]]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request addPostValue:user.currentVenueId forKey:@"poi"];
        [request setDelegate:self];
        [request setTag:3];
        [request startAsynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Checked In" message:@"You must be checked in first." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) // Selected top item
    {
        [self viewCurrentVenue];

    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0) // Map and Activity
        {
            [self checkinPressed];
        }
        else if(indexPath.row == 1) // Your Vault
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon" message:@"This feature is still under development. Check back later!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }
        else if(indexPath.row == 2) // Your Team
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if(![defaults objectForKey:@"team_name"])
            {
                JoinTeamViewController *joinTeamController = [[JoinTeamViewController alloc] init];
                [self.navigationController pushViewController:joinTeamController animated:YES];
                [joinTeamController release];
            }
            else
            {
                TeamInfoViewController *teamInfoController = [[TeamInfoViewController alloc] init];
                teamInfoController.teamName = [defaults objectForKey:@"team_name"];
                teamInfoController.isJoiningTeam = NO;
                teamInfoController.dashboardController = self;
                [self.navigationController pushViewController:teamInfoController animated:YES];
                [teamInfoController release];
            }
        }
        else    // Game Standings
        {
            NetworkRankingsViewController *networkRankingsController = [[NetworkRankingsViewController alloc] init];
            [self.navigationController pushViewController:networkRankingsController animated:YES];
            [networkRankingsController release];
        }
    }
    else    // Your Profile
    {
        ProfileViewController *profileController = [[ProfileViewController alloc] init];
        profileController.user = user;
        [profileController.user retain];
        //NSLog(@"profile: %@",user.teamname);

        profileController.isYourProfile = YES;
        [self.navigationController pushViewController:profileController animated:YES];
        profileController.profileImageView.image = avatarImage;
        //profileController.nameLabel.text = [[contentList objectAtIndex:2] objectAtIndex:0];
        

        [profileController release];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setNavigationTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
