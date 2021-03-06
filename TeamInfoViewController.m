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
#import "ProfileViewController.h"
#import "POIDetailResp.h"
#import "PlaceDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kCellIdentifier @"Cell"


@interface TeamInfoViewController()
    -(void)setupButtons;
@end

@implementation TeamInfoViewController
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
@synthesize isJoiningTeam,isOnTeam;
@synthesize contentList;
@synthesize mainTableView;
@synthesize teamName;
@synthesize teamId;
@synthesize dashboardController;
@synthesize team;

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
    if(request.tag == 1) // team info
    {
       NSLog(@"team info:\n%@",[request responseString]);
        
        team = [[Team alloc] initWithData:[request responseData]];
        if(team.getTeamImage)
            teamImage.image = team.getTeamImage;
        //NSArray *teams = teamsResponse.teams;
        //team = [teams objectAtIndex:0];
        NSSet *users = team.users;
        NSMutableArray *pointsList = [[NSMutableArray alloc] initWithCapacity:[users count]];
        for(User * user in users)
        {
            NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
            [cellInfo setObject:[NSString stringWithFormat:@"%@ %@",user.firstname,user.lastname] forKey:@"textLabel"];
            int points = [user.points intValue];

            [cellInfo setObject:[NSString stringWithFormat:@"%d points",points] forKey:@"detailTextLabel"];
            [cellInfo setObject:[NSNumber numberWithInt:points] forKey:@"points"];
            [cellInfo setObject:user forKey:@"user"];
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
                
                NSTimeInterval time = [APIUtil timeIntervalFromThen:user.currentVenueLastTime];
                NSString *timeString = [APIUtil stringwithFormatFrom:time];
                
                NSLog(@"Current Venue Name: %d",user.currentVenueName.length);
                if(user.currentVenueName.length != 0)
                    [cellInfo setObject:[NSString stringWithFormat:@"%@ %@ ago",user.currentVenueName,timeString] forKey:@"detailTextLabel"];
                else
                    [cellInfo setObject:@"Inactive" forKey:@"detailTextLabel"];
                [cellInfo setObject:[NSNumber numberWithDouble:time] forKey:@"time"];
                [cellInfo setObject:user forKey:@"user"];
                [userList addObject:cellInfo];
            }
            usersList = userList;
        }
        else
        {
            usersList = pointsList;
        }
        
        NSMutableArray *venueList = [[NSMutableArray alloc] initWithCapacity:[team.venues count]];
        for(Venue *venue in team.venues)
        {
            NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
            NSString * detailText = [NSString stringWithFormat:@"%@ points",[team.poiPoints objectForKey:venue.getId]];
            [cellInfo setObject:venue.name forKey:@"textLabel"];
            [cellInfo setObject:detailText forKey:@"detailTextLabel"];
            [cellInfo setObject:venue forKey:@"venue"];
            [venueList addObject:cellInfo];
        }
        locationsList = venueList;
        
        teamMembersLabel.text = [NSString stringWithFormat:@"%d",[team.users count]];
        int teamPoints = 0;
        int numVenues = 0;
        
        numVenues = [team.venues count];
        NSLog(@"Number of Venues: %d",numVenues);
        
        for(User * user in team.users)
        {
            int points = [user.points intValue];
            teamPoints +=points;
        }
        teamPointsLabel.text = [NSString stringWithFormat:@"%d",(teamPoints+dashboardController.localPoints)];
        locationsOwnedLabel.text = [NSString stringWithFormat:@"%d",numVenues];
        
        NSSortDescriptor *timeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
        [userList sortUsingDescriptors:[NSArray arrayWithObjects:timeDescriptor,nil]];
        NSSortDescriptor *pointsDescriptor = [[NSSortDescriptor alloc] initWithKey:@"points" ascending:NO];
        [pointsList sortUsingDescriptors:[NSArray arrayWithObjects:pointsDescriptor,nil]];

        [self teamMembersPressed:nil];
        [self refreshData];
    }
    else if(request.tag == 2) // join team
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //team = [[Team alloc] initWithData:[request responseData]];
        
        NSLog(@"joined team: %@", [request responseString]);
        [defaults setObject:team.name forKey:@"team_name"];
        [defaults setObject:team.getId forKey:@"team_id"];
        dashboardController.user.teamId = team.getId;
        dashboardController.user.teamName = team.name;
        [defaults synchronize];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(request.tag == 3) // leave team
    {
        NSLog(@"leave team: %@", [request responseString] );

        [self leaveTeamPostprocessing];
    }
    else if(request.tag == 4) // location info
    {
        NSLog(@"poi resp: %@",[request responseString]);
        
        POIDetailResp *poiResponse = [[POIDetailResp alloc] initWithData:[request responseData]];
        
        PlaceDetailsViewController *placeDetailsController = [[PlaceDetailsViewController alloc] init];
        placeDetailsController.poiResponse = poiResponse;
        //MapViewController *mapController = [[MapViewController alloc] init];
        //placeDetailsController.mapViewController = mapController;
        //mapController.dashboardController = self;
        //mapController.user = user;
        placeDetailsController.dashboardController = dashboardController;
        
        [self.navigationController pushViewController:placeDetailsController animated:YES];
        
    }
    else if(request.tag == 5) // switch team
    {
        NSLog(@"switch team: %@", [request responseString] );
        
        [self leaveTeamPostprocessing];
        
        [self joinTeam];
    }
    
    if(HUD)
        [HUD hide:YES];
}

-(void)leaveTeamPostprocessing
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"team_name"];
    [defaults removeObjectForKey:@"team_id"];
    [defaults synchronize];
    
    dashboardController.user.teamId = @"";
    dashboardController.user.teamName = @"";
    
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
    isOnTeam = NO;
    isJoiningTeam = YES;
    self.navigationItem.rightBarButtonItem = joinButton;
    

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * alertString = [NSString stringWithFormat:@"Are you sure you want to leave %@?  All of your points and places will be left behind.",dashboardController.user.teamName];
    if(actionSheet.tag == 1) //leave
    {
        if(actionSheet.destructiveButtonIndex == buttonIndex)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message: alertString delegate:self cancelButtonTitle:@"Stay" otherButtonTitles:@"Leave", nil];
            [alert setTag:1];
            [alert show];
        }
    }
    else if(actionSheet.tag == 2) //switch
    {
        if(actionSheet.destructiveButtonIndex == buttonIndex)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:alertString delegate:self cancelButtonTitle:@"Stay" otherButtonTitles:@"Switch", nil];
            [alert setTag:2];
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1) //leave
    {
        if(buttonIndex == 1) // Leave team confirmation
        {
            [self deleteFromTeam:NO];
        }

    }
    else if(alertView.tag == 2) // switch
    {
        if(buttonIndex == 1) // switch team confirmation
        {
            [self deleteFromTeam:YES];
        }
    }
}

- (void)deleteFromTeam:(BOOL)switchingTeam
{
    int tag = 3; // leaving team
    if(switchingTeam)
    {
        tag = 5; //switching team
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/%@/",[APIUtil host],[defaults objectForKey:@"user_id"]]]; //V1 "/deletefromteam"
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSDictionary * dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"new_team_id",nil];
    [request appendPostData:[dictionary JSONData]];
    //[request setPostValue:teamNameLabel.text forKey:@"team"];
    //[request setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setRequestMethod:@"PATCH"];
    [request setDelegate:self];
    [request setTag:tag];
    [request startAsynchronous]; 
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
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *globalTeamName = [defaults objectForKey:@"team_name"];
        isYourTeam = NO;
        
        if(globalTeamName)
        {
            if([globalTeamName isEqualToString:teamName])
                isYourTeam = YES;
        }
        
        if(isYourTeam)
        {
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
            

        }
        else
        {
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
            
        }
    }
}

-(void)joinPressed
{
    //		return handleResponse(httpGet(HOST+"/addtoteam?user="+TagPreferences.USER+"&team="+team), new Team());
    NSLog(@"isjoiningteam: %d",isJoiningTeam);
    if(isJoiningTeam && !isOnTeam)
    {
        [self joinTeam];
    }
    else
    {
        NSLog(@"switch");
        [self switchTeams];
    }
   
}

-(void)joinTeam
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/%@/",[APIUtil host],[defaults objectForKey:@"user_id"]]]; //V1 "/addtoteam"
    NSLog(@"url: %@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    //[request setPostValue:teamNameLabel.text forKey:@"team"];
    //[request setPostValue:[defaults objectForKey:@"user_id"] forKey:@"user"];
    NSDictionary * dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:teamId,@"new_team_id", nil];
    NSLog(@"add to team: %@",teamId);
    [request appendPostData:[dictionary JSONData]];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setRequestMethod:@"PATCH"];
    [request setDelegate:self];
    [request setTag:2];
    [request startAsynchronous]; 
}

-(void)switchTeams
{
    NSString * alertString = [NSString stringWithFormat:@"Are you really sure you want to leave your current team?  if you leave %@, all of your teammates will miss you so much.",dashboardController.user.teamName];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:alertString delegate:self cancelButtonTitle:@"Stay" destructiveButtonTitle:@"Leave" otherButtonTitles:nil];
    [actionSheet setTag:2];
    [actionSheet showInView:self.view];
}

/*-(void)leavePressed
{
    //		return handleResponse(httpGet(HOST+"/deletefromteam?user="+TagPreferences.USER+"&team="+team), new Team());
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Leave Team?" message:@"Are you sure you want to leave your team? You will lose your points and your teammates will miss you!" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert setTag:421];
    [alert show];
    [alert release];
}*/

- (void)leavePressed
{
    NSString * alertString = [NSString stringWithFormat:@"Are you really sure you want to leave your current team?  if you leave %@, all of your teammates will miss you so much.",dashboardController.user.teamName];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:alertString delegate:self cancelButtonTitle:@"Stay" destructiveButtonTitle:@"Leave" otherButtonTitles:nil];
    [actionSheet setTag:1];
    [actionSheet showInView:self.view];
}

- (void) refreshData
{
    NSLog(@"Team Name from team: %@",team.name);
    NSLog(@"Team Motto from team: %@",team.motto);
    self.teamNameLabel.text = team.name;
    self.teamSloganLabel.text = team.motto;
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
    [self refreshData];

    [self setupButtons];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];
    
    teamImage.layer.masksToBounds = YES;
    teamImage.layer.cornerRadius = 7.0;
    
    if(team.getTeamImage)
        teamImage.image = team.getTeamImage;
    
    //http://21tag.com:8689/getteam?team=moo&details=true
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/team/%@/?details=true",[APIUtil host],teamId]]; //V1 "/getteam" 
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    //[request setPostValue:teamNameLabel.text forKey:@"team"];
    //[request setPostValue:@"true" forKey:@"details"];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTag:1];
    [request startAsynchronous];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    
    [HUD show:YES];
    
    contentList = [[NSArray alloc] init];
    //usersList = [[NSArray alloc] init];
    //locationsList = [[NSArray alloc] init];
    //rankingsList = [[NSArray alloc] init];
    contentList = usersList;
    
    //mainTableView.allowsSelection = NO;
    
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
    
    teamMembersHighlighted = YES;
    locationsOwnedHighlighted = NO;
    teamPointsHighlighted = NO;
}

- (IBAction)locationsOwnedPressed:(id)sender 
{
    [teamMembersButton setImage:[UIImage imageNamed:@"team_members_deselected.png"] forState: UIControlStateNormal];
    [locationsOwnedButton setImage:[UIImage imageNamed:@"locations_owned_selected.png"] forState: UIControlStateNormal];
    [teamPointsButton setImage:[UIImage imageNamed:@"team_points_deselected.png"] forState:UIControlStateNormal];
    tableHeaderLabel.text = @"Owned Locations";
    contentList = locationsList;
    [mainTableView reloadData];
    
    teamMembersHighlighted = NO;
    locationsOwnedHighlighted = YES;
    teamPointsHighlighted = NO;
}

- (IBAction)teamPointsPressed:(id)sender 
{
    [teamMembersButton setImage:[UIImage imageNamed:@"team_members_deselected.png"] forState: UIControlStateNormal];
    [locationsOwnedButton setImage:[UIImage imageNamed:@"locations_owned_deselected.png"] forState: UIControlStateNormal];
    [teamPointsButton setImage:[UIImage imageNamed:@"team_points_selected.png"] forState:UIControlStateNormal];
    tableHeaderLabel.text = @"Members by Points";
    contentList = rankingsList;
    [mainTableView reloadData];
    
    teamMembersHighlighted = NO;
    locationsOwnedHighlighted = NO;
    teamPointsHighlighted = YES;
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
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
	}
	
	// get the view controller's info dictionary based on the indexPath's row
    NSDictionary *cellInfo = [contentList objectAtIndex:indexPath.row];
	cell.textLabel.text = [cellInfo objectForKey:@"textLabel"];
    cell.detailTextLabel.text = [cellInfo objectForKey:@"detailTextLabel"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(teamMembersHighlighted)
    {
        ProfileViewController *profileController = [[ProfileViewController alloc] init];
        User *user = (User*)[[usersList objectAtIndex:indexPath.row] objectForKey:@"user"];
        NSLog(@"Selected users id: %@",user.getId);
        profileController.user = user;
        
        [self.navigationController pushViewController:profileController animated:YES];
        profileController.profileImageView.image = [UIImage imageNamed:@"team_icon_placeholder"];
        
    }
    else if(locationsOwnedHighlighted)
    {
        Venue *venue = (Venue*)[[locationsList objectAtIndex:indexPath.row] objectForKey:@"venue"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/poi/%@/",[APIUtil host],[venue getId]]]; //V1 "/getpoidetails"
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        //[request addPostValue:[venue getId] forKey:@"poi"];
        [request setDelegate:self];
        [request setRequestMethod:@"GET"];  
        [request setTag:4];
        [request startAsynchronous];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        
        [HUD show:YES];
    }
    if(teamPointsHighlighted)
    {
        ProfileViewController *profileController = [[ProfileViewController alloc] init];
        User *user = (User*)[[rankingsList objectAtIndex:indexPath.row] objectForKey:@"user"];
        profileController.user = user;
        [self.navigationController pushViewController:profileController animated:YES];
        profileController.profileImageView.image = [UIImage imageNamed:@"team_icon_placeholder"];
        
    }
    
    [mainTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}

@end
