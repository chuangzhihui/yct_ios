//
//  YCTSupplyDemandItemModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import "YCTCommonUserModel.h"
#import "YCTGXTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTSupplyDemandItemModel : YCTCommonUserModel
/// 供需id
@property (nonatomic, copy) NSString *itemId;
/// 发布时间
@property (nonatomic, assign) NSTimeInterval atime;
/// 发布类型 1供应 2需求
@property (nonatomic, assign) YCTPostType type;
/// 标签
@property (nonatomic, copy) NSArray<NSString *> *tagTexts;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 详细地址
@property (nonatomic, copy) NSString *address;
/// 联系电话
@property (nonatomic, copy) NSString *mobile;
/// 图集
@property (nonatomic, copy) NSArray *imgs;
/// 商品类型
@property (nonatomic, copy) NSString *goodstype;

@property (nonatomic, copy) NSAttributedString *releaseText;
@property (nonatomic, strong) YYTextLayout *tagsLayout;
@end

NS_ASSUME_NONNULL_END
