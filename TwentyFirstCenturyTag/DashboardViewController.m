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

#import <QuartzCore/QuartzCore.h>

#define kCellIdentifier @"Cell"

@implementation DashboardViewController
@synthesize nameLabel;
@synthesize facebook;
@synthesize navigationTableView;
@synthesize contentList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    }
    else if(request.tag == 1) 
    {
        int statusCode = [request responseStatusCode];

        NSLog(@"%d: %@",statusCode, [request responseString]);
        
        if(statusCode == 403 || statusCode == 404)
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
        else
        {
            NSLog(@"logged in");
        }
        

    }
    else if(request.tag == 2) // create new account response
    {
        NSLog(@"new account: %@",[request responseString]);
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
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
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
    if(indexPath.section == 2) // avatar
    {
        cell.imageView.image = avatarImage;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 5.0;
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
    
    UIBarButtonItem *checkinButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = checkinButton;
    self.title = @"21st Century Tag";
    
    contentList = [[NSMutableArray alloc] init];
    NSArray *checkedInLocation = [NSArray arrayWithObject:@"Some Place"];
    
    [contentList addObject:checkedInLocation];
    
    NSArray *navigationOptions = [NSArray arrayWithObjects:@"Map and Activity", @"Your Vault", @"Your Team", @"Game Standings", nil];
    [contentList addObject:navigationOptions];
    
    NSArray *profileOption = [NSArray arrayWithObject:@"Profile"];
    [contentList addObject:profileOption];
    
    navigationTableView.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(![defaults objectForKey:@"team"])
    {
        JoinTeamViewController *joinTeamController = [[JoinTeamViewController alloc] init];
        [self.navigationController pushViewController:joinTeamController animated:NO];
        [joinTeamController release];
    }

}

- (void)checkinPressed
{
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) // Selected top item
    {
        PlaceDetailsViewController *placeDetailsController = [[PlaceDetailsViewController alloc] init];
        MapViewController *mapController = [[MapViewController alloc] init];

        NSArray *controllers = [NSArray arrayWithObjects:self, mapController, placeDetailsController,nil];
        [self.navigationController setViewControllers:controllers animated:YES];
        [placeDetailsController release];
        [mapController release];
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0) // Map and Activity
        {
            MapViewController *mapController = [[MapViewController alloc] init];
            [self.navigationController pushViewController:mapController animated:YES];
            [mapController release];
        }
        else if(indexPath.row == 1) // Your Vault
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming Soon" message:@"This feature is still under development. Check back later!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }
        else if(indexPath.row == 2) // Your Team
        {
            TeamInfoViewController *teamInfoController = [[TeamInfoViewController alloc] init];
            teamInfoController.isJoiningTeam = NO;
            [self.navigationController pushViewController:teamInfoController animated:YES];
            [teamInfoController release];
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
        [self.navigationController pushViewController:profileController animated:YES];
        profileController.profileImageView.image = avatarImage;
        profileController.nameLabel.text = [[contentList objectAtIndex:2] objectAtIndex:0];
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

@end
