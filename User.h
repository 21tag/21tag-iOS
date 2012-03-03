//
//  User.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObj.h"
#import "Venue.h"
#import "Event.h"

@interface User : APIObj {
//private
    NSString *USER;
    NSString *FIRSTNAME;
    NSString *LASTNAME;
    NSString *PASSWORD;
    NSString *PHOTO;
    NSString *GENDER;
    NSString *PHONE;
    NSString *EMAIL;
    NSString *FID;
    NSString *TEAM;
    NSString *TEAMNAME;
    NSString *FBAUTHCODE;
    NSString *CURRENTVENUEID;
    NSString *CURRENTVENUENAME;
    NSString *CURRENTVENUETIME;
    NSString *CURRENTVENUELASTTIME;
    NSString *POINTS;
    NSString *POINT;
    NSString *VENUE;
    NSString *VENUEDATA;
    NSString *HISTORY;
//public
    NSString *firstname;
    NSString *lastname;
    NSString *photo;
    NSString *gender;
    NSString *phone;
    NSString *email;
    NSString *fid;
    NSString *password;
    NSString *fb_authcode;
    NSString *team;
    NSString *teamname;
    NSString *currentVenueId;
    NSString *currentVenueName;
    NSString *currentVenueTime;
    NSString *currentVenueLastTime;
    NSDictionary *poiPoints;
    
    NSString *points;
    NSDictionary *venuedata;
    NSMutableArray *history;
}

@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *fb_authcode;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *currentVenueId;
@property (nonatomic, strong) NSString *currentVenueName;
@property (nonatomic, strong) NSString *currentVenueTime;
@property (nonatomic, strong) NSString *currentVenueLastTime;
@property (nonatomic, strong) NSString *points;
@property (nonatomic, strong) NSDictionary *poiPoints;
@property (nonatomic, strong) NSDictionary *venuedata;
@property (nonatomic, strong) NSMutableArray *history;

/*-(void)addHistory:(NSString*) hist;

-(void)addVenueData:(Venue*) v;
-(void)clearVenue;
-(BOOL)setVenue:(Venue*) v;

-(long)deltaTime;
-(NSArray*)getVenueIds;
-(BOOL)addPointsToAll:(long) delta;
-(void)addPointsToVenue:(Venue*)v delta:(long)delta;
-(void)addPoints:(NSString*) the_id delta:(long)delta;
-(void)setPoints:(NSString*) the_id point:(long)point;
-(long)getPointsFromVenue:(Venue*) v;
-(long)getPointsFromID:(NSString*) the_id;*/

@end
