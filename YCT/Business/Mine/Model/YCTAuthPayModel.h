//
//  YCTAuthPayModel.h
//  YCT
//
//  Created by 张大爷的 on 2024/6/22.
//

#import "YCTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTAuthPayModel : YCTBaseModel
@property (copy, nonatomic) NSString *order_sn;
@property (copy, nonatomic) NSString *url;
@end

NS_ASSUME_NONNULL_END
