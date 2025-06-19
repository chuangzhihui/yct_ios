//
//  YCTLoginViewController.h
//  YCT
//
//  Created by hua-cloud on 2021/12/23.
//

#import "YCTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTLoginViewController : YCTBaseViewController

- (void)setLoginCompletiom:(dispatch_block_t)loginCompletion;
@end

NS_ASSUME_NONNULL_END
