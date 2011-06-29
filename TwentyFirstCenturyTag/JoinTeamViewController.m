//
//  JoinTeamViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JoinTeamViewController.h"
#import "NewTeamViewController.h"
#import "TeamInfoViewController.h"

#define kCellIdentifier @"Cell"

@implementation JoinTeamViewController

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
    
    contentList = [NSMutableArray arrayWithObjects:@"Kickin' Wing", @"Dark Wing Ducks", @"Create a new team", @"Search all teams", nil];
    [contentList retain];
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
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
	}
	
	// get the view controller's info dictionary based on the indexPath's row
	cell.textLabel.text = [contentList objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    int count = [contentList count];
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
        cell.imageView.image = [UIImage imageNamed:@"team_icon_placeholder.png"];
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
        
    }
    else
    {
        TeamInfoViewController *teamInfoController = [[TeamInfoViewController alloc] init];
        teamInfoController.isJoiningTeam = YES;
        [self.navigationController pushViewController:teamInfoController animated:YES];
        [teamInfoController release];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)viewDidUnload
{
    [self setNavigationTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
