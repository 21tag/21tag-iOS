//
//  ErrorResp.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObj.h"

@interface ErrorResp : APIObj {
    NSString *CODE;
    NSString *ERROR;
    NSString *RATELIMITED;
    NSString *UNAUTHORIZED;
}

@property int code;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *ratelimited;
@property (nonatomic, strong) NSString *unauthorized;

@end
