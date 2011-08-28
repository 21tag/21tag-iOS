//
//  SettingsViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Chris Ballinger on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;
@property (retain, nonatomic) IBOutlet UISwitch *backgroundSwitch;
- (IBAction)toggleSwitch:(id)sender;

-(void)savePressed;

@end
