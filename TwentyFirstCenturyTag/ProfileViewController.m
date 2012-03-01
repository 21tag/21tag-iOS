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
#import "TwentyFirstCenturyTagAppDelegate.h"
#import "FacebookController.h"
#import "TeamInfoViewController.h"
#define kCellIdentifier @"Cell"


@implementation ProfileViewController
@synthesize profileImageView;
@synthesize nameLabel;
@synthesize profileTableView;
@synthesize user;
@synthesize isYourProfile;
@synthesize dashboardController;

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
    [super dealloc];
}

-(void)setupButtons
{
    if(isYourProfile)
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
        
        UIBarButtonItem *dashButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.leftBarButtonItem = dashButton;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonImage = [UIImage imageNamed:@"account_button.png"];
        buttonImagePressed = [UIImage imageNamed:@"account_button_pressed.png"];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
        buttonFrame = [button frame];
        buttonFrame.size.width = buttonImage.size.width;
        buttonFrame.size.height = buttonImage.size.height;
        [button setFrame:buttonFrame];
        [button addTarget:self action:@selector(accountPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *accountButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.rightBarButtonItem = accountButton;
        
        [accountButton release];
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
}

-(void)accountPressed
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.destructiveButtonIndex == buttonIndex)
    {
        TwentyFirstCenturyTagAppDelegate *delegate = (TwentyFirstCenturyTagAppDelegate*)[[UIApplication sharedApplication] delegate];
        Facebook *facebook = [FacebookController sharedInstance].facebook;
        [facebook logout:delegate];
    }
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
            
            NSString *timeString = [APIUtil stringWithTimeDifferenceBetweenNow:currentTime then:currentVenueTime];
            
            NSTimeInterval time = currentTime - currentVenueTime;
            if(teamUser.currentVenueName)
                [cellInfo setObject:[NSString stringWithFormat:@"%@ %@ ago",teamUser.currentVenueName,timeString] forKey:@"detailTextLabel"];
            else
                [cellInfo setObject:@"Inactive" forKey:@"detailTextLabel"];
            [cellInfo setObject:[NSNumber numberWithDouble:time] forKey:@"time"];
            [cellInfo setObject:teamUser forKey:@"user"];
            [userList addObject:cellInfo];
        }

        NSSortDescriptor *timeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES] autorelease];
        [userList sortUsingDescriptors:[NSArray arrayWithObjects:timeDescriptor,nil]];
        contentList = userList;
        [profileTableView reloadData];

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];
    
    [self setupButtons];

    self.title = @"Profile";
    
    NSString * team;
    if(user.teamname)
        team = user.teamname;
    else
        team = user.team;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/team/%@/?details=true",[APIUtil host],user.team]]; //V1 "/getteam"
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    /*
    if(user.teamname)
        [request setPostValue:user.teamname forKey:@"team"];
    else
        [request setPostValue:user.team forKey:@"team"];
    */
    //[request setPostValue:@"true" forKey:@"details"];
    [request setRequestMethod:@"GET"];
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
    

    //teamInfoLabel.text = [NSString stringWithFormat:@"%d points %d members",teamPoints,[teamsResponse.users count]];
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",user.firstname,user.lastname];
    
    profileTableView.backgroundColor = [UIColor clearColor];
    
}

- (void)viewDidUnload
{
    [self setProfileImageView:nil];
    [self setNameLabel:nil];
    [self setProfileTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Team";
    else
        return @"Recent Activity";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 1;
    else
        return [contentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
	}
	
    if(indexPath.section == 0)
    {
        if(user.teamname)
            cell.textLabel.text = user.teamname;
        else
            cell.textLabel.text = user.team;
        
        if(teamsResponse)
        {
            //Team *team = [teamsResponse.teams objectAtIndex:0];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d members",[teamsResponse.users count]];
        }
    }
    else
    {
        NSDictionary *cellInfo = [contentList objectAtIndex:indexPath.row];
        cell.textLabel.text = [cellInfo objectForKey:@"textLabel"];
        cell.detailTextLabel.text = [cellInfo objectForKey:@"detailTextLabel"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        TeamInfoViewController *teamInfoController = [[TeamInfoViewController alloc] init];
        NSString *teamName;
        if(user.teamname)
            teamName = user.teamname;
        else
            teamName = user.team;
        teamInfoController.teamName = teamName;
        teamInfoController.teamId = user.team;
        teamInfoController.isJoiningTeam = NO;
        [self.navigationController pushViewController:teamInfoController animated:YES];
        [teamInfoController release];
    }
    else
    {
        NSDictionary *cellInfo = [contentList objectAtIndex:indexPath.row];
        
        ProfileViewController *profileController = [[ProfileViewController alloc] init];
        User *theUser = (User*)[cellInfo objectForKey:@"user"];
        profileController.user = theUser;
        [profileController.user retain];
        
        [self.navigationController pushViewController:profileController animated:YES];
        profileController.profileImageView.image = [UIImage imageNamed:@"team_icon_placeholder"];
        
        [profileController release];
        
    }
    
    [profileTableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
