//
//  NSDate+Utils.m
//  YCT
//
//  Created by 木木木 on 2021/12/15.
//

#import "NSDate+Utils.h"

#define D_DAY        86400

@implementation NSDate (Utils)

+ (NSString *)dateToStringWithTimeInterval:(NSTimeInterval)timeInterval formate:(NSString *)formate {
    if (timeInterval > 0) {
        return [[NSDate dateWithTimeIntervalSince1970:timeInterval] dateToStringWithFormate:formate];
    } else {
        return @"";
    }
}

- (NSString *)dateToStringWithFormate:(NSString *)formate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:formate];
    return [dateFormatter stringFromDate:self];
}

- (NSInteger)apartDaysWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay;
    NSDateComponents *delta = [calendar components:unit fromDate:date toDate:self options:0];
    return delta.day;
}

@end
