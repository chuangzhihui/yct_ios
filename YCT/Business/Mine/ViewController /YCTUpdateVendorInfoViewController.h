//
//  YCTUpdateVendorInfoViewController.h
//  YCT
//
//  Created by 木木木 on 2022/5/8.
//

#import "YCTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTUpdateVendorInfoViewController : YCTBaseViewController

@property (nonatomic, copy) void (^updateCompletion)(void);

@end

NS_ASSUME_NONNULL_END
