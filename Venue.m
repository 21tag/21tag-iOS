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
@synthesize tag_ownername;

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
        TAGOWNERID      = @"id";
    }
    return self;
}

//iAPI methods
-(void) parseDictionary:(NSDictionary *)fields
{
    [super parseDictionary:fields];
    self.name = [fields objectForKey:NAME];
    self.address = [fields objectForKey:ADDRESS];
    self.crossstreet = [fields objectForKey:CROSSSTREET];
    self.city = [fields objectForKey:CITY];
    self.state = [fields objectForKey:STATE];
    self.zip = [fields objectForKey:ZIP];
    self.geolat = [[fields objectForKey:GEOLAT] doubleValue];
    self.geolong = [[fields objectForKey:GEOLONG] doubleValue];
    self.tag_playable = [[fields objectForKey:TAGPLAYABLE] boolValue];
    self.tag_ownerid = [[fields objectForKey:TAGOWNER] objectForKey:TAGOWNERID];
    self.tag_ownername= [[fields objectForKey:TAGOWNER] objectForKey:NAME];
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
    //NSLog(@"Lat: %f Lon: %f",geolat,geolong);
    return [[CLLocation alloc] initWithLatitude:geolat longitude:geolong];
}

@end
