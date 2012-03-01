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
        USERS			= @"members";
        VENUES			= @"venues";
        HISTORY			= @"history";  
        MOTTO           = @"moto";
    }
    return self;
}

//iAPI methods
-(void) parseDictionary:(NSDictionary *)fields
{
    
    [super parseDictionary:fields];
    self.name = [fields objectForKey:NAME];
    self.leader = [fields objectForKey:LEADER];
    
    self.users = [NSSet setWithArray:[fields objectForKey:USERS]];
    self.venues = [NSSet setWithArray:[fields objectForKey:VENUES]];
    
    self.history = [fields objectForKey:HISTORY];
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"Name: %@ Members: %@ Venues: %@",name,users,venues];
}

@end
