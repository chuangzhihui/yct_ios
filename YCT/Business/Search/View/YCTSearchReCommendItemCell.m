//
//  YCTSearchReCommendItemCell.m
//  YCT
//
//  Created by hua-cloud on 2021/12/21.
//

#import "YCTSearchReCommendItemCell.h"

@implementation YCTSearchReCommendItemCell

+ (NSString *)cellReuseIdentifier{
    return NSStringFromClass([self class]);
}

+ (CGSize)sizeWithText:(NSString *)text showTag:(BOOL)showTag{
    UILabel * label = [UILabel new];
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    label.text = text;
    [label sizeToFit];
    return CGSizeMake(MIN(label.bounds.size.width + (showTag ? 18 : 0), Iphone_Width - 30), label.bounds.size.height);
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
    UIStackView * stack = [[UIStackView alloc] initWithArrangedSubviews:@[self.searchText,self.hotTag]];
    stack.distribution = UIStackViewDistributionFill;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 6;
    
    [self.contentView addSubview:stack];
    
    [self.hotTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
    }];
    
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

#pragma mark - getter
- (UILabel *)searchText{
    if (!_searchText) {
        _searchText = [UILabel new];
        _searchText.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _searchText.textColor = UIColor.mainTextColor;
    }
    return _searchText;
}

- (UIView *)hotTag{
    if (!_hotTag) {
        _hotTag = [UIView new];
        _hotTag.layer.cornerRadius = 2.f;
        _hotTag.backgroundColor = UIColorFromRGB(0xFE2B54);
        
        UILabel * hot = [UILabel new];
        hot.text = YCTLocalizedTableString(@"search.hot", @"Home");
        hot.textColor = UIColor.whiteColor;
        hot.font = [UIFont systemFontOfSize:10.f weight:UIFontWeightMedium];
        [_hotTag addSubview:hot];
        [hot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(2.f);
            make.right.mas_offset(-2.f);
        }];
    }
    return _hotTag;
}
@end
