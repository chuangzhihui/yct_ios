//
//  YCTSearchHistoryHeaderView.m
//  YCT
//
//  Created by hua-cloud on 2021/12/21.
//

#import "YCTSearchHistoryHeaderView.h"

@implementation YCTSearchHistoryHeaderView
+ (NSString *)cellReuseIdentifier{
    return NSStringFromClass([self class]);
}

+ (CGSize)headerSize{
    return CGSizeMake(Iphone_Width, 40);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self addSubview:self.headerTitle];
    [self addSubview:self.actionButton];
    
    [self.headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.bottom.mas_offset(0);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerTitle);
        make.right.mas_offset(-16);
    }];
}

#pragma mark - getter
- (UILabel *)headerTitle{
    if (!_headerTitle) {
        _headerTitle = [UILabel new];
        _headerTitle.textColor = UIColor.mainTextColor;
        _headerTitle.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightBold];
    }
    return _headerTitle;
}

- (UIButton *)actionButton{
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setTitleColor:UIColor.mainGrayTextColor forState:UIControlStateNormal];
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:12.f weight:UIFontWeightMedium];
    }
    return _actionButton;
}
@end
