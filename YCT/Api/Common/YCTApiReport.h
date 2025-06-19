//
//  YCTApiReport.h
//  YCT
//
//  Created by hua-cloud on 2022/1/22.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,YCTReportType) {
    YCTReportTypeUser = 1,
    YCTReportTypeVideo,
    YCTReportTypeComment
};
@interface YCTApiReport : YCTBaseRequest
- (instancetype)initWithType:(YCTReportType)type
                     typeIds:(NSString *)typeIds
                       title:(NSString *)title
                        imgs:(NSString *)imgs
                        told:(NSString *)told;
@end

NS_ASSUME_NONNULL_END
