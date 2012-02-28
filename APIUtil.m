//
//  APIUtil.m
//  TwentyFirstCenturyTag
//
//  Created by Christopher Ballinger on 7/5/11.
//  Copyright 2011. All rights reserved.
//

#import "APIUtil.h"

@implementation APIUtil

+(NSString*)host
{
    return @"http://192.168.1.33:8888/api/v2";
    //return @"http://21tag.com:8689";
}

+(NSString*)stringWithTimeDifferenceBetweenNow:(NSTimeInterval)now then:(NSTimeInterval)then
{
    NSTimeInterval currentVenueTime = then;
    NSTimeInterval currentTime = now;
    
    NSTimeInterval time = currentTime - currentVenueTime;
    
    int hour, minute, second, day;
    hour = time / 3600;
    minute = (time - hour * 3600) / 60;
    second = (time - hour * 3600 - minute * 60);
    NSString *timeString;
    if(hour >= 24)
    {
        day = hour / 24;
        hour = hour - (day * 24);
        timeString = [NSString stringWithFormat:@"%d days %d hours", day, hour];
    }
    else if(hour == 0)
    {
        timeString = [NSString stringWithFormat:@"%d minutes", minute];
    }
    else
        timeString = [NSString stringWithFormat:@"%d hours %d minutes", hour, minute];
    
    return timeString;
}

+(CLLocationDistance)minDistanceMeters
{
    return [[self class] minDistanceFeet] * 0.3048;
}

+(int)minDistanceFeet
{
    return 400;
}

@end
