//
//  YCTDayAxisValueFormatter.m
//  YCT
//
//  Created by 木木木 on 2021/12/17.
//

#import "YCTDayAxisValueFormatter.h"

@implementation YCTDayAxisValueFormatter {
    __weak BarLineChartViewBase *_chart;
}

- (id)initForChart:(BarLineChartViewBase *)chart {
    self = [super init];
    if (self) {
        self->_chart = chart;
    }
    return self;
}

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis {
    int days = (int)value;
    int year = [self determineYearForDays:days];
    int month = [self determineMonthForDayOfYear:days];
    
//    NSString *yearName = [@(year) stringValue];
    int dayOfMonth = [self determineDayOfMonthForDays:days month:month + 12 * (year - 2016)];
    
    
    return dayOfMonth == 0 ? @"" : [NSString stringWithFormat:@"%02d/%02d", month+1, dayOfMonth];
}

- (int)daysForMonth:(int)month year:(int)year {
    // month is 0-based
    
    if (month == 1) {
        BOOL is29Feb = NO;
        
        if (year < 1582)  {
            is29Feb = (year < 1 ? year + 1 : year) % 4 == 0;
        } else if (year > 1582) {
            is29Feb = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
        }
        
        return is29Feb ? 29 : 28;
    }
    
    if (month == 3 || month == 5 || month == 8 || month == 10) {
        return 30;
    }
    
    return 31;
}

- (int)determineMonthForDayOfYear:(int)dayOfYear {
    int month = -1;
    int days = 0;
    
    while (days < dayOfYear) {
        month = month + 1;
        
        if (month >= 12)
            month = 0;
        
        int year = [self determineYearForDays:days];
        days += [self daysForMonth:month year:year];
    }
    
    return MAX(month, 0);
}

- (int)determineDayOfMonthForDays:(int)days month:(int)month {
    int count = 0;
    int daysForMonths = 0;
    
    while (count < month) {
        int year = [self determineYearForDays:days];
        daysForMonths += [self daysForMonth:count % 12 year:year];
        count++;
    }
    
    return days - daysForMonths;
}

- (int)determineYearForDays:(int)days {
    if (days <= 366) {
        return 2016;
    } else if (days <= 730) {
        return 2017;
    } else if (days <= 1094) {
        return 2018;
    } else if (days <= 1458) {
        return 2019;
    }
    return 2020;
}

@end
