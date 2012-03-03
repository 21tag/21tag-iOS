//
//  Event.h
//  TwentyFirstCenturyTag
//
//  Created by Chris Ballinger on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APIObj.h"

@interface Event : APIObj
{
    NSString *VENUEID;
	NSString *USERID;
	NSString *TEAMID;
	NSString *MSG;
	NSString *TIME;
    NSString *POINTS;
	
	NSString *venueid;
	NSString *userid;
	NSString *teamid;
	NSString *msg;
	NSString *time;
}

@property (nonatomic, strong) NSString *venueid;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *teamid;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *points;
@property (nonatomic, strong) NSString *time;

@end
