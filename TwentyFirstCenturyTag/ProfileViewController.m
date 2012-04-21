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
#import "PlaceDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#define kCellIdentifier @"Cell"


@implementation ProfileViewController
@synthesize profileImageView;
@synthesize nameLabel;
@synthesize profileTableView;
@synthesize user;
@synthesize isYourProfile;
@synthesize dashboardController;
@synthesize numberMembers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
}

-(void)accountPressed
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.destructiveButtonIndex == buttonIndex)
    {
        TwentyFirstCenturyTagAppDelegate *delegate = (TwentyFirstCenturyTagAppDelegate*)[[UIApplication sharedApplication] delegate];
        Facebook *facebook = [FacebookController sharedInstance].facebook;
        [facebook logout:delegate];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"id"];
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"network"];
        [defaults removeObjectForKey:@"checkin_time"];
        [defaults removeObjectForKey:@"freinds"];
        [defaults removeObjectForKey:@"user_id"];
        [defaults removeObjectForKey:@"team_id"];
        [defaults removeObjectForKey:@"team_name"];
        [defaults synchronize];
        dashboardController.team = nil;
        dashboardController.user = nil;
        dashboardController.currentVenue = nil;
        dashboardController.checkinTime = nil;
        dashboardController.lastCheckinTime = nil;
        dashboardController.checkinTimer = nil;
        //[defaults removeObjectForKey:@"id"];
        //[defaults removeObjectForKey:@"id"];
        
        
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
    if(request.tag == 1) // user info
    {
        NSLog(@"User info:\n%@",[request responseString]);
        
        user = [[User alloc] initWithData:[request responseData]];
        //NSArray *users = teamsResponse.users;
        NSMutableArray *eventList = [[NSMutableArray alloc] initWithCapacity:[user.history count]];
        for(id element in user.history)
        {
            Event *event = (Event*)element;
            NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
            NSString * message = [event.msg stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ %@",user.firstname,user.lastname] withString:@""];
            message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            message = [message stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[message substringToIndex:1] uppercaseString]];
            
            [cellInfo setObject:[NSString stringWithFormat:@"%@",message] forKey:@"textLabel"];
            //NSTimeInterval currentVenueTime =  teamUser.currentVenueTime;
            //NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
            
            NSString *timeString = [APIUtil stringWithTimeDifferenceBetweenThen:event.time];
            
            NSTimeInterval time = [APIUtil timeIntervalFromThen:event.time];
            if(event.time)
                [cellInfo setObject:[NSString stringWithFormat:@"%@ ago",timeString] forKey:@"detailTextLabel"];
            else
                [cellInfo setObject:@"Inactive" forKey:@"detailTextLabel"];
            [cellInfo setObject:[NSNumber numberWithDouble:time] forKey:@"time"];
            [cellInfo setObject:event forKey:@"event"];
            [eventList addObject:cellInfo];
        }
        if([user.history count] == 0)
        {
            NSMutableDictionary *cellInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
            [cellInfo setObject:[NSString stringWithFormat:@"No Recent Activity"] forKey:@"textLabel"];
            [eventList addObject:cellInfo];
        }

        NSSortDescriptor *timeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
        [eventList sortUsingDescriptors:[NSArray arrayWithObjects:timeDescriptor,nil]];
        contentList = eventList;
        [profileTableView reloadData];

    }
    if(request.tag == 2) //team info
    {
        team = [[Team alloc] initWithData:[request responseData]];
        NSLog(@"team download: %@",team);
        [profileTableView reloadData];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];
    
    [self setupButtons];

    self.title = @"Profile";
    
    profileImageView.layer.masksToBounds = YES;
    profileImageView.layer.cornerRadius = 7.0;
    
   /* NSString * team;
    if(user.teamName)
        team = user.teamName;
    else
        team = user.teamId;
    */
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/%@/",[APIUtil host],[user getId]]]; //V1 "/getteam"
    NSLog(@"User Request from Profile: %@",[NSString stringWithFormat:@"%@/user/%@/",[APIUtil host],[user getId]]);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTag:1];
    [request startAsynchronous];
    
    NSURL * Teamurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/team/%@/?details=true",[APIUtil host],[user teamId]]]; //V1 "/getteam"
    NSLog(@"team id sent: %@",[user teamId]);
    ASIHTTPRequest *Teamrequest = [ASIHTTPRequest requestWithURL:Teamurl];
    [Teamrequest setRequestMethod:@"GET"];
    [Teamrequest setDelegate:self];
    [Teamrequest setTag:2];
    [Teamrequest startAsynchronous];
    

    
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
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
	
	
    if(indexPath.section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1];
        }
        NSLog(@"teamName from profileView: %@",user.teamName);
        if(user.teamName == @"")
        {
            cell.textLabel.text=@"You need to join a team to play";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else 
        {
            if(user.teamName)
                cell.textLabel.text = user.teamName;
            else
                cell.textLabel.text = user.teamId;
            
            if(team)
            {
                //Team *team = [teamsResponse.teams objectAtIndex:0];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d members",[team.users count]];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else
    {
        if ([[[contentList objectAtIndex:indexPath.row] objectForKey:@"textLabel"] isEqualToString:@"No Recent Activity"] || ((Event*)[[contentList objectAtIndex:indexPath.row] objectForKey:@"event"]).venueid == @"") 
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier2];
            }
            NSDictionary *cellInfo = [contentList objectAtIndex:indexPath.row];
            cell.textLabel.text = [cellInfo objectForKey:@"textLabel"];
            cell.detailTextLabel.text = [cellInfo objectForKey:@"detailTextLabel"];
            Event *theEvent = (Event*)[cellInfo objectForKey:@"event"];
            NSLog(@"Venue Id: %@",theEvent.venueid);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1];
            }
            NSDictionary *cellInfo = [contentList objectAtIndex:indexPath.row];
            cell.textLabel.text = [cellInfo objectForKey:@"textLabel"];
            cell.detailTextLabel.text = [cellInfo objectForKey:@"detailTextLabel"];
            Event *theEvent = (Event*)[cellInfo objectForKey:@"event"];
            NSLog(@"Venue Id: %@",theEvent.venueid);
            //nslcell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
        
    }
    
    
    
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        /*
        NSString *teamName;
        if(user.teamName)
            teamName = user.teamName;
        else
            teamName = user.teamId;
        teamInfoController.teamName = user.teamName;
        teamInfoController.teamId = user.teamId;
        teamInfoController.isJoiningTeam = NO;
        [self.navigationController pushViewController:teamInfoController animated:YES];
        [teamInfoController release];
         */
        if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryDisclosureIndicator)
        {
            JoinTeamViewController *joinTeamController = [[JoinTeamViewController alloc] init];
            [self.navigationController pushViewController:joinTeamController animated:YES];
        }
    }
    else
    {
        NSDictionary *cellInfo = [contentList objectAtIndex:indexPath.row];
        
        if([tableView cellForRowAtIndexPath:indexPath].selectionStyle == UITableViewCellSelectionStyleNone)
        {
            
        }
        else 
        {
            Event *theEvent = (Event*)[cellInfo objectForKey:@"event"];
            PlaceDetailsViewController *placeController = [[PlaceDetailsViewController alloc] init];
            placeController.venueId = theEvent.venueid;
            
            [self.navigationController pushViewController:placeController animated:YES]; 
        }
        
        
        
    }
    
    [profileTableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
