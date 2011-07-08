//
//  ChooseNetworkViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "LocationController.h"

@interface ChooseNetworkViewController : UIViewController <UIActionSheetDelegate, LocationControllerDelegate> {
    Facebook *facebook;
    LocationController *locationController;
}

@property (nonatomic, retain) Facebook *facebook;

- (IBAction)harvardPressed:(id)sender;
- (IBAction)campusRequestPressed:(id)sender;
- (void)facebookPressed;

@end
