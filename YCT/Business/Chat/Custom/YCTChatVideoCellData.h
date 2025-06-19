//
//  YCTChatVideoCellData.h
//  YCT
//
//  Created by 木木木 on 2022/1/8.
//

#import "TUIBubbleMessageCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTChatVideoCellData : TUIBubbleMessageCellData
@property NSString *videoUrl;
@property NSString *thumbUrl;
@property NSString *videoId;
@property NSString *userId;
@property NSString *nickName;
@property NSString *remark;
@end

NS_ASSUME_NONNULL_END
