//
//  Team.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/7/11.
//  Copyright 2011. All rights reserved.
//

#import "Team.h"


@implementation Team

@synthesize name;
@synthesize leader;
@synthesize users;
@synthesize venues;
@synthesize history;

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE			= @"Team";
        NAME			= @"name";
        LEADER			= @"leader";
        USERS			= @"users";
        VENUES			= @"venues";
        HISTORY			= @"history";    
    }
    return self;
}

//iAPI methods
-(void) parseDictionary:(NSDictionary *)fields
{
    [super parseDictionary:fields];
    name = [[fields objectForKey:NAME] retain];
    leader = [[fields objectForKey:LEADER] retain];
    
    users = [NSSet setWithArray:[fields objectForKey:USERS]];
    venues = [NSSet setWithArray:[fields objectForKey:VENUES]];
    
    history = [[fields objectForKey:HISTORY] retain];
}

@end
