//
//  ChooseNetworkViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface ChooseNetworkViewController : UIViewController <UIActionSheetDelegate> {
    Facebook *facebook;
}

@property (nonatomic, retain) Facebook *facebook;

- (IBAction)harvardPressed:(id)sender;
- (IBAction)campusRequestPressed:(id)sender;
- (void)facebookPressed;

@end
