//
//  YCTSearchResultHeaderView.m
//  YCT
//
//  Created by hua-cloud on 2021/12/23.
//

#import "YCTSearchResultHeaderView.h"

@implementation YCTSearchResultHeaderView
+ (NSString *)cellReuseIdentifier{
    return NSStringFromClass([self class]);
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
    UIStackView * stack = [[UIStackView alloc] initWithArrangedSubviews:@[self.hotImage,self.headerTitle]];
    stack.distribution = UIStackViewDistributionFill;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.axis = UILayoutConstraintAxisHorizontal;
    [self addSubview:stack];
    
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.bottom.mas_offset(0);
    }];
    
    [self.hotImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55, 28));
    }];
    
    @weakify(self);
    [RACObserve(self, isHot) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.hotImage.hidden = !self.isHot;
    }];
    self.isHot = NO;
}

#pragma - mark -- getter
- (UILabel *)headerTitle{
    if (!_headerTitle) {
        _headerTitle = [UILabel new];
        _headerTitle.textColor = UIColor.mainTextColor;
        _headerTitle.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightBold];
    }
    return _headerTitle;
}

- (UIImageView *)hotImage{
    if (!_hotImage) {
        _hotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_hot"]];
    }
    return _hotImage;
}
@end
