//
//  AllPlacesViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AllPlacesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *placesTableView;
    NSMutableArray *contentList;
}
@property (nonatomic, retain) IBOutlet UITableView *placesTableView;

-(void)backPressed;
-(void)setupButtons;

-(void)searchPressed;

@end
