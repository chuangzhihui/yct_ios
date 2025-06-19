//
//  YCTPaypalViewController.h
//  YCT
//
//  Created by 张大爷的 on 2024/6/23.
//

#import "YCTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTPaypalViewController : YCTBaseViewController
@property (nonatomic, copy) NSURL *url;
@property (nonatomic,copy) void(^onAuthSuccesss)(NSString * result);
@property (nonatomic,copy) void(^onAuthGenericSuccess)(NSString * result);
@property (nonatomic,copy) void(^onAuthCancelPayment)(NSString * result);
@end

NS_ASSUME_NONNULL_END
