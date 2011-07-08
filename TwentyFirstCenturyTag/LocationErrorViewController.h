//
//  LocationErrorViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationController.h"

@interface LocationErrorViewController : UIViewController <LocationControllerDelegate> {
    LocationController *locationController;
}
- (IBAction)checkLocationPressed:(id)sender;

@end
