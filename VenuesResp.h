//
//  VenuesResp.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObj.h"

@interface VenuesResp : APIObj {
    NSString *APITYPE;
    NSString *GROUPS;
    NSString *VENUES;
    
    NSArray *venues;
}

@property (nonatomic, retain) NSString *APITYPE;
@property (nonatomic, retain) NSArray *venues;

@end
