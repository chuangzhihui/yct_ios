//
//  YCTApiUpgradeToVendor.h
//  YCT
//
//  Created by 木木木 on 2022/3/1.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiUpgradeToVendor : YCTBaseRequest
@property (nonatomic, copy) NSString *companyName;//公司名称
@property (nonatomic, copy) NSString *introduce;//公司简介
@property (nonatomic, copy) NSString *companyAddress;//公司地址
@property (nonatomic, copy) NSString *companyPhone;//联系电话
@property (nonatomic, copy) NSString *companyContact;//联系人
@property (nonatomic, copy) NSString *locationaddress;//实际定位地址
@property (nonatomic, copy) NSString *companyEmail;//公司邮箱
@property (nonatomic, copy) NSString *companytype;//公司类型
@property (nonatomic, copy) NSString *companyWebSite;//厂家网址
@property (nonatomic, copy) NSString *goodstypef;//公司类型1级
@property (nonatomic, copy) NSString *goodstypes;//公司类型2级
@property (nonatomic, copy) NSString *goodstypet;//公司类型3级
@property (nonatomic, copy) NSString *goodstypesid;//公司类型1级ID
@property (nonatomic, copy) NSString *goodstypefid;//公司类型2级ID
@property (nonatomic, copy) NSString *companydetail;//公司详情
@property (nonatomic, copy) NSString *socialcode;//统一社会代码
@property (nonatomic, copy) NSString *businessstart;//成立日期
@property (nonatomic, copy) NSString *registeredcapital;//注册资本
@property (nonatomic, copy) NSString *legalname;//法人代表
@property (nonatomic, copy) NSString *direction;//主营方向
@property (nonatomic, copy) NSString *businessLicense;//营业执照
@property (nonatomic, copy) NSString *doorHeadPic;//门头照
@property (nonatomic, copy) NSString *locationId;//地址ID


@end

NS_ASSUME_NONNULL_END
