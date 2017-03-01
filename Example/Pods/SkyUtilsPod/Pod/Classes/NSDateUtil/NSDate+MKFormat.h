//
//  NSDate+MKFormat.h
//  SkyUtils
//
//  Created by Mark Yang on 11/18/15.
//  Copyright © 2015 MissionSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MKFormat)

/**
 *	@brief	将指定的日期字符串转化为日期(格式：yyyy-MM-dd hh:mm:ss)
 *
 *	@param 	aDateString 	日期字符串(格式：yyyy-MM-dd hh:mm:ss)
 *
 *	@return	日期对象
 *
 *	Created by Mark on 2015-08-06 11:26
 */
+ (NSDate *)dateWithString:(NSString *)aDateString;

/**
 *	@brief	将指定格式的日期字符串转化为日期
 *
 *	@param 	aDateString 	日期字符串
 *	@param 	aFormatterString 	日期字符串格式(如：yyyy-HH-dd)
 *
 *	@return	日期对象
 *
 *	Created by Mark on 2015-08-06 11:27
 */
+ (NSDate *)dateWithString:(NSString *)aDateString withFormatter:(NSString *)aFormatterString;

/**
 *	@brief	当天日期早上六点时间(From 1516's requirement)
 *
 *	@return	当天早上六点日期
 *
 *	Created by Mark on 2015-11-18 17:41
 */
+ (NSDate *)AMSixClock;

#pragma mark -

/**
 *	@brief	根据日期字符串格式转将日期转化相应的字符串
 *
 *	@param 	aFormatterString 	日期字符串格式(如：yyyy-HH-dd)
 *
 *	@return	日期字符串
 *
 *	Created by Mark on 2014-12-19 19:56
 */
- (NSString *)dateStringWithFormatter:(NSString *)aFormatterString;

/**
 *	@brief  根据时间TimeInterval转化相应的日期字符串(yyyy-MM-dd)
 *
 *	@param 	timeInterval 	时间
 *
 *	@return	日期字符串
 *
 *	Created by Mark on 2015-11-24 15:24
 */
+ (NSString *)dateStringWithTime:(NSTimeInterval)timeInterval;

#pragma mark -
#pragma makr Message Format Date String

/**
 *	@brief	获取IM风格的时间戳(如：刚刚、xx分前、xx小时前、xx天前、xx月前、xx年前)
 *
 *	@param 	timeInterval 	时间
 *
 *	@return	与当前系统时间对比后的字符串
 *
 *	Created by Mark on 2015-11-24 15:15
 */
+ (NSString *)compareWithCurrentTime:(NSTimeInterval)timeInterval;

@end
