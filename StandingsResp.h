//
//  StandingsResp.h
//  TwentyFirstCenturyTag
//
//  Created by Chris Ballinger on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "APIObj.h"

@interface StandingsResp : APIObj
{
    NSString* TEAMS;
	NSString* TEAM;
	NSString* POINT;
}

@property (nonatomic, strong) NSArray *teams;

@end
