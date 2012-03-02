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
@synthesize points;

- (id)init
{
    self = [super init];
    if (self) {
        APITYPE			= @"Event";
        VENUEID			= @"poi_id";
        USERID			= @"user_id";
        TEAMID			= @"team_id";
        MSG				= @"message";
        TIME			= @"time";  
        POINTS          = @"points";
    }
    
    return self;
}

//iAPI methods
-(void) parseDictionary:(NSDictionary *)fields
{
    [super parseDictionary:fields];
        
    self.venueid = [fields objectForKey:VENUEID];
    self.userid = [fields objectForKey:USERID];
    self.teamid = [fields objectForKey:TEAMID];
    self.msg = [fields objectForKey:MSG];
    self.points = [fields objectForKey:POINTS];
    self.time = [fields objectForKey:TIME];
}


@end
