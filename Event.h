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

@property (nonatomic, retain) NSString *venueid;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *teamid;
@property (nonatomic, retain) NSString *msg;
@property (nonatomic, retain) NSString *points;
@property (nonatomic, retain) NSString *time;

@end
