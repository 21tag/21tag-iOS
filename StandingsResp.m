//
//  StandingsResp.m
//  TwentyFirstCenturyTag
//
//  Created by Chris Ballinger on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StandingsResp.h"
#import "Team.h"
#import "JSONKit.h"

@implementation StandingsResp

@synthesize teams;

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE			= @"StandingsResp";
        TEAMS			= @"teams";
        TEAM			= @"t";
        POINT			= @"p";
    }
    return self;
}

-(void) parseDictionary:(NSDictionary *)fields
{
    [super parseDictionary:fields];
    
    NSArray *rawTeamsArray = [fields objectForKey:TEAMS];
    
    NSMutableArray *teamsData = [[NSMutableArray alloc] initWithCapacity:[rawTeamsArray count]];
    
    if(rawTeamsArray)
    {
        for(int i = 0; i < [rawTeamsArray count]; i++)
        {
            NSDictionary *rawTeamData = [rawTeamsArray objectAtIndex:i];
            NSDictionary *teamDictionary = [rawTeamData objectForKey:TEAM];
            Team *team = [[Team alloc] initWithDictionary:teamDictionary];
            NSNumber *points = [rawTeamData objectForKey:POINT];
            
            NSLog(@"%@ - %d",team.name, [points intValue]);
            
            NSMutableDictionary *teamValues = [[NSMutableDictionary alloc] initWithCapacity:2];
            [teamValues setObject:team forKey:@"team"];                
            [teamValues setObject:points forKey:@"points"];
            
            [teamsData addObject:teamValues];
        }
    }
    teams = teamsData;
}

@end
