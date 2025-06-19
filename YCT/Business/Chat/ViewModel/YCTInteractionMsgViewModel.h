//
//  YCTInteractionMsgViewModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/3.
//

#import "YCTBasePagedViewModel.h"
#import "YCTApiInteractionMsg.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTInteractionMsgViewModel : YCTBasePagedViewModel<YCTInteractionMsgModel *, YCTApiInteractionMsg *>

- (CGFloat)getCellHeightAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
