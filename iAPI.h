//
//  iAPI.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ID @"id"
#define TYPE @"at"
#define _ID @"_id"

@protocol iAPI <NSObject>
@required
-(id) initWithData: (NSData*) jsonData;
-(id) initWithDictionary: (NSDictionary*) dictionary;
-(void)parseDictionary:(NSDictionary*)fields;
-(void) parseJSON: (NSData*) jsonData;
-(NSData*) toJSON;
-(NSString*) getAPIType;
-(NSString*) getId;
-(void) setId: (NSString *) i;
@end
