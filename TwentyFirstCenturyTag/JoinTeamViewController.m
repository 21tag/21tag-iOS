//
//  JoinTeamViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/21/11.
//  Copyright 2011. All rights reserved.
//

#import "JoinTeamViewController.h"
#import "NewTeamViewController.h"
#import "TeamInfoViewController.h"
#import "SearchAllTeamsViewController.h"

#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "APIUtil.h"
#import "TeamsByFBIDS.h"

#define kCellIdentifier @"Cell"

@implementation JoinTeamViewController

@synthesize statusImageView;
@synthesize contentList;
@synthesize navigationTableView;

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
    [navigationTableView release];
    [statusImageView release];
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
    self.title = @"Join a Team";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"cancel_button.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"cancel_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];
    
    navigationTableView.backgroundColor = [UIColor clearColor];
    navigationTableView.separatorColor = [UIColor lightGrayColor];
    
    NSMutableDictionary *createTeam = [[NSMutableDictionary alloc] initWithCapacity:1];
    [createTeam setObject:@"Create a new team" forKey:@"textLabel"];
    NSMutableDictionary *searchTeams = [[NSMutableDictionary alloc] initWithCapacity:1];
    [searchTeams setObject:@"Search all teams" forKey:@"textLabel"];

    contentList = [NSMutableArray arrayWithObjects:createTeam, searchTeams, nil];
    
    [contentList retain];
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if([defaults objectForKey:@"friends"])
        [self searchFriendsList];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(searchFriendsList)
     name:@"FriendsUpdatedNotification"
     object:nil ];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    
    [HUD show:YES];
}

- (void)searchFriendsList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getteamsbyfbids/",[APIUtil host]]]; //V1 "/getteamsbyfbids"
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //[request setPostValue:[defaults objectForKey:@"friends"] forKey:@"fbids"];
    //NSDictionary * dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[defaults objectForKey:@"friends"],@"fbids", nil];
    //NSLog(@"Friends: %@",[defaults objectForKey:@"friends"]);
    //NSLog(@"Class: %@",[[defaults objectForKey:@"friends"] class]);
    //[request appendPostData:[[defaults objectForKey:@"friends"]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostValue:[defaults objectForKey:@"friends"] forKey:@"fbids"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/text"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"SearchFreindList: %@",[request responseString]);
    
    TeamsByFBIDS *teamsByFBIDS = [[TeamsByFBIDS alloc] initWithData:[request responseData]];
    if(teamsByFBIDS.data)
    {
        NSMutableArray *emptyList = [[NSMutableArray alloc] initWithCapacity:2];
        [emptyList addObject:[contentList objectAtIndex:[contentList count]-2]];
        [emptyList addObject:[contentList objectAtIndex:[contentList count]-1]];
        contentList = emptyList;
        
        NSMutableArray *teamsArray = [[NSMutableArray alloc] initWithCapacity:[teamsByFBIDS.data count]];
        for(int i = 0; i < [teamsByFBIDS.data count]; i++)
        {
            TeamData *teamData = [teamsByFBIDS.data objectAtIndex:i];
            NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
            [cellInfo setObject:teamData.name forKey:@"textLabel"];
            [cellInfo setObject:teamData.team_id forKey:@"team_id"];
            NSString *friends;
            NSString *members;
            if(teamData.numFriends > 1)
                friends = @"friends";
            else
                friends = @"friend";
            if(teamData.numMembers > 1)
                members = @"members";
            else
                members = @"member";
            [cellInfo setObject:[NSString stringWithFormat:@"%d %@  %d %@",teamData.numFriends,friends,teamData.numMembers,members] forKey:@"detailTextLabel"];
            [teamsArray addObject:cellInfo];
        }
                
        contentList = [teamsArray arrayByAddingObjectsFromArray:contentList];
        [contentList retain];
        
        statusImageView.image = [UIImage imageNamed:@"found_teams"];
        [statusImageView setNeedsDisplay];
        [navigationTableView reloadData];
    }
    else
    {
        statusImageView.image = [UIImage imageNamed:@"no_found_teams.png"];
        [statusImageView setNeedsDisplay];
    }
    
    [HUD hide:YES];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
    [HUD hide:YES];
}

- (void)cancelPressed
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger count = [contentList count];
    if(indexPath.row == count-1 || indexPath.row == count-2)
        return 50.0f;
    else
        return 80.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    int count = [contentList count];
    BOOL isActualListContent = indexPath.row != count-1 || indexPath.row != count-2;
    
	if (cell == nil)
	{
        if(!isActualListContent)
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        else
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
	}
	
	// get the view controller's info dictionary based on the indexPath's row
    NSDictionary *cellInfo = [contentList objectAtIndex:indexPath.row];
	cell.textLabel.text = [cellInfo objectForKey:@"textLabel"];
    if(isActualListContent)
        cell.detailTextLabel.text = [cellInfo objectForKey:@"detailTextLabel"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.row == count-2)
    {
        cell.imageView.image = [UIImage imageNamed:@"new_team_table_icon.png"];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];      
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    else if(indexPath.row == count-1)
    {
        cell.imageView.image = [UIImage imageNamed:@"search_icon.png"];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];      
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    else
    {
        UIImage *icon = [UIImage imageNamed:@"team_icon_placeholder.png"];
        cell.imageView.image = icon;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0f];      
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    
	return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == [contentList count] - 2) // New Team
    {
        NewTeamViewController *newTeamController = [[NewTeamViewController alloc] init];
        [self presentModalViewController:newTeamController animated:YES];
        [newTeamController release];
    }
    else if(indexPath.row == [contentList count] - 1) // Search
    {
        SearchAllTeamsViewController *searchTeamsController = [[SearchAllTeamsViewController alloc] init];
        [self.navigationController pushViewController:searchTeamsController animated:YES];
        [searchTeamsController release];
    }
    else
    {
        TeamInfoViewController *teamInfoController = [[TeamInfoViewController alloc] init];
        teamInfoController.isJoiningTeam = YES;
        teamInfoController.teamName = [[contentList objectAtIndex:indexPath.row] objectForKey:@"textLabel"];
        teamInfoController.teamId = [[contentList objectAtIndex:indexPath.row] objectForKey:@"team_id"];
        [self.navigationController pushViewController:teamInfoController animated:YES];
        [teamInfoController release];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)viewDidUnload
{
    [self setNavigationTableView:nil];
    [self setStatusImageView:nil];
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
