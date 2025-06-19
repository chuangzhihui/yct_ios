//
//  UIScrollView+YCTEmptyView.m
//  YCT
//
//  Created by 木木木 on 2022/1/1.
//

#import "UIScrollView+YCTEmptyView.h"
#import "YCTEmptyView.h"

@implementation UIScrollView (YCTEmptyView)

- (void)setEmptyImage:(UIImage *)emptyImage
            emptyInfo:(NSString *)emtyInfo {
    [[self emptyView] setEmptyImage:emptyImage emptyInfo:emtyInfo];
}

- (void)showEmptyView {
    if ([self isKindOfClass:UITableView.class]) {
        ((UITableView *)self).backgroundView = [self emptyView];
    } else if ([self isKindOfClass:UICollectionView.class]) {
        ((UICollectionView *)self).backgroundView = [self emptyView];
    }
}

- (void)showEmptyViewWithImage:(UIImage *)emptyImage
                     emptyInfo:(NSString *)emtyInfo {
    if ([self isKindOfClass:UITableView.class]) {
        [[self emptyView] setEmptyImage:emptyImage emptyInfo:emtyInfo];
        ((UITableView *)self).backgroundView = [self emptyView];
    } else if ([self isKindOfClass:UICollectionView.class]) {
        [[self emptyView] setEmptyImage:emptyImage emptyInfo:emtyInfo];
        ((UICollectionView *)self).backgroundView = [self emptyView];
    }
}

- (void)showEmptyViewWithImage:(UIImage *)emptyImage
                     emptyInfo:(NSString *)emtyInfo
                         inset:(UIEdgeInsets)inset {
    if ([self isKindOfClass:UITableView.class]) {
        [[self emptyView] setEmptyImage:emptyImage emptyInfo:emtyInfo];
        ((UITableView *)self).backgroundView = [self emptyView];
    } else if ([self isKindOfClass:UICollectionView.class]) {
        [[self emptyView] setEmptyImage:emptyImage emptyInfo:emtyInfo];
        ((UICollectionView *)self).backgroundView = [self emptyView];
    }
    self.contentInset = inset;
}

- (YCTEmptyView *)emptyView {
    YCTEmptyView *_emptyView = objc_getAssociatedObject(self, @selector(emptyView));
    if (!_emptyView) {
        _emptyView = [[YCTEmptyView alloc] init];
        objc_setAssociatedObject(self, @selector(emptyView), _emptyView, OBJC_ASSOCIATION_RETAIN);
    }
    return _emptyView;
}

@end
