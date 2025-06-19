//
//  YTCCategoryNavigationTitleView.m
//  YCT
//
//  Created by 木木木 on 2021/12/21.
//

#import "YTCCategoryNavigationTitleView.h"

@implementation YTCCategoryNavigationTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleView = [JXCategoryTitleView normalCategoryTitleView];
        self.titleView.titleLabelZoomEnabled = YES;
        self.titleView.titleLabelZoomScale = 1.3;
        self.titleView.cellSpacing = 25;
        self.titleView.titleColor = UIColor.segmentSelectedTitleColor;
        [self addSubview:self.titleView];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        UIView *line = [self.titleView viewWithTag:kLineViewTag];
        [line removeFromSuperview];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

@end
