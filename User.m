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
-(id)initWithData: (NSData*) jsonData
{
    self = [self init];
    
    [self parseJSON:jsonData];
    
    return self;
}
-(void) parseJSON: (NSData*) jsonData
{
    [super parseJSON:jsonData];
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSDictionary *fields = [jsonKitDecoder objectWithData:jsonData];
    firstname = [fields objectForKey:FIRSTNAME];
    lastname = [fields objectForKey:LASTNAME];
    photo = [fields objectForKey:PHOTO];
    gender = [fields objectForKey:GENDER];
    phone = [fields objectForKey:PHONE];
    email = [fields objectForKey:EMAIL];
    fid = [fields objectForKey:FID];
    password = [fields objectForKey:PASSWORD];
    fb_authcode = [fields objectForKey:FBAUTHCODE];
    currentVenueId = [fields objectForKey:CURRENTVENUEID];
    currentVenueName = [fields objectForKey:CURRENTVENUENAME];
    currentVenueTime = [[fields objectForKey:CURRENTVENUETIME] longValue];
    currentVenueLastTime = [[fields objectForKey:CURRENTVENUELASTTIME] longValue];
    team = [fields objectForKey:TEAM];
    teamname = [fields objectForKey:TEAMNAME];
    points = [fields objectForKey:POINTS];
    venuedata = [fields objectForKey:VENUEDATA];
    history = [fields objectForKey:HISTORY];
}
-(NSData*) toJSON;
{
    NSArray *objects = [NSArray arrayWithObjects:myId, _id, firstname, lastname, photo, gender, phone, email, fid, password, fb_authcode, team, teamname, currentVenueId, currentVenueName, [NSNumber numberWithLong: currentVenueTime], [NSNumber numberWithLong: currentVenueLastTime], points, venuedata, history, nil];
    NSArray *keys = [NSArray arrayWithObjects:ID, _ID, FIRSTNAME, LASTNAME, PHOTO, GENDER, PHONE, EMAIL, FID, PASSWORD, FBAUTHCODE, TEAM, TEAMNAME, CURRENTVENUEID, CURRENTVENUENAME, CURRENTVENUETIME, CURRENTVENUELASTTIME, POINTS, VENUEDATA, HISTORY, nil];
    NSDictionary *fields = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return [fields JSONData];
}
-(NSString*) getAPIType
{
    return APITYPE;
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
