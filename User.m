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
    [super parseDictionary:fields];
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
    currentVenueTime = [[fields objectForKey:CURRENTVENUETIME] doubleValue] / 1000;
    currentVenueLastTime = [[fields objectForKey:CURRENTVENUELASTTIME] doubleValue] / 1000;
    team = [[fields objectForKey:TEAM] retain];
    teamname = [[fields objectForKey:TEAMNAME] retain];
    
    NSArray *rawPointsArray = [fields objectForKey:POINTS];
    NSLog(@"rawpointsarray: %@",rawPointsArray);
    NSMutableDictionary *pointsDictionary = [[NSMutableDictionary alloc] initWithCapacity:[rawPointsArray count]];
    for(int i = 0; i < [rawPointsArray count]; i++)
    {
        NSDictionary *pointInfo = [rawPointsArray objectAtIndex:i];
        NSString *venueID = [pointInfo objectForKey:VENUE];
        NSNumber *pointValue = [pointInfo objectForKey:POINT];
        //NSLog(@"%@ - %d",venueID,[pointValue intValue]);
        
        [pointsDictionary setObject:pointValue forKey:venueID];
    }
    points = pointsDictionary;
    
    NSArray *rawVenueArray =  [fields objectForKey:VENUEDATA];
    NSMutableDictionary *venueDictionary = [[NSMutableDictionary alloc] initWithCapacity:[rawVenueArray count]]; 
    for(int i = 0; i < [rawVenueArray count]; i++)
    {
        Venue *venue = [[Venue alloc] initWithDictionary:[rawVenueArray objectAtIndex:i]];
        [venueDictionary setObject:venue forKey:[venue getId]];
    }
    venuedata = venueDictionary;
    
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
        history = [[NSMutableArray alloc] init];
    }
    NSString *historyString = [NSString stringWithFormat:@"%d|%@",[[NSDate date] timeIntervalSince1970],hist];
    [history addObject:historyString];
}

@end
