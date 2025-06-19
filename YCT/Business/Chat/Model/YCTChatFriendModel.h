//
//  YCTChatFriendModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/2.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTChatFriendModel : YCTBaseModel
/// 是否在线
@property (nonatomic, assign) BOOL isOnline;
/// 上次下线的时间 0代表从来没下过线
@property (nonatomic, assign) NSTimeInterval lastOutTime;
/// 用户ID
@property (nonatomic, copy) NSString *userId;
/// 头像
@property (nonatomic, copy) NSString *avatar;
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// subText
@property (nonatomic, copy) NSString *subText;
@end

NS_ASSUME_NONNULL_END
