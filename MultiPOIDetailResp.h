//
//  MultiPOIDetailResp.h
//  TwentyFirstCenturyTag
//
//  Created by Chris Ballinger on 8/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "APIObj.h"
#import "POIDetailResp.h"

@interface MultiPOIDetailResp  : APIObj {
    NSString* POIS;
    
    NSArray *pois;
}

@property (nonatomic, retain) NSArray *pois;

@end
