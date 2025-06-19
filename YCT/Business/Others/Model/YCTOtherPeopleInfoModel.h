//
//  YCTOtherPeopleInfoModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/5.
//

#import "YCTCommonUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTOtherPeopleInfoModel : YCTCommonUserModel
/// 点赞数量
@property (nonatomic, assign) NSInteger zanNum;
/// 我的关注人数
@property (nonatomic, assign) NSInteger floowNum;
/// 我的粉丝人数
@property (nonatomic, assign) NSInteger fansNum;
/// 用户自定义背景图
@property (nonatomic, copy) NSString *userBg;
/// 简介
@property (nonatomic, copy) NSString *interduce;
/// 标签数组
@property (nonatomic, copy) NSArray<NSString *> *userTags;
/// 轮播图数组
@property (nonatomic, copy) NSArray<NSString *> *banners;
/// 是否可以私聊
@property (nonatomic, assign) BOOL canChat;
/// 是否可以查看他的喜欢列表
@property (nonatomic, assign) BOOL showZanList;
/// 是否可以查看他的粉丝和关注列表
@property (nonatomic, assign) BOOL showFansList;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, copy) NSString *companyPhone;
@property (nonatomic, copy) NSString *companyWebSite;
@property (nonatomic, copy) NSString *companyEmail;
@property (nonatomic, copy) NSString *companyContact;
@property (nonatomic, copy) NSString *companydetail;
@property (nonatomic, copy) NSString *direction;
/// (0未认证，1已认证)
@property (nonatomic, assign) BOOL isauthentication;
/// （认证内容）
@property (nonatomic, copy) NSString *authentication;
/// 公司类型，输入
@property (nonatomic, copy) NSString *companytype;
/// 社会统一代码
@property (nonatomic, copy) NSString *socialcode;
/// 成立日期（选择）
@property (nonatomic, copy) NSString *businessstart;
/// 营业日期（输入）
@property (nonatomic, copy) NSString *businessterm;
/// 法人代表
@property (nonatomic, copy) NSString *legalname;
/// 所属行业1
@property (nonatomic, copy) NSString *goodstypef;
/// 所属行业2
@property (nonatomic, copy) NSString *goodstypes;
//注册地址
@property(nonatomic,copy)NSString *locationStr;
//注册资本
@property(nonatomic,copy)NSString *registeredcapital;
@end

NS_ASSUME_NONNULL_END
