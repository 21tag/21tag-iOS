//
//  APIObj.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAPI.h"

@interface APIObj : NSObject <iAPI> {
    NSString *APITYPE;
    NSString *myId;
    NSString *_id;
}

@property (nonatomic, retain) NSString *APITYPE;

@end
