//
//  User.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011. All rights reserved.
//

#import "User.h"
#import "JSONKit.h"

@implementation User



@synthesize firstname;
@synthesize lastname;
@synthesize photo;
@synthesize gender;
@synthesize phone;
@synthesize email;
@synthesize fid;
@synthesize fb_authcode;
@synthesize team;
@synthesize teamname;
@synthesize currentVenueId;
@synthesize currentVenueName;
@synthesize currentVenueTime;
@synthesize currentVenueLastTime;
@synthesize points;
@synthesize venuedata;
@synthesize history;

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE					= @"User";
        USER					= @"user";
        FIRSTNAME				= @"firstname";
        LASTNAME				= @"lastname";
        PASSWORD				= @"password";
        PHOTO					= @"photo";
        GENDER					= @"gender";
        PHONE					= @"phone";
        EMAIL					= @"email";
        FID						= @"fid";
        TEAM					= @"team";
        TEAMNAME				= @"teamname";
        FBAUTHCODE				= @"fb_authcode";
        CURRENTVENUEID			= @"currentVenueId";
        CURRENTVENUENAME		= @"currentVenueName";
        CURRENTVENUETIME		= @"currentVenueTime";
        CURRENTVENUELASTTIME	= @"currentVenueLastTime";
        POINTS					= @"points";
        POINT					= @"p";
        VENUE					= @"v";
        VENUEDATA				= @"venue_data";
        HISTORY					= @"history";	
    }
    return self;
}

//iAPI methods
-(void) parseDictionary:(NSDictionary *)fields
{
    firstname = [[fields objectForKey:FIRSTNAME] retain];
    lastname = [[fields objectForKey:LASTNAME] retain];
    photo = [[fields objectForKey:PHOTO] retain];
    gender = [[fields objectForKey:GENDER] retain];
    phone = [[fields objectForKey:PHONE] retain];
    email = [[fields objectForKey:EMAIL] retain];
    fid = [[fields objectForKey:FID] retain];
    password = [[fields objectForKey:PASSWORD] retain];
    fb_authcode = [[fields objectForKey:FBAUTHCODE] retain];
    currentVenueId = [[fields objectForKey:CURRENTVENUEID] retain];
    currentVenueName = [[fields objectForKey:CURRENTVENUENAME] retain];
    currentVenueTime = [[fields objectForKey:CURRENTVENUETIME] longValue];
    currentVenueLastTime = [[fields objectForKey:CURRENTVENUELASTTIME] longValue];
    team = [[fields objectForKey:TEAM] retain];
    teamname = [[fields objectForKey:TEAMNAME] retain];
    points = [[fields objectForKey:POINTS] retain];
    venuedata = [[fields objectForKey:VENUEDATA] retain];
    history = [[fields objectForKey:HISTORY] retain];

}

-(NSData*) toJSON;
{
    NSArray *objects = [NSArray arrayWithObjects:myId, _id, firstname, lastname, photo, gender, phone, email, fid, password, fb_authcode, team, teamname, currentVenueId, currentVenueName, [NSNumber numberWithLong: currentVenueTime], [NSNumber numberWithLong: currentVenueLastTime], points, venuedata, history, nil];
    NSArray *keys = [NSArray arrayWithObjects:ID, _ID, FIRSTNAME, LASTNAME, PHOTO, GENDER, PHONE, EMAIL, FID, PASSWORD, FBAUTHCODE, TEAM, TEAMNAME, CURRENTVENUEID, CURRENTVENUENAME, CURRENTVENUETIME, CURRENTVENUELASTTIME, POINTS, VENUEDATA, HISTORY, nil];
    NSDictionary *fields = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return [fields JSONData];
}

//end iAPI methods

-(void)addHistory:(NSString *)hist
{
    if(!hist)
        return;
    if(!history)
    {
        history = [[NSArray alloc] init];
    }
    NSString *historyString = [NSString stringWithFormat:@"%d|%@",[[NSDate date] timeIntervalSince1970],hist];
    [history addObject:historyString];
}

@end
