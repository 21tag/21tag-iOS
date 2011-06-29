//
//  PlaceDetailsViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceDetailsViewController.h"

#define kCellIdentifier @"Cell"

@implementation PlaceDetailsViewController
@synthesize detailsScrollView;
@synthesize detailsImageView;
@synthesize placeNameLabel;
@synthesize yourPointsLabel;
@synthesize yourCheckinsLabel;
@synthesize yourTeamPointsLabel;
@synthesize yourTeamNameLabel;
@synthesize owningTeamNameLabel;
@synthesize owningTeamPointsLabel;
@synthesize detailsTableView;
@synthesize contentList;

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
    [detailsScrollView release];
    [detailsImageView release];
    [placeNameLabel release];
    [yourPointsLabel release];
    [yourCheckinsLabel release];
    [yourTeamPointsLabel release];
    [yourTeamNameLabel release];
    [owningTeamNameLabel release];
    [owningTeamPointsLabel release];
    [detailsTableView release];
    [contentList release];
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
    self.title = @"Place Details";
    
    NSMutableDictionary *recentActivityDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
    [recentActivityDictionary setObject:@"Kickin' Wing sapped a member of The Haverfords" forKey:@"description"];
    [recentActivityDictionary setObject:[NSDate date] forKey:@"date"];
    
    contentList = [[NSMutableArray alloc] initWithObjects:recentActivityDictionary, recentActivityDictionary, recentActivityDictionary, recentActivityDictionary, recentActivityDictionary, nil];
    
    detailsTableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];

}

- (void)viewDidUnload
{
    [self setDetailsScrollView:nil];
    [self setDetailsImageView:nil];
    [self setPlaceNameLabel:nil];
    [self setYourPointsLabel:nil];
    [self setYourCheckinsLabel:nil];
    [self setYourTeamPointsLabel:nil];
    [self setYourTeamNameLabel:nil];
    [self setOwningTeamNameLabel:nil];
    [self setOwningTeamPointsLabel:nil];
    [self setDetailsTableView:nil];
    [self setContentList:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return 55.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
	}
	
	// get the view controller's info dictionary based on the indexPath's row
    NSDictionary *cellDictionary = [contentList objectAtIndex:indexPath.row];
	cell.textLabel.text = [cellDictionary objectForKey:@"description"];
    cell.detailTextLabel.text = [cellDictionary objectForKey:@"date"];
    cell.detailTextLabel.textColor = [UIColor lightTextColor];
    
	return cell;
}

@end
