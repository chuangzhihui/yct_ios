//
//  YCTSearchHistoryItemCell.m
//  YCT
//
//  Created by hua-cloud on 2021/12/21.
//

#import "YCTSearchHistoryItemCell.h"

@implementation YCTSearchHistoryItemCell

+ (NSString *)cellReuseIdentifier{
    return NSStringFromClass([self class]);
}

+ (CGSize)sizeWithText:(NSString *)text{
    UILabel * label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    label.textColor = UIColor.mainTextColor;
    label.text = text;
    [label sizeToFit];
    return CGSizeMake(MIN(20 + label.bounds.size.width, Iphone_Width - 30), 30);
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
    UIView * bgView = [UIView new];
    bgView.layer.cornerRadius = 3.f;
    bgView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [bgView addSubview:self.searchText];
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
    }];
    
}

#pragma mark - getter
- (UILabel *)searchText{
    if (!_searchText) {
        _searchText = [UILabel new];
        _searchText.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
        _searchText.textColor = UIColor.mainTextColor;
    }
    return _searchText;
}

@end
