//
//  YCTShareView.h
//  YCT
//
//  Created by 木木木 on 2021/12/18.
//

#import <UIKit/UIKit.h>
#import "YCTShareModel.h"
#import "YCTShareResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTShareView : UIView

- (void)setShareTypes:(YCTShareType)shareType
           shareBlock:(void (^)(YCTShareType shareType, YCTShareResultModel * _Nullable resultModel))shareBlock;

- (void)show;

@end

NS_ASSUME_NONNULL_END
