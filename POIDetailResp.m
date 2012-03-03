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
@synthesize ownerId;
@synthesize ownerName;
@synthesize users;
@synthesize history;

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE			= @"POIDetailResp";
        POI				= @"poi";
        OWNER			= @"tag_owner";
        POINTS			= @"points";
        USERS			= @"users";
        NAME            = @"name";
        TEAMID          = @"id";
        TEAMPOINTS      = @"points";
        HISTORY         = @"events";
    }
    return self;
}

-(void) parseDictionary:(NSDictionary *)fields
{
    [super parseDictionary:fields];
    
    self.poi = [[Venue alloc] initWithDictionary:fields];
    self.ownerId = [[fields objectForKey:OWNER] objectForKey:TEAMID];
    self.ownerName = [[fields objectForKey:OWNER] objectForKey:NAME];
    self.points = [[[fields objectForKey:OWNER] objectForKey:TEAMPOINTS] intValue];
    
    NSArray * rawHistory = [fields objectForKey:HISTORY];
    NSMutableArray * tempHistory = [[NSMutableArray alloc] initWithCapacity:[rawHistory count]];
    for (int i =0; i<[rawHistory count]; i++)
    {
        Event * event = [[Event alloc] initWithDictionary:[rawHistory objectAtIndex:i]];
        NSLog(@"Event msg: %@",event.msg);
        [tempHistory addObject:event];
    }
    history = tempHistory;
    
    NSLog(@"Venue: %@",poi);
}

-(NSString *)description
{
    return self.poi.description;
}

@end
