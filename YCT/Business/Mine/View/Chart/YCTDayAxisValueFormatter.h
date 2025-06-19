//
//  YCTDayAxisValueFormatter.h
//  YCT
//
//  Created by 木木木 on 2021/12/17.
//

#import <Foundation/Foundation.h>
#import "YCT-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTDayAxisValueFormatter : NSObject<ChartAxisValueFormatter>

- (id)initForChart:(BarLineChartViewBase *)chart;

@end

NS_ASSUME_NONNULL_END
