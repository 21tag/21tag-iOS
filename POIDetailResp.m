//
//  POIDetailResp.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "POIDetailResp.h"


@implementation POIDetailResp

@synthesize poi;
@synthesize points;
@synthesize owner;
@synthesize users;

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE			= @"POIDetailResp";
        POI				= @"poi";
        OWNER			= @"owner";
        POINTS			= @"points";
        USERS			= @"users";
    }
    return self;
}

-(void) parseDictionary:(NSDictionary *)fields
{
    [super parseDictionary:fields];
    
    poi = [[Venue alloc] initWithDictionary:[fields objectForKey:POI]];
    owner = [[Team alloc] initWithDictionary:[fields objectForKey:OWNER]];
    points = [[fields objectForKey:POINTS] longValue];
    
    NSArray *rawUsersArray = [fields objectForKey:USERS];
    NSMutableArray *usersArray = [[NSMutableArray alloc] initWithCapacity:[rawUsersArray count]];
    for(int i = 0; i < [rawUsersArray count]; i++)
    {
        [usersArray addObject:[[User alloc] initWithDictionary:[rawUsersArray objectAtIndex:i]]];
    }
    users = usersArray;
}

@end
