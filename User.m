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
@synthesize teamName;
@synthesize teamId;
@synthesize currentVenueId;
@synthesize currentVenueName;
@synthesize currentVenueTime;
@synthesize currentVenueLastTime;
@synthesize points;
@synthesize venuedata;
@synthesize history;
@synthesize poiPoints;

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE					= @"User";
        USER					= @"user";
        FIRSTNAME				= @"first_name";
        LASTNAME				= @"last_name";
        PASSWORD				= @"password";
        PHOTO					= @"photo";
        GENDER					= @"gender";
        PHONE					= @"phone";
        EMAIL					= @"email";
        FID						= @"fid";
        TEAM					= @"team_id";
        TEAMNAME				= @"teamname";
        FBAUTHCODE				= @"fb_authcode";
        CURRENTVENUEID			= @"currentVenueId";
        CURRENTVENUENAME		= @"currentVenueName";
        CURRENTVENUETIME		= @"currentVenueTime";
        CURRENTVENUELASTTIME	= @"currentVenueLastTime";
        POINTS					= @"points";
        POINT					= @"poi_pts";
        VENUE					= @"v";
        VENUEDATA				= @"venue_data";
        HISTORY					= @"events";	
    }
    return self;
}

//iAPI methods
-(void) parseDictionary:(NSDictionary *)fields
{
    [super parseDictionary:fields];
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
    currentVenueTime = [fields objectForKey:CURRENTVENUETIME];
    currentVenueLastTime = [fields objectForKey:CURRENTVENUELASTTIME];
    teamName = [fields objectForKey:TEAMNAME];
    teamId = [fields objectForKey:TEAM];
    
    NSString *rawPoints = [fields objectForKey:POINTS];
    NSLog(@"Raw Points: %@",rawPoints);
    points = rawPoints;
    
    NSArray *rawPoiPoints =  [fields objectForKey:POINT];
    NSMutableDictionary *pointsDictionary = [[NSMutableDictionary alloc] initWithCapacity:[rawPoiPoints count]]; 
    for(int i = 0; i < [rawPoiPoints count]; i++)
    {
        NSString * tempPoiId = [NSString stringWithFormat:@"%@",[[rawPoiPoints objectAtIndex:i] objectForKey:@"poi"]];
        NSString * tempPoiPoints = [NSString stringWithFormat:@"%@", [[rawPoiPoints objectAtIndex:i] objectForKey:@"pts"]];
        NSLog(@"input poi pts: %@",[tempPoiId class]);
        
        if(tempPoiId)
            [pointsDictionary setObject:tempPoiPoints forKey:tempPoiId];
    }
    poiPoints = pointsDictionary;
    
    NSArray * rawHistory = [fields objectForKey:HISTORY];
    NSMutableArray * tempHistory = [[NSMutableArray alloc] initWithCapacity:[rawHistory count]];
    
    for (int i =0; i<[rawHistory count]; i++)
    {
        Event * event = [[Event alloc] initWithDictionary:[rawHistory objectAtIndex:i]];
        [tempHistory addObject:event];
    }
    
    history = tempHistory;
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
