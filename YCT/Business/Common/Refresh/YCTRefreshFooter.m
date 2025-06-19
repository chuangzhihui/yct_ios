//
//  YCTRefreshFooter.m
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import "YCTRefreshFooter.h"

@interface YCTRefreshFooter()
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation YCTRefreshFooter

- (void)prepare {
    [super prepare];
    
    self.mj_h = 40;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont PingFangSCMedium:14];
    label.textColor = UIColor.mainGrayTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

- (void)placeSubviews {
    [super placeSubviews];
    
    self.label.frame = self.bounds;
    self.loading.center = CGPointMake(self.mj_w / 2, self.mj_h * 0.5);
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = YCTLocalizedString(@"load.pull");
            self.label.hidden = NO;
            [self.loading stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"";
            self.label.hidden = YES;
            [self.loading startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = self.noMoreText ?: YCTLocalizedString(@"load.noMore");
            self.label.hidden = NO;
            [self.loading stopAnimating];
            break;
        default:
            break;
    }
}

@end
