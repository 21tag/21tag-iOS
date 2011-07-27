//
//  Events.m
//  TwentyFirstCenturyTag
//
//  Created by Chris Ballinger on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Events.h"

@implementation Events

@synthesize events;

- (id)init
{
    self = [super init];
    if (self) {
        APITYPE			= @"Events";
        EVENTS			= @"events";    
    }
    
    return self;
}

//iAPI methods
-(void) parseDictionary:(NSDictionary *)fields
{
    [super parseDictionary:fields];
    
    NSArray *rawEventsArray = [fields objectForKey:EVENTS];
    NSMutableArray *eventsArray = [[NSMutableArray alloc] initWithCapacity:[rawEventsArray count]];
    
    for(int i = 0; i < [rawEventsArray count]; i++)
    {
        [eventsArray addObject:[[Event alloc] initWithDictionary:[rawEventsArray objectAtIndex:i]]];
    }
    
    events = eventsArray;
}


@end
