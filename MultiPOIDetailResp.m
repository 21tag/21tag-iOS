//
//  MultiPOIDetailResp.m
//  TwentyFirstCenturyTag
//
//  Created by Chris Ballinger on 8/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiPOIDetailResp.h"
#import "JSONKit.h"

@implementation MultiPOIDetailResp

@synthesize pois;

-(id)init
{
    self = [super init];
    if(self)
    {
        APITYPE = @"MultiPOIDetailResp";
        POIS = @"objects";
        
    }
    return self;
}

-(void) parseJSON: (NSData*) jsonData
{
    [super parseJSON:jsonData];
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSDictionary *response = [jsonKitDecoder objectWithData:jsonData];
    NSArray *rawVenues = [response objectForKey:POIS];
    NSMutableArray *poisList = [[NSMutableArray alloc] initWithCapacity:[rawVenues count]];
    
    for(int i = 0; i < [rawVenues count]; i++)
    {
        [poisList addObject:[[POIDetailResp alloc] initWithDictionary:[rawVenues objectAtIndex:i]]];
        NSLog(@"each pois: %@",pois.description);
    }
    
    self.pois = poisList;
    //NSLog(@"all pois: %d",[pois count]);
}

@end
