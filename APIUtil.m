//
//  APIUtil.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APIUtil.h"


@implementation APIUtil

@synthesize hostName;
@synthesize port;
@synthesize host;

@synthesize msgHostName;
@synthesize msgPort;
@synthesize msgHost;


-(id)init
{
    self = [super init];
    if(self)
    {
        hostName = @"http://21tag.com";
        port = 8689;
        host = [NSString stringWithFormat:@"%@:%d",hostName,port];
        
        msgHostName = @"http://21tag.com";
        msgPort = 8689;
        msgHost = [NSString stringWithFormat:@"%@:%d",msgHostName,msgPort];
    }
    return self;
}

@end
