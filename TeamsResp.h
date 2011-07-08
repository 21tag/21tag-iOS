//
//  TeamsResp.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/7/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObj.h"
#import "Team.h"
#import "User.h"
#import "Venue.h"

@interface TeamsResp : APIObj {
	NSString *TEAMS;
	NSString *USERS;
	NSString *VENUES;
	NSString *POINTS;
	NSString *TEAM;
	NSString *VENUE;
	NSString *POINT;
	NSString *MAP;
    
    NSArray *teams;
    NSArray *users;
    NSArray *venues;
    NSSet *points;
}



@end
