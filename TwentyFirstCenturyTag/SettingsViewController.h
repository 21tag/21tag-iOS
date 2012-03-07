//
//  SettingsViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Chris Ballinger on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UISwitch *backgroundSwitch;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)toggleSwitch:(id)sender;

-(void)savePressed;

@end
