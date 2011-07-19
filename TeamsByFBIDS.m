//
//  TeamsByFBIDS.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TeamsByFBIDS.h"


@implementation TeamsByFBIDS

@synthesize data;

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE			= @"TeamsByFBIDS";
        TEAMDATA		= @"TeamData";
        NAME			= @"name";
        TEAMID			= @"id";
        NUMMEM			= @"nummem";
        NUMFRI			= @"numf";
    }
    return self;
}

-(void) parseDictionary:(NSDictionary *)fields
{
    [super parseDictionary:fields];
    
    NSArray *rawTeamDataArray = [fields objectForKey:TEAMDATA];
    
    if(rawTeamDataArray)
    {
        NSMutableArray *teamDataArray = [[NSMutableArray alloc] initWithCapacity:[rawTeamDataArray count]];
        for(int i = 0; i < [rawTeamDataArray count]; i++)
        {
            NSDictionary *rawTeamData = [rawTeamDataArray objectAtIndex:i];
            TeamData *teamData = [[TeamData alloc] init];
            teamData.team_id = [[rawTeamData objectForKey:TEAMID] retain];
            teamData.name = [[rawTeamData objectForKey:NAME] retain];
            teamData.numFriends = [[rawTeamData objectForKey:NUMFRI] intValue];
            teamData.numMembers = [[rawTeamData objectForKey:NUMMEM] intValue];
            [teamDataArray addObject:teamData];
        }
        data = teamDataArray;
    }
}

@end
