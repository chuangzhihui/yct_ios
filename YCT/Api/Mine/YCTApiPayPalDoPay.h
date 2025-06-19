//
//  YCTApiPayPalDoPay.h
//  YCT
//
//  Created by 张大爷的 on 2024/6/23.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiPayPalDoPay : YCTBaseRequest
@property (nonatomic, copy) NSString *order_sn;
@end

NS_ASSUME_NONNULL_END
