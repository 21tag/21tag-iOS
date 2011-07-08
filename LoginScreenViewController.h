//
//  LoginScreenViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/19/11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface LoginScreenViewController : UIViewController {
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    BOOL pageControlIsChangingPage;
    
    Facebook *facebook;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
- (IBAction)loginPressed:(id)sender;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
- (IBAction)pageChanged:(id)sender;
@property (nonatomic, retain) Facebook *facebook;

@end
