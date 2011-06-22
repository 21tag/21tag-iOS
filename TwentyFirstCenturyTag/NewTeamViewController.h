//
//  NewTeamViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewTeamViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
    
    UIImageView *teamImageView;
    UITextField *nameTextField;
    UITextField *mottoTextField;
    UINavigationBar *navigationBar;
    UINavigationItem *navigationItem;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *saveButton;
}
@property (nonatomic, retain) IBOutlet UIImageView *teamImageView;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *mottoTextField;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (nonatomic, retain) UIBarButtonItem *saveButton;

-(void)cancelPressed;
-(void)savePressed;
- (IBAction)pickTeamImagePressed:(id)sender;

@end
