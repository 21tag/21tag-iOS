//
//  APIUtil.h
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIObj.h"
#import "User.h"


@interface APIUtil : NSObject {
    
}

+(NSString*) host;
+(NSString*)stringWithTimeDifferenceBetweenThen:(NSString*)then;
+(NSString*)stringwithFormatFrom:(NSTimeInterval)time;
+(NSTimeInterval) timeIntervalFromThen:(NSString *)then;
+(NSString*) StringWithTimeSince:(NSDate *)then;
+(CLLocationDistance)minDistanceMeters;

+(int)minDistanceFeet;


@end
