//
//  YCTMyGXListModel.h
//  YCT
//
//  Created by 木木木 on 2021/12/31.
//

#import "YCTBaseModel.h"
#import "YCTGXTag.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YCTMyGXListType) {
    YCTMyGXListTypeDisplay = 1,
    YCTMyGXListTypeAuditing = 0,
    YCTMyGXListTypeAuditFailed = 3,
    YCTMyGXListTypeRemoved = 2
};

@interface YCTMyGXListModel : YCTBaseModel
@property (nonatomic, copy) NSString *identifier;
/// 供需类型
@property (nonatomic, assign) YCTPostType type;
@property (nonatomic, assign) YCTMyGXListType status;
/// 时间
@property (nonatomic, assign) NSInteger atime;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 拒绝原因
@property (nonatomic, copy) NSString *reason;
/// 图集
@property (nonatomic, copy) NSArray *imgs;
/// 详细地址
@property (nonatomic, copy) NSString *address;
/// 国家省市
@property (nonatomic, copy) NSString *area;
/// 联系电话
@property (nonatomic, copy) NSString *mobile;
/// 标签
@property (nonatomic, copy) NSArray<NSString *> *tagTexts;
/// locationId
@property (nonatomic, copy) NSString *locationId;
/// 商品分类
@property (nonatomic, copy) NSString *goodstype;

@property (copy, nonatomic) NSString *statusText;
@property (copy, nonatomic) NSAttributedString *releaseText;
@property (strong, nonatomic) YYTextLayout *tagsLayout;

+ (UIImage *)statusBgImage:(YCTMyGXListType)type;

@end

NS_ASSUME_NONNULL_END
