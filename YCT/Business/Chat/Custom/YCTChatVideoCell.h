//
//  YCTChatVideoCell.h
//  YCT
//
//  Created by 木木木 on 2022/1/8.
//

#import "TUIBubbleMessageCell.h"
#import "YCTChatVideoCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTChatVideoCell : TUIBubbleMessageCell

@property YCTChatVideoCellData *customData;

- (void)fillWithData:(YCTChatVideoCellData *)data;

@end

NS_ASSUME_NONNULL_END
