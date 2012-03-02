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
@synthesize points;
@synthesize poiPoints;


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
        HISTORY			= @"events";  
        MOTTO           = @"moto";
        POINTS          = @"points";
        POIPOINTS       = @"poi_pts";
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
    
    NSArray * rawHistory = [fields objectForKey:HISTORY];
    NSMutableArray * tempHistory = [[NSMutableArray alloc] initWithCapacity:[rawHistory count]];
    for (int i =0; i<[rawHistory count]; i++)
    {
        Event * event = [[Event alloc] initWithDictionary:[rawHistory objectAtIndex:i]];
        [tempHistory addObject:event];
    }
    history = tempHistory;
    
    NSArray *rawPoiPoints =  [fields objectForKey:POIPOINTS];
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
    
    
    self.points = [fields objectForKey:POINTS];
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"Name: %@ Members: %@ Venues: %@",name,users,venues];
}

@end
