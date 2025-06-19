//
//  YCTCommentViewController.h
//  YCT
//
//  Created by hua-cloud on 2021/12/18.
//

#import "YCTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTCommentViewController : YCTBaseViewController

@property (nonatomic, copy) void(^commentCountCallback)(NSInteger num);
@property (nonatomic,copy) void(^onGoUser)(NSString *userId);
- (instancetype)initWithVideoId:(NSString *)videoId commentCount:(NSInteger)commentCount;


@end

NS_ASSUME_NONNULL_END
