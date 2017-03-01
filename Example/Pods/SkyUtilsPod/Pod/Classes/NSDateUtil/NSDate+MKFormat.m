//
//  NSDate+MKFormat.m
//  SkyUtils
//
//  Created by Mark Yang on 11/18/15.
//  Copyright © 2015 MissionSky. All rights reserved.
//

#import "NSDate+MKFormat.h"

static NSDateFormatter *dateFormatter;

#pragma mark -

@implementation NSDate (MKFormat)

+ (NSDate *)dateWithString:(NSString *)aDateString
{
    NSString *strFormatter = @"yyyy-MM-dd hh:mm:ss";
    return [NSDate dateWithString:aDateString withFormatter:strFormatter];
}//

+ (NSDate *)dateWithString:(NSString *)aDateString withFormatter:(NSString *)aFormatterString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:aFormatterString];
    
    return [dateFormatter dateFromString:aDateString];
}//


+ (NSDate *)AMSixClock
{
    NSDate *date = [NSDate date];
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [theCalendar setTimeZone:timeZone];
    unsigned unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSDateComponents *comps = [theCalendar components:unitFlags fromDate:date];
    [comps setHour:6];
    [comps setMinute:0];
    [comps setSecond:0];
    
    NSDate *dateAMSixClock = [theCalendar dateFromComponents:comps];
    
    return dateAMSixClock;
}//

#pragma mark -

- (NSString *)dateStringWithFormatter:(NSString *)aFormatterString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:aFormatterString];
    
    return [dateFormatter stringFromDate:self];
}//

+ (NSString *)dateStringWithTime:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    if (nil == dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}//

#pragma mark -
#pragma makr Message Format Date String

+ (NSString *)compareWithCurrentTime:(NSTimeInterval)timeInterval
{
    NSTimeInterval currentDateTimeInterval = [[NSDate date] timeIntervalSince1970];
    timeInterval = currentDateTimeInterval - timeInterval;
    
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if ((temp = timeInterval / 60) < 60) {
        result = [NSString stringWithFormat:@"%ld分前", temp];
    }
    else if ((temp = temp / 60) < 24) {
        result = [NSString stringWithFormat:@"%ld小时前", temp];
    }
    else if ((temp = temp / 24) < 30) {
        result = [NSString stringWithFormat:@"%ld天前", temp];
    }
    else if ((temp = temp / 30) < 12) {
        result = [NSString stringWithFormat:@"%ld月前", temp];
    }
    else {
        temp = temp / 12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}//

@end
