//
//  iAPI.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ID @"id"
#define TYPE @"at"
#define _ID @"_id"

@protocol iAPI <NSObject>
@required
-(void) parseJSON: (NSData*) jsonData;
-(NSData*) toJSON;
-(NSString*) getAPIType;
-(NSString*) getId;
-(void) setId: (NSString *) i;
@end
