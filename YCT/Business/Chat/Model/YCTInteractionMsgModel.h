//
//  YCTInteractionMsgModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/29.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTInteractionMsgModel : YCTBaseModel
/// (0未认证，1已认证)
@property (nonatomic, assign) BOOL isauthentication;
@property (nonatomic, assign) NSUInteger videoId;
@property (nonatomic, assign) NSUInteger userId;
/// 用户类型
@property (nonatomic, assign) YCTMineUserType userType;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *msg;
/// 视频缩略图
@property (nonatomic, copy) NSString *thumbUrl;
/// 关注状态 0对方未关注我 1对方关注了我 2互相关注了
@property (nonatomic, assign) NSInteger floowStatus;
/// 0无用 1回复了你 2评论了你
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger atime;

/// 时间字符串
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) NSString *identityStr;

@property (nonatomic, assign) CGRect thumbFrame;
@property (nonatomic, assign) CGRect avatarFrame;
@property (nonatomic, assign) CGRect nameFrame;
@property (nonatomic, assign) CGRect vipFrame;
@property (nonatomic, assign) CGRect identityFrame;
@property (nonatomic, assign) CGRect contentFrame;
@property (nonatomic, assign) CGRect timeFrame;
@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
