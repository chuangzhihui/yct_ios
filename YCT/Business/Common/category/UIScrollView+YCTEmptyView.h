//
//  UIScrollView+YCTEmptyView.h
//  YCT
//
//  Created by 木木木 on 2022/1/1.
//

#import <UIKit/UIKit.h>
#import "YCTEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (YCTEmptyView)

- (YCTEmptyView *)emptyView;

- (void)setEmptyImage:(UIImage * _Nullable)emptyImage
            emptyInfo:(NSString *)emtyInfo;

- (void)showEmptyView;

- (void)showEmptyViewWithImage:(UIImage * _Nullable)emptyImage
                     emptyInfo:(NSString *)emtyInfo;

- (void)showEmptyViewWithImage:(UIImage * _Nullable)emptyImage
                     emptyInfo:(NSString * _Nullable)emtyInfo
                         inset:(UIEdgeInsets)inset;
@end

NS_ASSUME_NONNULL_END
