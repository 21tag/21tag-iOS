//
//  TeamInfoViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/22/11.
//  Copyright 2011. All rights reserved.
//

#import "TeamInfoViewController.h"
#import "DashboardViewController.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "APIUtil.h"
#import "TeamsResp.h"

#define kCellIdentifier @"Cell"


@interface TeamInfoViewController()
    -(void)setupButtons;
@end

@implementation TeamInfoViewController
@synthesize activityIndicator;
@synthesize teamImage;
@synthesize teamNameLabel;
@synthesize teamSloganLabel;
@synthesize teamMembersButton;
@synthesize locationsOwnedButton;
@synthesize teamPointsButton;
@synthesize tableHeaderLabel;
@synthesize teamMembersLabel;
@synthesize locationsOwnedLabel;
@synthesize teamPointsLabel;
@synthesize isJoiningTeam;
@synthesize contentList;
@synthesize mainTableView;
@synthesize teamName;

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
    [teamImage release];
    [teamNameLabel release];
    [teamSloganLabel release];
    [teamMembersButton release];
    [locationsOwnedButton release];
    [teamPointsButton release];
    [tableHeaderLabel release];
    [teamMembersLabel release];
    [locationsOwnedLabel release];
    [teamPointsLabel release];
    [activityIndicator release];
    [mainTableView release];
    [super dealloc];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag == 1) // team info
    {
       NSLog(@"team info:\n%@",[request responseString]);
    
        teamsResponse = [[TeamsResp alloc] initWithData:[request responseData]];
        NSArray *users = teamsResponse.users;
        NSMutableArray *pointsList = [[NSMutableArray alloc] initWithCapacity:[users count]];
        for(id element in users)
        {
            User *user = (User*)element;
            NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
            [cellInfo setObject:[NSString stringWithFormat:@"%@ %@",user.firstname,user.lastname] forKey:@"textLabel"];
            int points = 0;
            for(int i = 0; i < [user.points count]; i++)
            {
                NSDictionary *pointDictionary = [user.points objectAtIndex:i];
                points += [[pointDictionary objectForKey:@"p"] intValue];
            }
            [cellInfo setObject:[NSString stringWithFormat:@"%d points",points] forKey:@"detailTextLabel"];
            [cellInfo setObject:[NSNumber numberWithInt:points] forKey:@"points"];
            [pointsList addObject:cellInfo];
        }
        rankingsList = pointsList;
        
        NSMutableArray *userList = [[NSMutableArray alloc] initWithCapacity:[users count]];

        if(!isJoiningTeam) // team members content
        {
            for(id element in users)
            {
                User *user = (User*)element;
                NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
                [cellInfo setObject:[NSString stringWithFormat:@"%@ %@",user.firstname,user.lastname] forKey:@"textLabel"];
                NSTimeInterval currentVenueTime =  user.currentVenueTime;
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
                
                [cellInfo setObject:[NSString stringWithFormat:@"%@ %@ ago",user.currentVenueName,timeString] forKey:@"detailTextLabel"];
                [cellInfo setObject:[NSNumber numberWithDouble:time] forKey:@"time"];
                [userList addObject:cellInfo];
            }
            usersList = userList;
        }
        else
        {
            usersList = pointsList;
        }
        
        NSMutableArray *venueList = [[NSMutableArray alloc] initWithCapacity:[teamsResponse.venues count]];
        for(Venue *venue in teamsResponse.venues)
        {
            NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
            [cellInfo setObject:venue.name forKey:@"textLabel"];
            [cellInfo setObject:venue.address forKey:@"detailTextLabel"];
            [venueList addObject:cellInfo];
        }
        locationsList = venueList;
        
        teamMembersLabel.text = [NSString stringWithFormat:@"%d",[teamsResponse.users count]];
        int teamPoints = 0;
        int numVenues = 0;
        for(int i = 0; i < [teamsResponse.users count]; i++)
        {
            User *user = [teamsResponse.users objectAtIndex:i];
            NSArray *points = user.points;
            if(points)
            {
                for(int j = 0; j < [points count]; j++)
                {
                    NSDictionary *point = [user.points objectAtIndex:j];
                    teamPoints += [[point objectForKey:@"p"] intValue];
                }
            }
        }
        numVenues = [((Team*)[teamsResponse.teams objectAtIndex:0]).venues count];
        teamPointsLabel.text = [NSString stringWithFormat:@"%d",teamPoints];
        locationsOwnedLabel.text = [NSString stringWithFormat:@"%d",numVenues];
        
        NSSortDescriptor *timeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES] autorelease];
        [userList sortUsingDescriptors:[NSArray arrayWithObjects:timeDescriptor,nil]];
        NSSortDescriptor *pointsDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"points" ascending:NO] autorelease];
        [pointsList sortUsingDescriptors:[NSArray arrayWithObjects:pointsDescriptor,nil]];

        [self teamMembersPressed:nil];
        [activityIndicator stopAnimating];
    }
    else if(request.tag == 2) // join team
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        Team *team = [[Team alloc] initWithData:[request responseData]];
        
        NSLog(@"joined team: %@", [request responseString]);
        [defaults setObject:team.name forKey:@"team_name"];
        [defaults synchronize];
        [activityIndicator stopAnimating];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(request.tag == 3) // leave team
    {
        NSLog(@"leave team: %@", [request responseString] );
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"team_name"];
        [defaults synchronize];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonImage = [UIImage imageNamed:@"join_button.png"];
        UIImage *buttonImagePressed = [UIImage imageNamed:@"join_button_pressed.png"];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
        CGRect buttonFrame = [button frame];
        buttonFrame.size.width = buttonImage.size.width;
        buttonFrame.size.height = buttonImage.size.height;
        [button setFrame:buttonFrame];
        [button addTarget:self action:@selector(joinPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *joinButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.rightBarButtonItem = joinButton;
        
        [joinButton release];

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

-(void)setupButtons
{
    if(isJoiningTeam)
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
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonImage = [UIImage imageNamed:@"join_button.png"];
        buttonImagePressed = [UIImage imageNamed:@"join_button_pressed.png"];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
        buttonFrame = [button frame];
        buttonFrame.size.width = buttonImage.size.width;
        buttonFrame.size.height = buttonImage.size.height;
        [button setFrame:buttonFrame];
        [button addTarget:self action:@selector(joinPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *joinButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.rightBarButtonItem = joinButton;
        
        [joinButton release];
    }
    else
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *buttonImage = [UIImage imageNamed:@"dash_button.png"];
        UIImage *buttonImagePressed = [UIImage imageNamed:@"dash_button_pressed.png"];
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
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonImage = [UIImage imageNamed:@"leave_team_button.png"];
        buttonImagePressed = [UIImage imageNamed:@"leave_team_button_pressed.png"];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
        buttonFrame = [button frame];
        buttonFrame.size.width = buttonImage.size.width;
        buttonFrame.size.height = buttonImage.size.height;
        [button setFrame:buttonFrame];
        [button addTarget:self action:@selector(leavePressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leaveButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.rightBarButtonItem = leaveButton;
        
        [leaveButton release];
    }
}

-(void)joinPressed
{
    //		return handleResponse(httpGet(HOST+"/addtoteam?user="+TagPreferences.USER+"&team="+team), new Team());
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/addtoteam",[APIUtil host]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:teamNameLabel.text forKey:@"team"];
    [request setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
    [request setDelegate:self];
    [request setTag:2];
    [request startAsynchronous];    
}

-(void)leavePressed
{
    //		return handleResponse(httpGet(HOST+"/deletefromteam?user="+TagPreferences.USER+"&team="+team), new Team());

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/deletefromteam",[APIUtil host]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:teamNameLabel.text forKey:@"team"];
    [request setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
    [request setDelegate:self];
    [request setTag:3];
    [request startAsynchronous];    
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
    if(isJoiningTeam)
    {
        self.title = @"Team Info";
        tableHeaderLabel.text = @"Team Members";

    }
    else
    {
        self.title = @"Your Team";
        tableHeaderLabel.text = @"Recent Activity";
    }
    teamNameLabel.text = teamName;

    [self setupButtons];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];
    
    [activityIndicator startAnimating];
    
    //http://21tag.com:8689/getteam?team=moo&details=true
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getteam",[APIUtil host]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:teamNameLabel.text forKey:@"team"];
    [request setPostValue:@"true" forKey:@"details"];
    [request setDelegate:self];
    [request setTag:1];
    [request startAsynchronous];
    
    contentList = [[NSArray alloc] init];
    //usersList = [[NSArray alloc] init];
    //locationsList = [[NSArray alloc] init];
    //rankingsList = [[NSArray alloc] init];
    contentList = usersList;
    
    mainTableView.allowsSelection = NO;
    
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setTeamImage:nil];
    [self setTeamNameLabel:nil];
    [self setTeamSloganLabel:nil];
    [self setTeamMembersButton:nil];
    [self setLocationsOwnedButton:nil];
    [self setTeamPointsButton:nil];
    [self setTableHeaderLabel:nil];
    [self setTeamMembersLabel:nil];
    [self setLocationsOwnedLabel:nil];
    [self setTeamPointsLabel:nil];
    [self setActivityIndicator:nil];
    [self setMainTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)teamMembersPressed:(id)sender 
{
    [teamMembersButton setImage:[UIImage imageNamed:@"team_members_selected.png"] forState: UIControlStateNormal];
    [locationsOwnedButton setImage:[UIImage imageNamed:@"locations_owned_deselected.png"] forState: UIControlStateNormal];
    [teamPointsButton setImage:[UIImage imageNamed:@"team_points_deselected.png"] forState:UIControlStateNormal];
    if(isJoiningTeam)
    {
        tableHeaderLabel.text = @"Team Members";
    }
    else
    {
        tableHeaderLabel.text = @"Recent Activity";
    }
    contentList = usersList;
    [mainTableView reloadData];
}

- (IBAction)locationsOwnedPressed:(id)sender 
{
    [teamMembersButton setImage:[UIImage imageNamed:@"team_members_deselected.png"] forState: UIControlStateNormal];
    [locationsOwnedButton setImage:[UIImage imageNamed:@"locations_owned_selected.png"] forState: UIControlStateNormal];
    [teamPointsButton setImage:[UIImage imageNamed:@"team_points_deselected.png"] forState:UIControlStateNormal];
    tableHeaderLabel.text = @"Owned Locations";
    contentList = locationsList;
    [mainTableView reloadData];
}

- (IBAction)teamPointsPressed:(id)sender 
{
    [teamMembersButton setImage:[UIImage imageNamed:@"team_members_deselected.png"] forState: UIControlStateNormal];
    [locationsOwnedButton setImage:[UIImage imageNamed:@"locations_owned_deselected.png"] forState: UIControlStateNormal];
    [teamPointsButton setImage:[UIImage imageNamed:@"team_points_selected.png"] forState:UIControlStateNormal];
    tableHeaderLabel.text = @"Members by Points";
    contentList = rankingsList;
    [mainTableView reloadData];
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
