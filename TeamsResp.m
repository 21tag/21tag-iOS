//
//  TeamsResp.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/7/11.
//  Copyright 2011. All rights reserved.
//

#import "TeamsResp.h"


@implementation TeamsResp

@synthesize teams;
@synthesize users;
@synthesize venues;
@synthesize points;

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE			= @"TeamsResp";
        TEAMS			= @"objects";
        USERS			= @"members";
        VENUES			= @"venues";
        POINTS			= @"points";
        TEAM			= @"name";
        VENUE			= @"v";
        POINT			= @"p";
        MAP				= @"m";
        MOTTO           = @"motto";
    }
    return self;
}

//iAPI methods
-(void) parseDictionary:(NSDictionary *)fields
{
    [super parseDictionary:fields];
    NSArray *teamFieldsArray = [fields objectForKey:TEAMS];
    if(teamFieldsArray)
    {
        NSMutableArray *teamsArray = [[NSMutableArray alloc] initWithCapacity:[teamFieldsArray count]];
        for(int i = 0; i < [teamFieldsArray count]; i++)
        {
            Team *team = [[Team alloc] initWithDictionary:[teamFieldsArray objectAtIndex:i]];
            NSLog(@"team dictionary: %@",[teamFieldsArray objectAtIndex:i]);
            [teamsArray addObject:team];
        }
        teams = teamsArray;
    }
    
    NSArray *userFieldsArray = [fields objectForKey:USERS];
    if(userFieldsArray)
    {
        NSMutableArray *usersArray = [[NSMutableArray alloc] initWithCapacity:[userFieldsArray count]];
        for(int i = 0; i < [userFieldsArray count]; i++)
        {
            NSLog(@"Users: %@",[userFieldsArray objectAtIndex:i]);
            User *user = [[User alloc] initWithDictionary:[userFieldsArray objectAtIndex:i]];
            [usersArray addObject:user];
        }
        users = usersArray;
    }
    
    NSArray *venueFieldsArray = [fields objectForKey:VENUES];
    if(venueFieldsArray)
    {
        NSMutableArray *venuesArray = [[NSMutableArray alloc] initWithCapacity:[venueFieldsArray count]];
        for(int i = 0; i < [venueFieldsArray count]; i++)
        {
            Venue *venue = [[Venue alloc] initWithDictionary:[venueFieldsArray objectAtIndex:i]];
            [venuesArray addObject:venue];
        }
        venues = venuesArray;
    }
    
    points = [fields objectForKey:POINTS];
}


@end
