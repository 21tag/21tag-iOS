//
//  TeamInfoViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/22/11.
//  Copyright 2011 . All rights reserved.
//

#import "TeamInfoViewController.h"
#import "DashboardViewController.h"

@interface TeamInfoViewController()
    -(void)setupButtons;
@end

@implementation TeamInfoViewController
@synthesize activityIndicator;
@synthesize teamImage;
@synthesize teamNameLabel;
@synthesize teamSloganLabel;
@synthesize teamMembersButton;
@synthesize locationsOwnedButton;
@synthesize teamPointsButton;
@synthesize tableHeaderLabel;
@synthesize teamMembersLabel;
@synthesize locationsOwnedLabel;
@synthesize teamPointsLabel;
@synthesize isJoiningTeam;

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
    [teamImage release];
    [teamNameLabel release];
    [teamSloganLabel release];
    [teamMembersButton release];
    [locationsOwnedButton release];
    [teamPointsButton release];
    [tableHeaderLabel release];
    [teamMembersLabel release];
    [locationsOwnedLabel release];
    [teamPointsLabel release];
    [activityIndicator release];
    [super dealloc];
}

-(void)setupButtons
{
    if(isJoiningTeam)
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
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonImage = [UIImage imageNamed:@"join_button.png"];
        buttonImagePressed = [UIImage imageNamed:@"join_button_pressed.png"];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
        buttonFrame = [button frame];
        buttonFrame.size.width = buttonImage.size.width;
        buttonFrame.size.height = buttonImage.size.height;
        [button setFrame:buttonFrame];
        [button addTarget:self action:@selector(joinPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *joinButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.rightBarButtonItem = joinButton;
        
        [joinButton release];
    }
    else
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
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.leftBarButtonItem = backButton;
        
        [backButton release];
        
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
}

-(void)joinPressed
{
    DashboardViewController *dashController = [[DashboardViewController alloc] init];
    NSArray *dashboard = [NSArray arrayWithObject:dashController];
    [self.navigationController setViewControllers:dashboard animated:YES];
    [dashController release];
}

-(void)checkinPressed
{
    
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
    if(isJoiningTeam)
        self.title = @"Team Info";
    else
        self.title = @"Your Team";

    [self setupButtons];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_background.png"]];
    
    [activityIndicator startAnimating];
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setTeamImage:nil];
    [self setTeamNameLabel:nil];
    [self setTeamSloganLabel:nil];
    [self setTeamMembersButton:nil];
    [self setLocationsOwnedButton:nil];
    [self setTeamPointsButton:nil];
    [self setTableHeaderLabel:nil];
    [self setTeamMembersLabel:nil];
    [self setLocationsOwnedLabel:nil];
    [self setTeamPointsLabel:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)teamMembersPressed:(id)sender 
{
    [teamMembersButton setImage:[UIImage imageNamed:@"team_members_selected.png"] forState: UIControlStateNormal];
    [locationsOwnedButton setImage:[UIImage imageNamed:@"locations_owned_deselected.png"] forState: UIControlStateNormal];
    [teamPointsButton setImage:[UIImage imageNamed:@"team_points_deselected.png"] forState:UIControlStateNormal];}

- (IBAction)locationsOwnedPressed:(id)sender 
{
    [teamMembersButton setImage:[UIImage imageNamed:@"team_members_deselected.png"] forState: UIControlStateNormal];
    [locationsOwnedButton setImage:[UIImage imageNamed:@"locations_owned_selected.png"] forState: UIControlStateNormal];
    [teamPointsButton setImage:[UIImage imageNamed:@"team_points_deselected.png"] forState:UIControlStateNormal];
}

- (IBAction)teamPointsPressed:(id)sender 
{
    [teamMembersButton setImage:[UIImage imageNamed:@"team_members_deselected.png"] forState: UIControlStateNormal];
    [locationsOwnedButton setImage:[UIImage imageNamed:@"locations_owned_deselected.png"] forState: UIControlStateNormal];
    [teamPointsButton setImage:[UIImage imageNamed:@"team_points_selected.png"] forState:UIControlStateNormal];}
@end
