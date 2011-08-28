//
//  SettingsViewController.m
//  TwentyFirstCenturyTag
//
//  Created by Chris Ballinger on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize navBar;
@synthesize navItem;
@synthesize backgroundSwitch;

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
    UIImage *buttonImage = [UIImage imageNamed:@"save_button.png"];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"save_button_pressed.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = buttonImage.size.width;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button addTarget:self action:@selector(savePressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:button];    
    navItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    navBar.tintColor = [UIColor colorWithRed:0.015686274509804f green:0.615686274509804f blue:0.749019607843137 alpha:1.0];
}

- (void)viewDidUnload
{
    [self setBackgroundSwitch:nil];
    [self setNavBar:nil];
    [self setNavItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [backgroundSwitch release];
    [navBar release];
    [navItem release];
    [super dealloc];
}

- (IBAction)toggleSwitch:(id)sender 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(backgroundSwitch.on)
    {
        [defaults setObject:[NSNumber numberWithBool:YES ] forKey:@"use_background_location"];
    }
    else
    {
        [defaults setObject:[NSNumber numberWithBool:NO ] forKey:@"use_background_location"];
    }
    [defaults synchronize];
}

-(void)savePressed
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
