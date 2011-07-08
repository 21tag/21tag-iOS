//
//  VenuesResp.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObj.h"

@interface VenuesResp : APIObj {
    NSString *GROUPS;
    NSString *VENUES;
    
    NSMutableArray *venues;
}

@property (nonatomic, retain) NSMutableArray *venues;

@end
