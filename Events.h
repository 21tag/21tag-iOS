//
//  Events.h
//  TwentyFirstCenturyTag
//
//  Created by Chris Ballinger on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APIObj.h"
#import "Event.h"

@interface Events : APIObj
{
	NSString *EVENTS;
	
	NSArray *events;
}

@property (nonatomic, strong) NSArray *events;

@end
