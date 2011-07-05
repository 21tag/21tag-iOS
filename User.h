//
//  User.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObj.h"

/*
				
 
 public String firstname;
 public String lastname;
 public String photo;
 public String gender;
 public String phone;
 public String email;
 public String fid;
 public String password;
 public String fb_authcode;
 public String team;
 public String teamname;
 public String currentVenueId;
 public String currentVenueName;	
 public long currentVenueTime;
 public long currentVenueLastTime;
 public HashMap<String, Long> points;
 public HashMap<String, Venue> venuedata;
 public ArrayList<String> history;
 */

@interface User : APIObj {
//private
    NSString *APITYPE;
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
    long currentVenueTime;
    long currentVenueLastTime;
    
    NSMutableDictionary *points;
    NSMutableDictionary *venuedata;
    NSMutableArray *history;
}

@property (nonatomic, retain) NSString *APITYPE;
@property (nonatomic, retain) NSString *firstname;
@property (nonatomic, retain) NSString *lastname;
@property (nonatomic, retain) NSString *photo;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *fid;
@property (nonatomic, retain) NSString *fb_authcode;
@property (nonatomic, retain) NSString *team;
@property (nonatomic, retain) NSString *teamname;
@property (nonatomic, retain) NSString *currentVenueId;
@property (nonatomic, retain) NSString *currentVenueName;
@property long currentVenueTime;
@property long currentVenueLastTime;
@property (nonatomic, retain) NSDictionary *points;
@property (nonatomic, retain) NSDictionary *venuedata;
@property (nonatomic, retain) NSArray *history;

-(void)addHistory:(NSString*) hist;

@end
