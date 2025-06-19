//
//  YCTBasicMsgModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/28.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTBasicMsgModel : YCTBaseModel
/// 粉丝消息
@property (nonatomic, copy) NSString *fansMsg;
/// 通知消息
@property (nonatomic, copy) NSString *noticeMsg;
/// 是否已读通知消息
@property (nonatomic, assign) BOOL isReadNoticeMsg;
/// 最新互动消息
@property (nonatomic, copy) NSString *interactionMsg;
/// 是否已读最新互动消息
@property (nonatomic, assign) BOOL isReadInteractionMsg;
@end

NS_ASSUME_NONNULL_END
