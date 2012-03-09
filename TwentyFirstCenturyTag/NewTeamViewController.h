//
//  NewTeamViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/21/11.
//  Copyright 2011. All rights reserved.
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
@property (nonatomic, strong) IBOutlet UIImageView *teamImageView;
@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextField *mottoTextField;
@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, strong) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;

-(void)cancelPressed;
-(void)savePressed;
- (IBAction)pickTeamImagePressed:(id)sender;
+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize Image: (UIImage *) image;

@end
