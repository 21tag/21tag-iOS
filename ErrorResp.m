//
//  ErrorResp.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ErrorResp.h"
#import "JSONKit.h"

@implementation ErrorResp

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

// iAPI methods
-(id)initWithData: (NSData*) jsonData
{    
    [super initWithData:jsonData];
    [self init];
    [self parseJSON:jsonData];
    
    return self;
}
-(void) parseJSON: (NSData*) jsonData
{
    [super parseJSON:jsonData];
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSDictionary *fields = [jsonKitDecoder objectWithData:jsonData];
    code = [[fields objectForKey:CODE] intValue];
    error = [fields objectForKey:ERROR];
    ratelimited = [fields objectForKey:RATELIMITED];
    unauthorized = [fields objectForKey:UNAUTHORIZED];
    
}
-(NSData*) toJSON;
{
    NSArray *objects = [NSArray arrayWithObjects:myId, _id, [NSNumber numberWithInt:code], error, ratelimited, unauthorized, nil];
    NSArray *keys = [NSArray arrayWithObjects:ID, _ID, CODE, ERROR, RATELIMITED, UNAUTHORIZED, nil];
    NSDictionary *fields = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return [fields JSONData];
}
-(NSString*) getAPIType
{
    return APITYPE;
}

@end
