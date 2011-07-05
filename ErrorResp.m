//
//  ErrorResp.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ErrorResp.h"


@implementation ErrorResp

@synthesize APITYPE;
@synthesize code;
@synthesize error;
@synthesize ratelimited;
@synthesize unauthorized;

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE = @"ErrorResp";
        CODE = @"code";
        ERROR = @"error";
        RATELIMITED = @"ratelimited";
        UNAUTHORIZED = @"unauthorized";
    }
    return self;
}



@end
