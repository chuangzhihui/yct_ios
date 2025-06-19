//
//  YCTApiFeedBack.h
//  YCT
//
//  Created by hua-cloud on 2022/1/22.
//

#import "YCTBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTApiFeedBack : YCTBaseRequest

- (instancetype)initWithTypeIds:(NSString *)typeIds
                        content:(NSString *)content
                           imgs:(NSString *)imgs;

@end

NS_ASSUME_NONNULL_END
