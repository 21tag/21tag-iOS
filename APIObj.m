//
//  APIObj.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011. All rights reserved.
//

#import "APIObj.h"
#import "JSONKit.h"

@implementation APIObj

@synthesize APITYPE;

-(id)init
{
    self = [super init];
    if(self)
    {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        myId = (NSString *)string;
    }
    return self;
}

-(id)initWithData:(NSData*) jsonData
{
    self = [self init];
    
    [self parseJSON:jsonData];
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    
    [self parseDictionary:dictionary];

    return self;
}

-(void)parseDictionary:(NSDictionary *)fields
{
    NSLog(@"myId: %@",[NSString stringWithFormat:@"%@",[[fields objectForKey:ID] class]]);
    myId = [[fields objectForKey:ID] retain];
    _id = [[fields objectForKey:_ID] retain];
}

// iAPI methods
-(void) parseJSON: (NSData*) jsonData
{
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSDictionary *fields = [jsonKitDecoder objectWithData:jsonData];

    [self parseDictionary:fields];
}
-(NSData*) toJSON;
{
    NSArray *objects = [NSArray arrayWithObjects:myId, _id, nil];
    NSArray *keys = [NSArray arrayWithObjects:ID, _ID, nil];
    NSDictionary *fields = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return [fields JSONData];
}
-(NSString*) getAPIType
{
    return APITYPE;
}
-(NSString*) getId
{
    return myId;
}
-(void) setId: (NSString *) i
{
    myId = i;
}
//end API methods

@end
