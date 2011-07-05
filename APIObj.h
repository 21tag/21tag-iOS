//
//  APIObj.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iAPI.h"

@interface APIObj : NSObject <iAPI> {
    NSString *myId;
    NSString *_id;
}

@end
