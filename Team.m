//
//  Team.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/7/11.
//  Copyright 2011 . All rights reserved.
//

#import "Team.h"


@implementation Team

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

@end
