//
//  YCTUserBannerItemModel.h
//  YCT
//
//  Created by 木木木 on 2022/1/10.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTUserBannerItemModel : YCTBaseModel
@property (nonatomic, copy) NSString *bannerId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSUInteger sort;
@end

NS_ASSUME_NONNULL_END
