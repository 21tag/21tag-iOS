//
//  SearchAllTeamsViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011. All rights reserved.
//

#import "SearchAllTeamsViewController.h"
#import "APIUtil.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "TeamsResp.h"
#import "TeamInfoViewController.h"

@implementation SearchAllTeamsViewController

@synthesize mainTableView;
@synthesize contentsList;
@synthesize searchResults;
@synthesize savedSearchTerm;


- (void)requestFinished:(ASIHTTPRequest *)request
{
    teamsResponse = [[TeamsResp alloc] initWithData:[request responseData]];
    
    NSLog(@"Teams: %@",[request responseString]);
    
    NSArray *teams = teamsResponse.teams;
    [contentsList removeAllObjects];
    for(int i = 0; i < [teams count]; i++)
    {
        [contentsList addObject:((Team*)[teams objectAtIndex:i])];
    }
    [mainTableView reloadData];
    
    isLoadingTeams = NO;
    [HUD hide:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"A network error has occurred. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
    // Save the state of the search UI so that it can be restored if the view is re-created.
    [self setSavedSearchTerm:[[[self searchDisplayController] searchBar] text]];
	
    [self setSearchResults:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Search Teams";
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
    
    
    //contentsList = [NSMutableArray arrayWithObjects:@"Loading...", nil];
    self.contentsList = [NSMutableArray array];
    isLoadingTeams = YES;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/team/?details=true",[APIUtil host]]]; //V1 "/getteam"
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    
    // Restore search term
    if ([self savedSearchTerm])
    {
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
    
    isSearching = NO;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    
    [HUD show:YES];
}

-(void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    [self setSavedSearchTerm:searchTerm];
	
    if ([self searchResults] == nil)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self setSearchResults:array];
        array = nil;
    }
	
    [[self searchResults] removeAllObjects];
	
    if ([[self savedSearchTerm] length] != 0)
    {
        for (Team *currentTeam in [self contentsList])
        {
            NSString *currentString = currentTeam.name;
            if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [[self searchResults] addObject:currentTeam];
            }
        }
    }
    
    isSearching = YES;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
	
    if (tableView == [[self searchDisplayController] searchResultsTableView])
        rows = [[self searchResults] count];
    else
        rows = [[self contentsList] count];
	
    NSLog(@"rows: %d",rows);
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *contentForThisRow = nil;
	
    if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        NSLog(@"Team description search: %@",((Team*)[[self searchResults] objectAtIndex:row]).description);
        contentForThisRow = ((Team*)[[self searchResults] objectAtIndex:row]).name;
    }
    else
    {  
        NSLog(@"Team description: %@",((Team*)[[self contentsList] objectAtIndex:row]).description);
        contentForThisRow = ((Team*)[[self contentsList] objectAtIndex:row]).name;
    }
	
    static NSString *CellIdentifier = @"CellIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
    [[cell textLabel] setText:contentForThisRow];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForTerm:searchString];
    
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self setSavedSearchTerm:nil];
	
    [[self mainTableView] reloadData];
    
    isSearching = NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!isLoadingTeams)
    {
        TeamInfoViewController *teamInfoController = [[TeamInfoViewController alloc] init];
        
        if(isSearching)
        {
            teamInfoController.teamName = ((Team*)[searchResults objectAtIndex:indexPath.row]).name;
            teamInfoController.teamId = ((Team*)[searchResults objectAtIndex:indexPath.row]).getId;
        }
        else
        {
            teamInfoController.teamName = ((Team*)[contentsList objectAtIndex:indexPath.row]).name;
            teamInfoController.teamId = ((Team*)[contentsList objectAtIndex:indexPath.row]).getId;
        }
        
        
        teamInfoController.isJoiningTeam = YES;
        teamInfoController.isOnTeam = NO;
        [self.navigationController pushViewController:teamInfoController animated:YES];
    }
       
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
