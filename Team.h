//
//  Team.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/7/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObj.h"
#import "Event.h"

@interface Team : APIObj {
  	NSString *NAME;
	NSString *LEADER;
	NSString *USERS;
	NSString *VENUES;
	NSString *HISTORY;
    NSString *MOTTO;
    NSString *POINTS;
    NSString *POIPOINTS;
    
    NSString *name;
    NSString *leader;
    NSSet *users;
    NSSet *venues;
    NSMutableArray *history;
    NSString *points;
    NSDictionary *poiPoints;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *leader;
@property (nonatomic, retain) NSSet *users;
@property (nonatomic, retain) NSSet *venues;
@property (nonatomic, retain) NSMutableArray *history;
@property (nonatomic, retain) NSString *points;
@property (nonatomic, retain) NSDictionary *poiPoints;

@end
