//
//  YCTShareHorizontalListView.h
//  YCT
//
//  Created by 木木木 on 2021/12/18.
//

#import <UIKit/UIKit.h>

@class YCTShareItem;

NS_ASSUME_NONNULL_BEGIN

@interface YCTShareHorizontalListView : UIView

- (void)configItems:(NSArray<YCTShareItem *> *)items
         clickBlock:(void (^)(NSUInteger shareType))clickBlock;

@end

NS_ASSUME_NONNULL_END
