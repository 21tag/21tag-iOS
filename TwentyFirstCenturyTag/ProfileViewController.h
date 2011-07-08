//
//  ProfileViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/23/11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileViewController : UIViewController {
    
    UIImageView *profileImageView;
    UILabel *nameLabel;
}
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

-(void)dashPressed;
@end
