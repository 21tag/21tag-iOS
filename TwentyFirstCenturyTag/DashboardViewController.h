//
//  DashboardViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface DashboardViewController : UIViewController <FBRequestDelegate> {
    
    UILabel *nameLabel;
    Facebook *facebook;
}
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) Facebook *facebook;

@end
