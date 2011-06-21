//
//  GameRequestViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GameRequestViewController : UIViewController {
    
    UIBarButtonItem *leftButton;
    UINavigationBar *navigationBar;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *leftButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
- (IBAction)leftButtonPressed:(id)sender;


@end
