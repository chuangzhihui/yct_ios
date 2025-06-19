//
//  YCTSearchHistoryFooter.m
//  YCT
//
//  Created by hua-cloud on 2021/12/21.
//

#import "YCTSearchHistoryFooter.h"

@implementation YCTSearchHistoryFooter
+ (NSString *)cellReuseIdentifier{
    return NSStringFromClass([self class]);
}
+ (CGSize)footerSize{
    return CGSizeMake(Iphone_Width, 50);
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
    UIView * bottomLine = [UIView new];
    bottomLine.backgroundColor = UIColorFromRGB(0xEFEFEF);
    
    [self addSubview:self.deleteHistoryButton];
    [self addSubview:bottomLine];
    
    [self.deleteHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-25);
        make.centerX.equalTo(self);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.height.mas_equalTo(1);
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
    }];
}

#pragma mark - getter
- (UIButton *)deleteHistoryButton{
    if (!_deleteHistoryButton) {
        _deleteHistoryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_deleteHistoryButton setTintColor:UIColor.mainGrayTextColor];
        [_deleteHistoryButton setTitleColor:UIColor.mainGrayTextColor forState:UIControlStateNormal];
        [_deleteHistoryButton setImage:[UIImage imageNamed:@"home_search_delete"] forState:UIControlStateNormal];
        [_deleteHistoryButton setTitle:YCTLocalizedTableString(@"search.historyClear", @"Home") forState:UIControlStateNormal];
        _deleteHistoryButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return _deleteHistoryButton;
}
@end
