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
#import "JSONKit.h"

#import <QuartzCore/QuartzCore.h>

#define kCellIdentifier @"Cell"

@implementation DashboardViewController
@synthesize nameLabel;
@synthesize facebook;
@synthesize navigationTableView;
@synthesize contentList;
@synthesize user,team;
@synthesize checkinTimer;
@synthesize currentVenue;
@synthesize currentLocation;
@synthesize checkinTime, lastCheckinTime;
@synthesize locationController;
@synthesize checkinButton;
@synthesize checkoutButton;
@synthesize localPoints;

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
        if(location.horizontalAccuracy <= kCLLocationAccuracyHundredMeters)
        {
            //NSLog(@"location update: %f, %f %f",location.coordinate.latitude,location.coordinate.longitude, location.horizontalAccuracy);
            
            currentLocation = location;
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"LocationUpdateNotification"
             object:nil];
        }
        //NSLog(@"%f, %f, %f", kCLLocationAccuracyBest, kCLLocationAccuracyNearestTenMeters, kCLLocationAccuracyHundredMeters);
    }

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
    
    //200 feet = 60.96 meters
    //distanceToVenue = 0; // DEBUG value
    NSLog(@"checkinUpdate");
    if(currentLocation)
    {
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:currentVenue.geolat longitude:currentVenue.geolong];
        CLLocationDistance distanceToVenue = [currentLocation distanceFromLocation:venueLocation];
        if(distanceToVenue <= [APIUtil minDistanceMeters])
        {
            NSTimeInterval deltaTime = ABS([[NSDate date] timeIntervalSinceDate:lastCheckinTime]); 
            
            if(timer)
            {
                NSLog(@"Timer: %@",timer);
                if (localPoints)
                    localPoints ++;
                else
                    localPoints = 1;
                
                
            }
            if(deltaTime >= 180) //Should be 5mins (300)
            {
                NSLog(@"Points sent: %d",localPoints);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/%@/",[APIUtil host],[defaults objectForKey:@"user_id"]]]; //V1 "/checkin"
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                //[request setPostValue:[currentVenue getId] forKey:@"poi"];
                NSDictionary * dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[currentVenue getId],@"poi",[NSNumber numberWithInt:localPoints],@"points", nil];
                [request appendPostData:[dictionary JSONData]];
                [request addRequestHeader:@"Content-Type" value:@"application/json"];
                //[request setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
                [request setRequestMethod:@"PATCH"];
                //[request setDelegate:self];
                //[request setTag:1];
                [request startAsynchronous];
                
                lastCheckinTime = [NSDate date];
                localPoints = 0;
                NSLog(@"dashboard checkin request sent");
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
                    NSDate *currentTime = [NSDate date];
                    NSDate *templastCheckinTime = [defaults objectForKey:@"checkin_time"];

                    int points = 0;

                    if(templastCheckinTime)
                    {
                        NSTimeInterval deltaTime = [currentTime timeIntervalSinceDate:templastCheckinTime];
                        
                        
                        
                        NSLog(@"checkinTime: %f", deltaTime);
                        
                        points = (int) (deltaTime / 60);
                    }
                    
                    theNotification.alertBody = [NSString stringWithFormat:@"You've earned %d points. Now that you are %d feet from %@ you will be checked out if you do not get back within %d feet and check in this minute.",points,distanceInFeet,currentVenue.name, [APIUtil minDistanceFeet]];
                    theNotification.alertAction = @"Check-In";
                    
                    theNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:theNotification];
                    
                    [defaults setObject:[NSNumber numberWithBool:NO] forKey:@"send_distance_notification"];
                    
                }
                
            }
        }
    }
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
        isRequestingFriendsList = NO;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FriendsUpdatedNotification"
         object:nil ];
    }
    else
    {
        
        NSString *facebookID = [result objectForKey:@"id"];
        facebookRequestResults = (NSDictionary*) result;
        NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
        [defaults setObject:facebookID forKey:@"id"];

        // try to log in
        NSLog(@"Try to login");
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/%@/?fbauthcode=%@",[APIUtil host],[defaults objectForKey:@"user_id"],[defaults objectForKey:@"FBAccessTokenKey"]]];  //V1 "/login"
        //url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.33:8888/api/v2/user/123/?fbauthcode=%@",[defaults objectForKey:@"FBAccessTokenKey"]]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        //[formRequest addPostValue:[defaults objectForKey:@"FBAccessTokenKey"] forKey:@"fbauthcode"]; // @"?fbauthcode=" FBaccessTonkenKey
        [request setDelegate:self];
        
        [request setTag:1];
        [request startAsynchronous];

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
        avatarImage = [UIImage imageWithData:[request responseData]];
        [navigationTableView reloadData];
        
        profileFinishedLoading = YES;
        
        if(locationFinishedLoading && profileFinishedLoading)
            [HUD hide:YES];
    }
    else if(request.tag == 1) 
    {
        int statusCode = [request responseStatusCode];

        NSLog(@"%d: %@",statusCode, [request responseString]);
        
        if(statusCode == 404) // create new acct //V1 403
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *result = facebookRequestResults;
            NSString *facebookID = [result objectForKey:@"id"];
            NSString *email = [result objectForKey:@"email"];
            NSString *first_name = [result objectForKey:@"first_name"];
            NSString *last_name = [result objectForKey:@"last_name"];
            
            NSLog(@"Facebook ID: %@",facebookID);
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/",[APIUtil host]]]; //V1 "/adduser"
            //url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.33:8888/api/v2/user/"]];
            
            ASIHTTPRequest *formRequest = [ASIHTTPRequest requestWithURL:url];
            
            NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
            [dictionary setObject:[defaults objectForKey:@"FBAccessTokenKey"] forKey:@"fbauthcode"];
            [dictionary setObject:facebookID forKey:@"fid"];
            [dictionary setObject:email forKey:@"email"];
            [dictionary setObject:first_name forKey:@"firstname"];
            [dictionary setObject:last_name forKey:@"lastname"];
            NSData * JSON = [dictionary JSONData];
            [formRequest appendPostData:JSON];
            [formRequest addRequestHeader:@"Content-Type" value:@"application/json"];
            [formRequest setRequestMethod:@"POST"];
            [formRequest setDelegate:self];
            [formRequest setTag:2];
            [formRequest startAsynchronous];
        }
        else // log in response
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            user = [[User alloc] initWithData:[request responseData]];
            [defaults setObject:[user getId] forKey:@"user_id"];
            [defaults setObject:user.teamId forKey:@"team_id"];
            [defaults setObject:user.teamName forKey:@"team_name"];
            [defaults setObject:user.fid forKey:@"id"];
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
            [defaults removeObjectForKey:@"team_id"];
            [defaults synchronize];
            
            NSLog(@"new acct: %@", [user getId]);
            
            locationFinishedLoading = YES;
            
            if(locationFinishedLoading && profileFinishedLoading)
                [HUD hide:YES];
        }
        if ([[request responseString] isEqualToString:@"That username already exists"])
        {
            NSLog(@"get user_id");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/userfromfid/?fid=%@",[APIUtil host],[defaults objectForKey:@"id"]]];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request setRequestMethod:@"GET"];
            [request setDelegate:self];
            [request setTag:5];
            [request startAsynchronous];
            
        }
        else // reset fb auth code
        {    
        
        //		return handleResponse(httpGet(HOST+"/resetfbauth?uid="+TagPreferences.USER+"&fbid="+fbid+"&fbauthcode="+newFbAuthCode), new User());
         
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         NSDictionary *result = facebookRequestResults;
         NSString *facebookID = [result objectForKey:@"id"];
         NSString *user_id = [defaults objectForKey:@"user_id"];
         
         NSLog(@"resetting fbauth : %@",facebookID);
         
         NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/%@/",[APIUtil host],user_id]]; //V1 "/resetfbauth"
         
         ASIHTTPRequest *request = [ASIFormDataRequest requestWithURL:url];
         //[formRequest addPostValue:[defaults objectForKey:@"FBAccessTokenKey"] forKey:@"fbauthcode"];
         //[formRequest addPostValue:facebookID forKey:@"fbid"];
         //[formRequest addPostValue:user_id forKey:@"uid"];
            NSDictionary * dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[defaults objectForKey:@"FBAccessTokenKey"],@"fbauthcode", nil];
            NSData * JSON = [dictionary JSONData];
            [request appendPostData:JSON];
         [request setDelegate:self];
         [request setTag:4];
         [request setRequestMethod:@"PATCH"];
         [request startAsynchronous];
         }
    }
    else if(request.tag == 3) // request venue data
    {
        NSLog(@"poi resp: %@",[request responseString]);
        
        POIDetailResp *poiResponse = [[POIDetailResp alloc] initWithData:[request responseData]];
        //NSLog(@"POI Response: %@",poiResponse.poi.name);
        
        PlaceDetailsViewController *placeDetailsController = [[PlaceDetailsViewController alloc] init];
        placeDetailsController.poiResponse = poiResponse;
        //MapViewController *mapController = [[MapViewController alloc] init];
        //placeDetailsController.mapViewController = mapController;
        //mapController.dashboardController = self;
        //mapController.user = user;
        placeDetailsController.dashboardController = self;
        
        [HUD hide:YES];
        
        [self.navigationController pushViewController:placeDetailsController animated:YES];
    }
    else if(request.tag == 4) // reset auth code
    {
        if([request responseStatusCode] == 404) //V1 403
        {
            NSLog(@"reset fbauth error: %@", [request responseString]);

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Couldn't log in because resetfbauth doesn't work properly yet. Things will probably crash if you use the app beyond this point." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Bummer", nil];
            [alert show];
        }
        else
        {
            NSLog(@"reset fbauth complete: %@", [request responseString]);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            user = [[User alloc] initWithData:[request responseData]];
            [defaults setObject:[user getId] forKey:@"user_id"];
            [defaults setObject:user.teamName forKey:@"team_name"];
            [defaults setObject:user.teamId forKey:@"team_id"];
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
    else if(request.tag == 5)
    {
        NSLog(@"User id from fid: %@",[request responseData]);
        user = [[User alloc] initWithData:[request responseData]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        user = [[User alloc] initWithData:[request responseData]];
        [defaults setObject:[user getId] forKey:@"user_id"];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/%@/?fbauthcode=%@",[APIUtil host],user.getId,[defaults objectForKey:@"FBAccessTokenKey"]]];  //V1 "/login"
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request setDelegate:self];
        
        [request setTag:1];
        [request startAsynchronous];
        
        
    }
    [self updateDashboard:nil];
    NSLog(@"user teamName after request: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"team_name"]);
    NSLog(@"user teamId after request: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"team_id"]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
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
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
        else
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
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
            cell.imageView.layer.cornerRadius = 7.0;
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
        cell.imageView.layer.cornerRadius = 7.0;
    }
    else    // check in location
    {
        NSLog(@"Current Venue Last Time: %@",user.currentVenueLastTime);
        if(checkinTime)
        {
            
            NSString * timeString = [APIUtil StringWithTimeSince:checkinTime];
            
            cell.detailTextLabel.text = timeString;
            nameLabel.text = @"Currently Checked In";
        }
        else if(user.currentVenueLastTime != @"" && user.currentVenueLastTime )
        {
            NSString *timeString = [APIUtil stringWithTimeDifferenceBetweenThen:user.currentVenueLastTime];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Last checked in: %@ ago",timeString];
            nameLabel.text = @"Not Checked In";
        }
        else 
        {
            //cell.detailTextLabel.text = @"Problem";
            nameLabel.text = @"don't know where you checked in last";
            cell.textLabel.text = @"No Checkins";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
	return cell;
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
    
    if(![defaults objectForKey:@"team_id"])
    {
        JoinTeamViewController *joinTeamController = [[JoinTeamViewController alloc] init];
        [self.navigationController pushViewController:joinTeamController animated:NO];
    }

    locationController = [LocationController sharedInstance];
    locationController.delegate = self;
    [locationController.locationManager startUpdatingLocation];
    
    fiveMinuteCounter = 0;
    
    dashboardTimer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(updateDashboard:) userInfo:nil repeats:YES];
    
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
    
    /*if([nameLabel.text isEqualToString:@"Currently Checked In"])
    {
        NSLog(@"set checkout button");

        self.navigationItem.rightBarButtonItem = checkoutButton;
    }
    else
    {
        NSLog(@"set checkin button");

        self.navigationItem.rightBarButtonItem = checkinButton;
    }*/
    
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
}

- (void)checkinPressed
{
    MapViewController *mapController = [[MapViewController alloc] init];
    //mapController.user = user;
    mapController.dashboardController = self;
    [self.navigationController pushViewController:mapController animated:YES];
}

-(void)checkout
{
    NSLog(@"Points sent: %d",localPoints);
    if( localPoints >0 )
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/%@/",[APIUtil host],[defaults objectForKey:@"user_id"]]]; //V1 "/checkin"
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        //[request setPostValue:[currentVenue getId] forKey:@"poi"];
        NSDictionary * dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[currentVenue getId],@"poi",[NSNumber numberWithInt:localPoints],@"points", nil];
        [request appendPostData:[dictionary JSONData]];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        //[request setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
        [request setRequestMethod:@"PATCH"];
        //[request setDelegate:self];
        //[request setTag:1];
        [request startAsynchronous];
    }
    
    NSLog(@"dashboard checkout request sent");
    
    NSLog(@"Check in Timer before: %@",checkinTimer);
    NSLog(@"Checkin Time before: %@",checkinTime);
    [checkinTimer invalidate];
    checkinTimer = nil;
    checkinTime = nil;
    lastCheckinTime = nil;
    localPoints = 0;
    [navigationTableView reloadData];
    NSLog(@"Check in Timer after: %@",checkinTimer);
    NSLog(@"Checkin Time after: %@",checkinTime);
    
    self.navigationItem.rightBarButtonItem = checkinButton;
  
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
        [self checkout];
    }
}

- (void)settingsPressed
{
    SettingsViewController *settingsController = [[SettingsViewController alloc] init];
    [self presentModalViewController:settingsController animated:YES];
}

- (void) viewCurrentVenue
{
    if ([nameLabel.text isEqualToString:@"don't know where you checked in last"]) 
    {
        
    }
    else if(self.currentVenue)
    {
        //placeDetailsController
        //		return handleResponse(httpGet(HOST+"/getpoidetails?"+(poi != null ? "poi="+poi : "") +(ses != null ? (poi != null ? "&" : "") + "ses="+ses : "")), new POIDetailResp());
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        
        [HUD show:YES];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/poi/%@/",[APIUtil host],self.currentVenue.getId]]; //V1 "/getpoidetails"
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        //[request addPostValue:user.currentVenueId forKey:@"poi"];
        [request setDelegate:self];
        [request setRequestMethod:@"GET"];
        [request setTag:3];
        [request startAsynchronous];
    }
    else if(self.user.currentVenueId)
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        
        [HUD show:YES];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/poi/%@/",[APIUtil host],self.user.currentVenueId]]; //V1 "/getpoidetails"
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        //[request addPostValue:user.currentVenueId forKey:@"poi"];
        [request setDelegate:self];
        [request setRequestMethod:@"GET"];
        [request setTag:3];
        [request startAsynchronous];
        
    }
    else
    {
        //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Checked In" message:@"You must be checked in first." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        //[alert show];
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
        }
        else if(indexPath.row == 2) // Your Team
        {            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSLog(@"Team id from defaults: %@",[defaults objectForKey:@"team_id"]);
            
            if([defaults objectForKey:@"team_id"] == @"" || ![defaults objectForKey:@"team_id"])
            {
                JoinTeamViewController *joinTeamController = [[JoinTeamViewController alloc] init];
                [self.navigationController pushViewController:joinTeamController animated:YES];
            }
            else
            {
                TeamInfoViewController *teamInfoController = [[TeamInfoViewController alloc] init];
                teamInfoController.teamName = [defaults objectForKey:@"team_name"];
                teamInfoController.teamId = [defaults objectForKey:@"team_id"];
                
                NSLog(@"team_name from defaults in dashboard: %@",[defaults objectForKey:@"team_name"]);
                teamInfoController.isJoiningTeam = NO;
                teamInfoController.dashboardController = self;
                [self.navigationController pushViewController:teamInfoController animated:YES];
            }
        }
        else    // Game Standings
        {
            NetworkRankingsViewController *networkRankingsController = [[NetworkRankingsViewController alloc] init];
            networkRankingsController.dashboardController = self;
            [self.navigationController pushViewController:networkRankingsController animated:YES];
        }
    }
    else    // Your Profile
    {
        ProfileViewController *profileController = [[ProfileViewController alloc] init];
        profileController.user = user;
        //NSLog(@"profile: %@",user.teamname);

        profileController.isYourProfile = YES;
        [self.navigationController pushViewController:profileController animated:YES];
        profileController.profileImageView.image = avatarImage;
        //profileController.nameLabel.text = [[contentList objectAtIndex:2] objectAtIndex:0];
        

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
	HUD = nil;
}

@end
