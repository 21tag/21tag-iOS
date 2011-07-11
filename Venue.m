//
//  Venue.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011. All rights reserved.
//

#import "Venue.h"
#import "JSONKit.h"

@implementation Venue

@synthesize name;
@synthesize address;
@synthesize crossstreet;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize geolat;
@synthesize geolong;
@synthesize tag_playable;
@synthesize tag_ownerid;

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE			= @"Venue";
        NAME			= @"name";
        ADDRESS			= @"address";
        CROSSSTREET		= @"crossstreet";
        CITY			= @"city";
        STATE			= @"state";
        ZIP				= @"zip";
        GEOLAT			= @"geolat";
        GEOLONG			= @"geolong";
        TAGPLAYABLE		= @"tag_playable";
        TAGOWNER		= @"tag_owner";
    }
    return self;
}

//iAPI methods
-(void) parseDictionary:(NSDictionary *)fields
{
    [super parseDictionary:fields];
    name = [[fields objectForKey:NAME] retain];
    address = [[fields objectForKey:ADDRESS] retain];
    crossstreet = [[fields objectForKey:CROSSSTREET] retain];
    city = [[fields objectForKey:CITY] retain];
    state = [[fields objectForKey:STATE] retain];
    zip = [[fields objectForKey:ZIP] retain];
    geolat = [[fields objectForKey:GEOLAT] doubleValue];
    geolong = [[fields objectForKey:GEOLONG] doubleValue];
    tag_playable = [[fields objectForKey:TAGPLAYABLE] boolValue];
    tag_ownerid = [[fields objectForKey:TAGOWNER] retain];
}


-(NSData*) toJSON;
{
    NSArray *objects = [NSArray arrayWithObjects:myId, _id, name, address, crossstreet, city, state, zip, [NSNumber numberWithDouble: geolat], [NSNumber numberWithDouble: geolong], [NSNumber numberWithBool: tag_playable], tag_ownerid, nil];
    NSArray *keys = [NSArray arrayWithObjects:ID, _ID, NAME, ADDRESS, CROSSSTREET, CITY, STATE, ZIP, GEOLAT, GEOLONG, TAGPLAYABLE, TAGOWNER, nil];
    NSDictionary *fields = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return [fields JSONData];
}

//end iAPI methods

-(CLLocation*)getLocation
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:geolat longitude:geolong];
    return location;
}

@end
