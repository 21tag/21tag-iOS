//
//  Event.m
//  TwentyFirstCenturyTag
//
//  Created by Chris Ballinger on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize venueid;
@synthesize userid;
@synthesize teamid;
@synthesize msg;
@synthesize time;

- (id)init
{
    self = [super init];
    if (self) {
        APITYPE			= @"Event";
        VENUEID			= @"vid";
        USERID			= @"uid";
        TEAMID			= @"tid";
        MSG				= @"msg";
        TIME			= @"time";    
    }
    
    return self;
}

//iAPI methods
-(void) parseDictionary:(NSDictionary *)fields
{
    [super parseDictionary:fields];
        
    venueid = [[fields objectForKey:VENUEID] retain];
    userid = [[fields objectForKey:USERID] retain];
    teamid = [[fields objectForKey:TEAMID] retain];
    msg = [[fields objectForKey:MSG] retain];
    time = [[fields objectForKey:TIME] doubleValue] / 1000;
}


@end
