//
//  YCTShareFriendListView.h
//  YCT
//
//  Created by 木木木 on 2021/12/19.
//

#import <UIKit/UIKit.h>
#import "YCTShareResultModel.h"
#import "YCTShareModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YCTShareFriendListView : UIView

- (instancetype)initWithShareBlock:(void (^)(YCTShareType shareType, YCTShareResultModel * _Nullable resultModel))shareBlock;

@end

NS_ASSUME_NONNULL_END
