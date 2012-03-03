//
//  POIDetailResp.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObj.h"
#import "Venue.h"
#import "Team.h"
#import "User.h"

@interface POIDetailResp : APIObj {
    NSString *POI;
	NSString *OWNER;
	NSString *POINTS;
	NSString *USERS;
    NSString *NAME;
    NSString *TEAMID;
    NSString *TEAMPOINTS;
    NSString *HISTORY;
    
	
	Venue *poi;
	NSString *ownerId;
    NSString *ownerName;
	int points;
	NSArray *users;
    NSMutableArray *history;
}

@property (nonatomic, strong) 	Venue *poi;
@property (nonatomic, strong) 	NSString *ownerId;
@property (nonatomic, strong)   NSString *ownerName;
@property int points;
@property (nonatomic, strong) 	NSArray *users;
@property (nonatomic, strong)   NSMutableArray *history;


@end
