//
//  YCTVideoDetailViewController.h
//  YCT
//
//  Created by hua-cloud on 2022/1/9.
//

#import "YCTBaseViewController.h"
#import "YCTVideoDefine.h"
#import "YCTVideoModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface YCTVideoDetailViewController : YCTBaseViewController

- (instancetype)initWithVideos:(NSArray<YCTVideoModel *> *)videos
                         index:(NSInteger)index
                          type:(YCTVideoType)type;
@end

NS_ASSUME_NONNULL_END
