//
//  TeamInfoViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TeamInfoViewController : UIViewController {
    
    UIImageView *teamImage;
    UILabel *teamNameLabel;
    UILabel *teamSloganLabel;
    UIButton *teamMembersButton;
    UIButton *locationsOwnedButton;
    UIButton *teamPointsButton;
    UILabel *tableHeaderLabel;
    UILabel *teamMembersLabel;
    UILabel *locationsOwnedLabel;
    UILabel *teamPointsLabel;
}
@property (nonatomic, retain) IBOutlet UIImageView *teamImage;
@property (nonatomic, retain) IBOutlet UILabel *teamNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *teamSloganLabel;
@property (nonatomic, retain) IBOutlet UIButton *teamMembersButton;
@property (nonatomic, retain) IBOutlet UIButton *locationsOwnedButton;
@property (nonatomic, retain) IBOutlet UIButton *teamPointsButton;
@property (nonatomic, retain) IBOutlet UILabel *tableHeaderLabel;
@property (nonatomic, retain) IBOutlet UILabel *teamMembersLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationsOwnedLabel;
@property (nonatomic, retain) IBOutlet UILabel *teamPointsLabel;

@property BOOL isJoiningTeam;

- (IBAction)teamMembersPressed:(id)sender;
- (IBAction)locationsOwnedPressed:(id)sender;
- (IBAction)teamPointsPressed:(id)sender;

- (void)backPressed;
- (void)joinPressed;
- (void)checkinPressed;

@end
