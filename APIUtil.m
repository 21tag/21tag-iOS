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
    //return @"http://192.168.1.33:8888/api/v2";
    //return @"http://192.168.2.104:8888/api/v2";
    //return @"http://21tag.com:8689";
    return @"http://96.126.124.169:8420/api/v2"; //remote
}

+(NSString*)stringWithTimeDifferenceBetweenThen:(NSString *)then
{
    NSTimeInterval time;
    time = [self timeIntervalFromThen:then];
    
    return [self stringwithFormatFrom:time];
}

+(NSString*)stringwithFormatFrom:(NSTimeInterval)time
{
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
+(NSTimeInterval) timeIntervalFromThen:(NSString *)then
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:enUS];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    NSDate *date = [dateFormat dateFromString:then];
    
    NSTimeInterval time = [date timeIntervalSinceNow];
    time = time *-1;
    return time;
    
}

+(NSString*) StringWithTimeSince:(NSDate *)then
{
    NSTimeInterval time = [then timeIntervalSinceNow];
    return [self stringwithFormatFrom:time];
    
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
