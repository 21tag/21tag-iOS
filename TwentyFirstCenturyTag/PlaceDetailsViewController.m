//
//  PlaceDetailsViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011. All rights reserved.
//

#import "PlaceDetailsViewController.h"

#define kCellIdentifier @"Cell"

@implementation PlaceDetailsViewController
@synthesize activityIndicator;
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
    [activityIndicator release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)setupButtons
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"map_button.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"map_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(mapPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = mapButton;
    
    [mapButton release];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonImage = [UIImage imageNamed:@"checkin_button.png"];
    buttonImagePressed = [UIImage imageNamed:@"checkin_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(checkinPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *checkinButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = checkinButton;
    
    [checkinButton release];
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
    
    [self setupButtons];
    
    CGSize size = CGSizeMake(320.0f, 800.0f);
    [detailsScrollView setContentSize:size];

    [activityIndicator startAnimating];
}

-(void)checkinPressed
{
    
}

-(void)mapPressed
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self setActivityIndicator:nil];
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
    cell.detailTextLabel.text = [[cellDictionary objectForKey:@"date"] description];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
	return cell;
}

@end
