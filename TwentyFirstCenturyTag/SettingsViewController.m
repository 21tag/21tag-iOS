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
@synthesize tableView;

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
    
    navBar.tintColor = [UIColor colorWithRed:0.015686274509804f green:0.615686274509804f blue:0.749019607843137 alpha:1.0];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *background = [defaults objectForKey:@"use_background_location"];
    
    if(background)
    {
        if([background boolValue])
        {
            [backgroundSwitch setOn:YES];
        }
        else
        {
            [backgroundSwitch setOn:NO];
        }
    }
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


- (IBAction)toggleSwitch:(id)sender 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([(UISwitch *)sender isOn])
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Background Task";
}
*/
- (UITableViewCell *)tableView:(UITableView *)tabview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tabview dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    UISwitch *switchObj = [[UISwitch alloc] initWithFrame:CGRectMake(1.0, 1.0, 20.0, 20.0)];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *background = [defaults objectForKey:@"use_background_location"];
    NSLog(@"Background: %@",background);
    if(background)
    {
        if([background boolValue])
        {
            [switchObj setOn:YES];
        }
        else
        {
            [switchObj setOn:NO];
        }
    }
    
    [switchObj addTarget:self action:@selector(toggleSwitch:) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
    cell.accessoryView = switchObj;
    cell.textLabel.text = @"Background Check-in";
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"Automatically updates your location while using other applications (may affect battery life)";
}


@end




