//
//  TeamsResp.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TeamsResp.h"


@implementation TeamsResp

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE			= @"TeamsResp";
        TEAMS			= @"teams";
        USERS			= @"users";
        VENUES			= @"venues";
        POINTS			= @"points";
        TEAM			= @"t";
        VENUE			= @"v";
        POINT			= @"p";
        MAP				= @"m";
    }
    return self;
}

@end
