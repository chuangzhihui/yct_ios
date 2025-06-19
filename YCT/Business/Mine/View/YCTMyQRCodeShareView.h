//
//  YCTMyQRCodeShareView.h
//  YCT
//
//  Created by 木木木 on 2021/12/18.
//

#import <UIKit/UIKit.h>
#import "YCTShareModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTMyQRCodeShareView : UIView

@property (copy, nonatomic) void (^clickBlock)(YCTShareType shareType);

@end

NS_ASSUME_NONNULL_END
