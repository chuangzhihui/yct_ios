//
//  YCTAPIGoodsTypeList.h
//  YCT
//
//  Created by 张大爷的 on 2022/10/28.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTAPIGoodsTypeList : YCTBaseRequest
- (instancetype)initWithTypeId:(NSInteger)typeId;
@end

NS_ASSUME_NONNULL_END
