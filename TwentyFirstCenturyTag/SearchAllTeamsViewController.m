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

- (void)dealloc
{
    [mainTableView release], mainTableView = nil;
    [contentsList release], contentsList = nil;
    [searchResults release], searchResults = nil;
    [savedSearchTerm release], savedSearchTerm = nil;
	
    [super dealloc];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    teamsResponse = [[TeamsResp alloc] initWithData:[request responseData]];
    
    NSLog(@"Teams: %@",[request responseString]);
    
    NSArray *teams = teamsResponse.teams;
    [contentsList removeAllObjects];
    for(int i = 0; i < [teams count]; i++)
    {
        [contentsList addObject:((Team*)[teams objectAtIndex:i]).name];
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
    [alert release];
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
    
    [backButton release];
    
    contentsList = [NSMutableArray arrayWithObjects:@"Loading...", nil];
    [contentsList retain];
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
        [array release], array = nil;
    }
	
    [[self searchResults] removeAllObjects];
	
    if ([[self savedSearchTerm] length] != 0)
    {
        for (NSString *currentString in [self contentsList])
        {
            if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [[self searchResults] addObject:currentString];
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
	
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *contentForThisRow = nil;
	
    if (tableView == [[self searchDisplayController] searchResultsTableView])
        contentForThisRow = [[self searchResults] objectAtIndex:row];
    else
        contentForThisRow = [[self contentsList] objectAtIndex:row];
	
    static NSString *CellIdentifier = @"CellIdentifier";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
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
            teamInfoController.teamName = [searchResults objectAtIndex:indexPath.row];
        else
            teamInfoController.teamName = [contentsList objectAtIndex:indexPath.row];

        teamInfoController.isJoiningTeam = YES;
        [self.navigationController pushViewController:teamInfoController animated:YES];
        [teamInfoController release];
    }
       
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
