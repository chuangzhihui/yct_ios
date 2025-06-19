//
//  YCTResizeImageViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/24.
//

#import "YCTBaseViewController.h"
#import <JPImageresizerView/JPImageresizerConfigure.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCTResizeImageViewController : YCTBaseViewController

@property (nonatomic, strong) JPImageresizerConfigure *configure;

@end

NS_ASSUME_NONNULL_END
