//
//  SearchPlacesViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011. All rights reserved.
//

#import "SearchPlacesViewController.h"
#import "PlaceDetailsViewController.h"
#import "POIDetailResp.h"
#import "ASIFormDataRequest.h"
#import "APIUtil.h"

@implementation SearchPlacesViewController


@synthesize mainTableView;
@synthesize contentsList;
@synthesize searchResults;
@synthesize savedSearchTerm;
@synthesize venuesResponse;
@synthesize dashController;

- (void)dealloc
{
    [mainTableView release], mainTableView = nil;
    [contentsList release], contentsList = nil;
    [searchResults release], searchResults = nil;
    [savedSearchTerm release], savedSearchTerm = nil;
	
//    [navBar release];
//    [navItem release];
    [super dealloc];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    POIDetailResp *poiResponse = [[POIDetailResp alloc] initWithData:[request responseData]];
    
    PlaceDetailsViewController *placeDetailsController = [[PlaceDetailsViewController alloc] init];        
    placeDetailsController.poiResponse = poiResponse;
    placeDetailsController.dashboardController = dashController;
    [self.navigationController pushViewController:placeDetailsController animated:YES];
    [placeDetailsController release];
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
//    [self setNavBar:nil];
//    [self setNavItem:nil];
    [super viewDidUnload];
	
    // Save the state of the search UI so that it can be restored if the view is re-created.
    [self setSavedSearchTerm:[[[self searchDisplayController] searchBar] text]];
	
    [self setSearchResults:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Search Places";
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
    

    contentsList = [[NSMutableArray alloc] initWithCapacity:[venuesResponse.venues count]];
    venuesSearchResults = [[NSMutableArray alloc] initWithCapacity:[venuesResponse.venues count]];
    
    for(Venue *venue in venuesResponse.venues)
    {
        [contentsList addObject:venue.name];
    }
    
    [contentsList retain];
    
    // Restore search term
    if ([self savedSearchTerm])
    {
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
    
    isSearching = NO;
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
    [venuesSearchResults removeAllObjects];
	
    if ([[self savedSearchTerm] length] != 0)
    {
        int i = 0, k = 0;
        for (NSString *currentString in [self contentsList])
        {
            if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [[self searchResults] addObject:currentString];
                Venue *venue = (Venue*)[venuesResponse.venues objectAtIndex:i];
                [venuesSearchResults addObject:venue];
                NSLog(@"%d/%d : %@",k,i,venue.name);
                k++;
            }
            i++;
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
    Venue *venue;
    if(isSearching)
        venue = ((Venue*)[venuesSearchResults objectAtIndex:indexPath.row]);
    else
        venue = ((Venue*)[venuesResponse.venues objectAtIndex:indexPath.row]);
    
    NSLog(@"%@",venue.name);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/getpoidetails",[APIUtil host]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:[venue getId] forKey:@"poi"];
    [request setDelegate:self];
    [request startAsynchronous];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
