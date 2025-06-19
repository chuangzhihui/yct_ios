//
//  YCTApiVideoGetMusicsUseAiList.h
//  YCT
//
//  Created by 林涛 on 2025/4/6.
//

#import "YCTBaseRequest.h"
#import "YCTBgmMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiVideoGetMusicsUseAiList : YCTBaseRequest
- (instancetype)initWithPage:(NSInteger)page;

- (instancetype)initWithTaskId:(NSString *)taskId;
@end

NS_ASSUME_NONNULL_END
