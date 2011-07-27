//
//  PlaceDetailsViewController.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 6/29/11.
//  Copyright 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "MapViewController.h"
#import "POIDetailResp.h"
#import "Events.h"

@interface PlaceDetailsViewController : UIViewController <UITableViewDataSource> {
    
    UIScrollView *detailsScrollView;
    UIImageView *detailsImageView;
    UILabel *placeNameLabel;
    UILabel *yourPointsLabel;
    UILabel *yourCheckinsLabel;
    UILabel *yourTeamPointsLabel;
    UILabel *yourTeamNameLabel;
    UILabel *owningTeamNameLabel;
    UILabel *owningTeamPointsLabel;
    UITableView *detailsTableView;
    NSMutableArray *contentList;
    UIActivityIndicatorView *activityIndicator;
    
    Venue *venue;
    POIDetailResp *poiResponse;
    MapViewController *mapViewController;
    
    Events *eventsResponse;
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIScrollView *detailsScrollView;
@property (nonatomic, retain) IBOutlet UIImageView *detailsImageView;
@property (nonatomic, retain) IBOutlet UILabel *placeNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *yourPointsLabel;
@property (nonatomic, retain) IBOutlet UILabel *yourCheckinsLabel;
@property (nonatomic, retain) IBOutlet UILabel *yourTeamPointsLabel;
@property (nonatomic, retain) IBOutlet UILabel *yourTeamNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *owningTeamNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *owningTeamPointsLabel;
@property (nonatomic, retain) IBOutlet UITableView *detailsTableView;

@property (nonatomic, retain)     NSMutableArray *contentList;
@property (nonatomic, retain) Venue *venue;
@property (nonatomic, retain) MapViewController *mapViewController;
@property (nonatomic, retain) POIDetailResp *poiResponse;

-(void) setupButtons;
-(void) backPressed;
- (IBAction)checkinButtonPressed:(id)sender;

@end
