//
//  YCTFeedBackViewController.h
//  YCT
//
//  Created by hua-cloud on 2022/1/19.
//

#import "YCTBaseViewController.h"
#import "YCTApiReport.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,YCTFeedbackType) {
    YCTFeedbackTypeFeedBack,
    YCTFeedbackTypeInform,
};
@interface YCTFeedBackViewController : YCTBaseViewController

- (instancetype)initWithReportType:(YCTReportType)type reportId:(NSString *)reportId;

- (instancetype)initFeedBack;
@end

NS_ASSUME_NONNULL_END
