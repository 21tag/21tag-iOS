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
    NSTimeInterval currentVenueTime;
    NSTimeInterval currentVenueLastTime;
    NSDictionary *poiPoints;
    
    NSString *points;
    NSDictionary *venuedata;
    NSMutableArray *history;
}

@property (nonatomic, retain) NSString *firstname;
@property (nonatomic, retain) NSString *lastname;
@property (nonatomic, retain) NSString *photo;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *fid;
@property (nonatomic, retain) NSString *fb_authcode;
@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *teamId;
@property (nonatomic, retain) NSString *currentVenueId;
@property (nonatomic, retain) NSString *currentVenueName;
@property NSTimeInterval currentVenueTime;
@property NSTimeInterval currentVenueLastTime;
@property (nonatomic, retain) NSString *points;
@property (nonatomic, retain) NSDictionary *poiPoints;
@property (nonatomic, retain) NSDictionary *venuedata;
@property (nonatomic, retain) NSMutableArray *history;

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
