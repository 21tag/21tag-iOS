//
//  ChooseNetworkViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "LocationController.h"
#import "MBProgressHUD.h"

@interface ChooseNetworkViewController : UIViewController <UIActionSheetDelegate, LocationControllerDelegate, MBProgressHUDDelegate> {
    Facebook *facebook;
    LocationController *locationController;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) IBOutlet UIButton * harvardButton;
@property (nonatomic, strong) IBOutlet UIButton * campusesButton;

- (IBAction)harvardPressed:(id)sender;
- (IBAction)campusRequestPressed:(id)sender;
- (void)facebookPressed;

@end
