//
//  YCTPageControl.h
//  YCT
//
//  Created by 木木木 on 2022/1/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YCTPageControlType) {
    YCTPageControlMiddle = 0,
    YCTPageControlRight,
    YCTPageControlLeft,
};

@class YCTPageControl;

@protocol YCTPageControlDelegate <NSObject>
@optional
- (void)yct_PageControlClick:(YCTPageControl *)pageControl index:(NSInteger)clickIndex;
@end

@interface YCTPageControl : UIControl

/// 其他点是高度的倍数,默认1
@property (nonatomic) NSInteger otherMultiple;

/// 当前点h是高度的倍数,默认2
@property (nonatomic) NSInteger currentMultiple;

/// 控件位置,默认中间
@property (nonatomic) YCTPageControlType type;

/// 分页数量
@property (nonatomic) NSInteger numberOfPages;

/// 当前点所在下标
@property (nonatomic) NSInteger currentPage;

/// 点的大小
@property (nonatomic) NSInteger controlSize;

/// 点的间距
@property (nonatomic) NSInteger controlSpacing;

/// 其他未选中点颜色
@property (nonatomic, strong) UIColor *otherColor;

/// 当前点颜色
@property (nonatomic, strong) UIColor *currentColor;

@property (nonatomic, weak) id<YCTPageControlDelegate > delegate;

- (void)layoutPageControl;

@end

NS_ASSUME_NONNULL_END
