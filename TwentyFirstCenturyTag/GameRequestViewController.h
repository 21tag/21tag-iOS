//
//  GameRequestViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface GameRequestViewController : UIViewController <MBProgressHUDDelegate> {
    
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *doneButton;
    UINavigationBar *navigationBar;
    UITextField *schoolTextField;
    UITextField *locationTextField;
    UITextField *emailTextField;
    UIScrollView *scrollView;
    CGPoint scrollViewOriginalState;
    BOOL isScrolledUp;
    UINavigationItem *navigationItem;
    MBProgressHUD *HUD;
}
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
- (IBAction)leftButtonPressed:(id)sender;
@property (nonatomic, retain) IBOutlet UITextField *schoolTextField;
@property (nonatomic, retain) IBOutlet UITextField *locationTextField;
@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
- (IBAction)sendRequestPressed:(id)sender;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;


@end
