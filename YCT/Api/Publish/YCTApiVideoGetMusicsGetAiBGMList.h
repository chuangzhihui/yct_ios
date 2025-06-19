//
//  YCTApiVideoGetMusicsGetAiBGMList.h
//  YCT
//
//  Created by 林涛 on 2025/4/3.
//

#import "YCTBaseRequest.h"
#import "YCTBgmMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiVideoGetMusicsGetAiBGMList : YCTBaseRequest

- (instancetype)initWithPage:(NSInteger)page taskId:(NSString *)taskId;

@end

NS_ASSUME_NONNULL_END
