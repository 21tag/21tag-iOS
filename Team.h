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
#import "User.h"
#import "Venue.h"

@interface Team : APIObj {
  	NSString *NAME;
	NSString *LEADER;
	NSString *USERS;
	NSString *VENUES;
	NSString *HISTORY;
    NSString *MOTTO;
    NSString *POINTS;
    NSString *POIPOINTS;
    NSString *AVATAR;
    
    NSString *name;
    NSString *leader;
    NSSet *users;
    NSSet *venues;
    NSMutableArray *history;
    NSString *points;
    NSDictionary *poiPoints;
    NSString * motto;
    NSString * avatar;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *leader;
@property (nonatomic, strong) NSSet *users;
@property (nonatomic, strong) NSSet *venues;
@property (nonatomic, strong) NSMutableArray *history;
@property (nonatomic, strong) NSString *points;
@property (nonatomic, strong) NSDictionary *poiPoints;
@property (nonatomic, strong) NSString * motto;
@property (nonatomic, strong) NSString * avatar;

-(UIImage *)getTeamImage;
+ (UIImage *)getTeamImageWithId: (NSString *)teamId;

@end
