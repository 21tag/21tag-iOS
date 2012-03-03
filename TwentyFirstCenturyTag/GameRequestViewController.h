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
@property (nonatomic, strong) IBOutlet UINavigationItem *navigationItem;

@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;
- (IBAction)leftButtonPressed:(id)sender;
@property (nonatomic, strong) IBOutlet UITextField *schoolTextField;
@property (nonatomic, strong) IBOutlet UITextField *locationTextField;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
- (IBAction)sendRequestPressed:(id)sender;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


@end
