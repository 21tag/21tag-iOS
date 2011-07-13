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
	
	Venue *poi;
	Team *owner;
	long points;
	NSArray *users;
}

@property (nonatomic, retain) 	Venue *poi;
@property (nonatomic, retain) 	Team *owner;
@property long points;
@property (nonatomic, retain) 	NSArray *users;


@end
