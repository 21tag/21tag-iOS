//
//  TeamsByFBIDS.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObj.h"
#import "TeamData.h"

@interface TeamsByFBIDS : APIObj {
	NSString *TEAMDATA;
	NSString *NAME;
	NSString *TEAMID;
	NSString *NUMMEM;
	NSString *NUMFRI;
    
    NSArray *data;
}

@property (nonatomic, strong) NSArray *data;


@end
