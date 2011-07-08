//
//  SearchAllTeamsViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchAllTeamsViewController.h"
#import "APIUtil.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

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
    
    // Restore search term
    if ([self savedSearchTerm])
    {
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
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
}

@end
