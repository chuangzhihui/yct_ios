//
//  JXCategoryTitleView+Customization.m
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import "JXCategoryTitleView+Customization.h"

@implementation JXCategoryTitleView (Customization)

+ (JXCategoryTitleView *)normalCategoryTitleView {
    JXCategoryTitleView *view = [[JXCategoryTitleView alloc] init];
    view.titleColorGradientEnabled = YES;
    view.averageCellSpacingEnabled = NO;
    view.titleFont = UIFont.segmentFont;
    view.titleSelectedFont = UIFont.segmentSelectedFont;
    view.titleColor = UIColor.segmentTitleColor;
    view.titleSelectedColor = UIColor.segmentSelectedTitleColor;
    view.cellSpacing = 39;
    view.contentEdgeInsetLeft = 16;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorWidth = 20;
    lineView.indicatorHeight = 3;
    lineView.indicatorCornerRadius = 2;
    lineView.indicatorColor = UIColor.mainThemeColor;
    view.indicators = @[lineView];
    
    UIView *line = [[UIView alloc] init];
    line.tag = kLineViewTag;
    line.backgroundColor = UIColor.separatorColor;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(onePx);
    }];
    return view;
}

@end
