//
//  YCTApiUpdateBanner.h
//  YCT
//
//  Created by 木木木 on 2022/1/7.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiAddBanner : YCTBaseRequest

- (instancetype)initWithBannerUrl:(NSString *)bannerUrl;

@end

@interface YCTApiDeleteBanner : YCTBaseRequest

- (instancetype)initWithBannerId:(NSString *)bannerId;

@end

@interface YCTApiSetBannerTop : YCTBaseRequest

- (instancetype)initWithBannerId:(NSString *)bannerId;

@end

NS_ASSUME_NONNULL_END
