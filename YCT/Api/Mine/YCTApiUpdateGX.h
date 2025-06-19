//
//  YCTApiUpdateGX.h
//  YCT
//
//  Created by 木木木 on 2022/1/11.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiDeleteGX : YCTBaseRequest

- (instancetype)initWithGXId:(NSString *)gxId;

@end

@interface YCTApiOffshelfGX : YCTBaseRequest

- (instancetype)initWithGXId:(NSString *)gxId;

@end

@interface YCTApiUpdateGX : YCTBaseRequest

- (instancetype)initWithGXId:(NSString *)gxId
                       title:(NSString *)title
                        imgs:(NSArray *)imgs
                      mobile:(NSString *)mobile
                     address:(NSString *)address
                  locationId:(NSString *)locationId
                   goodstype:(NSString *)goodstype
                    tagTexts:(NSArray *)tagTexts;

@end

NS_ASSUME_NONNULL_END
