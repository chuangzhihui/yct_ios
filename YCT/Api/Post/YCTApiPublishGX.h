//
//  YCTApiPublishGX.h
//  YCT
//
//  Created by 木木木 on 2021/12/27.
//

#import "YCTBaseRequest.h"
#import "YCTGXTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiPublishGX : YCTBaseRequest

- (instancetype)initWithType:(YCTPostType)type
                       title:(NSString *)title
                        imgs:(nullable NSArray *)imgs
                      mobile:(NSString *)mobile
                     address:(NSString *)address
                  locationId:(NSString *)locationId
                   goodstype:(NSString *)goodstype
                    tagTexts:(nullable NSArray *)tagTexts;

@end

NS_ASSUME_NONNULL_END
