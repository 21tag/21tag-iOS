//
//  APIObj.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APIObj.h"
#import "JSONKit.h"

@implementation APIObj

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

// iAPI methods
-(void) parseJSON: (NSData*) jsonData
{
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSDictionary *fields = [jsonKitDecoder objectWithData:jsonData];
    NSString *jsonID = [fields objectForKey:ID];
    NSString *json_ID = [fields objectForKey:_ID];
    if(jsonID)
        myId = jsonID;
    if(json_ID)
        _id = json_ID;
        
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
    return nil;
}
-(NSString*) getId
{
    return myId;
}
-(void) setId: (NSString *) i
{
    myId = i;
}


@end
