//
//  ProfileViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/23/11.
//  Copyright 2011. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIUtil.h"
#import "ASIFormDataRequest.h"
#define kCellIdentifier @"Cell"

@implementation ProfileViewController
@synthesize profileImageView;
@synthesize nameLabel;
@synthesize profileTableView;
@synthesize user;
@synthesize activityIndicator;
@synthesize teamNameLabel;
@synthesize teamInfoLabel;

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
    [profileImageView release];
    [nameLabel release];
    [profileTableView release];
    [activityIndicator release];
    [teamNameLabel release];
    [teamInfoLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag == 1) // team info
    {
        NSLog(@"team info:\n%@",[request responseString]);
        
        teamsResponse = [[TeamsResp alloc] initWithData:[request responseData]];
        NSArray *users = teamsResponse.users;
        NSMutableArray *userList = [[NSMutableArray alloc] initWithCapacity:[users count]];
        for(id element in users)
        {
            User *teamUser = (User*)element;
            NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
            [cellInfo setObject:[NSString stringWithFormat:@"%@ %@",teamUser.firstname,teamUser.lastname] forKey:@"textLabel"];
            NSTimeInterval currentVenueTime =  teamUser.currentVenueTime;
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
            
            [cellInfo setObject:[NSString stringWithFormat:@"%@ %@ ago",teamUser.currentVenueName,timeString] forKey:@"detailTextLabel"];
            [cellInfo setObject:[NSNumber numberWithDouble:time] forKey:@"time"];
            [userList addObject:cellInfo];
        }

        NSSortDescriptor *timeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES] autorelease];
        [userList sortUsingDescriptors:[NSArray arrayWithObjects:timeDescriptor,nil]];
        contentList = userList;
        [profileTableView reloadData];

        
        [activityIndicator stopAnimating];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];

    self.title = @"Profile";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getteam",[APIUtil host]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:user.teamname forKey:@"team"];
    [request setPostValue:@"true" forKey:@"details"];
    [request setDelegate:self];
    [request setTag:1];
    [request startAsynchronous];
    
    /*int teamPoints = 0;
    for(int i = 0; i < [teamsResponse.users count]; i++)
    {
        User *teamUser = [teamsResponse.users objectAtIndex:i];
        NSArray *points = teamUser.points;
        if(points)
        {
            for(int j = 0; j < [points count]; j++)
            {
                NSDictionary *point = [teamUser.points objectAtIndex:j];
                teamPoints += [[point objectForKey:@"p"] intValue];
            }
        }
    }*/
    
    teamNameLabel.text = user.teamname;
    //teamInfoLabel.text = [NSString stringWithFormat:@"%d points %d members",teamPoints,[teamsResponse.users count]];
    
    profileTableView.allowsSelection = NO;
}

- (void)viewDidUnload
{
    [self setProfileImageView:nil];
    [self setNameLabel:nil];
    [self setProfileTableView:nil];
    [self setActivityIndicator:nil];
    [self setTeamNameLabel:nil];
    [self setTeamInfoLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dashPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [contentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
	}
	
	// get the view controller's info dictionary based on the indexPath's row
    NSDictionary *cellInfo = [contentList objectAtIndex:indexPath.row];
	cell.textLabel.text = [cellInfo objectForKey:@"textLabel"];
    cell.detailTextLabel.text = [cellInfo objectForKey:@"detailTextLabel"];
    
    
	return cell;
}


@end
