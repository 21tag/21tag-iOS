//
//  NetworkRankingsViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/23/11.
//  Copyright 2011. All rights reserved.
//

#import "NetworkRankingsViewController.h"
#import "ASIFormDataRequest.h"
#import "APIUtil.h"
#import "Team.h"
#import "TeamInfoViewController.h"

@implementation NetworkRankingsViewController
@synthesize standingsTableView;
@synthesize dashboardController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"back_button.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"back_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationItem.leftBarButtonItem = backButton;
    
    
    self.title = @"Network Rankings";
    
    //just call http://HOST/standings?num=10  (no num defaults to 10)
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/team/?order_by=-points",[APIUtil host]]]; //V1 "/standings"
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setTag:1];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = @"Loading";
	
    [HUD show:YES];
}

- (void)viewDidUnload
{
    [self setStandingsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"standings response: %@", [request responseString]);
    NSData *requestData = [request responseData];
    //standingsResponse = [[StandingsResp alloc] initWithData:requestData];
    teamsResponse = [[TeamsResp alloc] initWithData:requestData];
    
    /*NSMutableArray *standingsTempArray = [NSMutableArray arrayWithArray:standingsResponse.teams];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"points"  ascending:YES];
    [standingsTempArray sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    standingsArray = standingsTempArray;*/
    
    standingsArray = teamsResponse.teams;
    if ([standingsArray count] > 10)
         standingsArray = [standingsArray subarrayWithRange:NSMakeRange(0, 10)];
    
    //standingsArray = standingsResponse.teams;
    
    if(HUD)
        [HUD hide:YES];
    
    [standingsTableView reloadData];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    if(HUD)
        [HUD hide:YES];

}

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [standingsArray count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Teams - Top 10";
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    //NSDictionary *teamData = [standingsArray objectAtIndex:indexPath.row];
    NSString *teamName = ((Team*)[standingsArray objectAtIndex:indexPath.row]).name;
    int points = [((Team*)[standingsArray objectAtIndex:indexPath.row]).points intValue];
    
    NSString *textLabel = [NSString stringWithFormat:@"%d. %@",indexPath.row+1,teamName];
    NSString *detailTextLabel = [NSString stringWithFormat:@"     %d points",points];
    
    cell.textLabel.text = textLabel;
    cell.detailTextLabel.text = detailTextLabel;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamInfoViewController *teamInfoController = [[TeamInfoViewController alloc] init];
    //NSDictionary *teamData = [standingsArray objectAtIndex:indexPath.row];
    NSString *teamName = ((Team*)[standingsArray objectAtIndex:indexPath.row]).name;
    
    teamInfoController.teamId = ((Team*)[standingsArray objectAtIndex:indexPath.row]).getId;
    teamInfoController.teamName = teamName;
    NSLog(@"Team info Controller id: %@",teamInfoController.teamId);
    NSLog(@"user team id: %@",dashboardController.user.teamId);
    if ([teamInfoController.teamId intValue] == [dashboardController.user.teamId intValue]) {
        teamInfoController.isJoiningTeam = NO;
        NSLog(@"NO");
    }
    else {
        teamInfoController.isJoiningTeam = YES;
    }
    teamInfoController.dashboardController = dashboardController;
    [self.navigationController pushViewController:teamInfoController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}

@end
