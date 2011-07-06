//
//  VenuesResp.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VenuesResp.h"
#import "Venue.h"

@implementation VenuesResp

@synthesize APITYPE;
@synthesize venues;

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE = @"VenuesResp";
        GROUPS = @"groups";
        VENUES = @"venues";
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
/*-(void) parseJSON: (NSData*) jsonData
{
    [super parseJSON:jsonData];
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSDictionary *fields = [jsonKitDecoder objectWithData:jsonData];
    NSArray 
}
-(NSData*) toJSON;
{
    NSArray *objects = [NSArray arrayWithObjects:myId, _id, name, address, crossstreet, city, state, zip, [NSNumber numberWithDouble: geolat], [NSNumber numberWithDouble: geolong], [NSNumber numberWithBool: tag_playable], tag_ownerid, nil];
    NSArray *keys = [NSArray arrayWithObjects:ID, _ID, NAME, ADDRESS, CROSSSTREET, CITY, STATE, ZIP, GEOLAT, GEOLONG, TAGPLAYABLE, TAGOWNER, nil];
    NSDictionary *fields = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return [fields JSONData];
}*/
-(NSString*) getAPIType
{
    return APITYPE;
}
//end iAPI methods

@end
