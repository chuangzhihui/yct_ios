//
//  YCTApiHomeVideoList.h
//  YCT
//
//  Created by hua-cloud on 2021/12/28.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, YCTApiHomeVideoType) {
    YCTApiHomeVideoTypeRecommand,
    YCTApiHomeVideoTypeFocus
};
@interface YCTApiHomeVideoList : YCTBaseRequest

- (instancetype)initWithPage:(NSInteger)page type:(YCTApiHomeVideoType)type ids:(NSString *)ids user_type:(NSInteger )user_type;

@end

NS_ASSUME_NONNULL_END
