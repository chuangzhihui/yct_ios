//
//  NSDate+Utils.h
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Utils)

+ (NSString *)dateToStringWithTimeInterval:(NSTimeInterval)timeInterval formate:(NSString *)formate;

/// 获取系统时区并以指定日期格式的时间字符串
/// @param formate 日期格式字符串
- (NSString *)dateToStringWithFormate:(NSString *)formate;

/// 和date相比，过去了几天，可能是负值
/// @param date 比较的date
- (NSInteger)apartDaysWithDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
