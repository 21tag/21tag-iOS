//
//  ErrorResp.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObj.h"

@interface ErrorResp : APIObj {
    NSString *APITYPE;
    NSString *CODE;
    NSString *ERROR;
    NSString *RATELIMITED;
    NSString *UNAUTHORIZED;
}

@property (nonatomic, retain) NSString *APITYPE;
@property int code;
@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSString *ratelimited;
@property (nonatomic, retain) NSString *unauthorized;

@end
