//
//  YCTMineUserInfoModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import "YCTBaseModel.h"
#import "YCTUserBannerItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YCTMineUserSex) {
    YCTMineUserSexUnknown = 0,
    YCTMineUserSexMale = 1,
    YCTMineUserSexFemale = 2,
};

typedef NS_ENUM(NSUInteger, YCTMineUserType) {
    YCTMineUserTypeNormal = 1,
    YCTMineUserTypeBusiness = 2,
};

@interface YCTMineUserInfoModel : YCTBaseModel
/// 点赞数量
@property (nonatomic, assign) NSInteger zanNum;
/// 我的关注人数
@property (nonatomic, assign) NSInteger fllowNum;
/// 我的粉丝人数
@property (nonatomic, assign) NSInteger fansNum;
/// 用户类型 1普通 2企业
@property (nonatomic, assign) YCTMineUserType userType;
/// 用户自定义ID
@property (nonatomic, copy) NSString *userTag;
/// 用户自定义ID
@property (nonatomic, assign) BOOL canEdituuid;
/// 用户自定义背景图
@property (nonatomic, copy) NSString *userBg;
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// 头像
@property (nonatomic, copy) NSString *avatar;
/// 简介
@property (nonatomic, copy) NSString *introduce;
/// 性别
@property (nonatomic, assign) YCTMineUserSex sex;
/// 生日
@property (nonatomic, copy) NSString *birthday;
/// 地址信息字符串
@property (nonatomic, copy) NSString *locationStr;
/// 标签数组
@property (nonatomic, copy) NSString *userTags;
/// 轮播图数组
@property (nonatomic, copy) NSArray<YCTUserBannerItemModel *> *banners;
/// 是否设置过密码
@property (nonatomic, assign) BOOL isSetPwd;

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, copy) NSString *companyPhone;
@property (nonatomic, copy) NSString *companyWebSite;
@property (nonatomic, copy) NSString *companyEmail;
@property (nonatomic, copy) NSString *companyContact;
/// 营业执照图片url
@property (nonatomic, copy) NSString *businessLicense;
/// 公司门头照图片url
@property (nonatomic, copy) NSString *doorHeadPic;
/// 主营产品
@property (nonatomic, copy) NSString *direction;
/// 手机号码
@property (nonatomic, copy) NSString *mobile;
/// 详细地址
@property (nonatomic, copy) NSString *address;
/// 公司详情
@property (nonatomic, copy) NSString *companydetail;
/// 地址id
@property (nonatomic, copy) NSString *locationid;
/// 所属行业1
@property (nonatomic, copy) NSString *goodstypef;
@property (nonatomic, copy) NSString *goodstypefid;
/// 所属行业2
@property (nonatomic, copy) NSString *goodstypes;
@property (nonatomic, copy) NSString *goodstypesid;
/// 所属行业3
@property (nonatomic, copy) NSString *goodstypet;
/// 完善资料审核状态 userType=2并且status=1才能发布视频或者供需
@property (nonatomic, assign) int status;
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
//注册资本
@property(nonatomic,copy)NSString *registeredcapital;
///申请失败原因
@property(nonatomic,copy)NSString *reason;
///申请时间
@property(nonatomic,copy)NSString *process_time;

@property(nonatomic,copy)NSNumber * audit_price;//审核费用

- (BOOL)isMerchant;
@end

NS_ASSUME_NONNULL_END
