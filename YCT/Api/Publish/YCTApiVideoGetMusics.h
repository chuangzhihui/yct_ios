//
//  YCTApiVideoGetMusics.h
//  YCT
//
//  Created by hua-cloud on 2022/1/6.
//

#import "YCTBaseRequest.h"
#import "YCTBgmMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiVideoGetMusics : YCTBaseRequest

- (instancetype)initWithPage:(NSInteger)page;
- (instancetype)initWithAddBgmAi:(NSInteger)type text:(NSString *)text;
//- (instancetype)initWithGetBgmAi:(NSInteger)type taskId:(NSString *)taskId;
@end

NS_ASSUME_NONNULL_END
