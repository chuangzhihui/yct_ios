//
//  YCTCommentFooterView.m
//  YCT
//
//  Created by hua-cloud on 2021/12/19.
//

#import "YCTCommentFooterView.h"
@interface YCTCommentFooterView ()
@property (nonatomic, copy) dispatch_block_t tap;
@end
@implementation YCTCommentFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.contentView.backgroundColor = UIColor.whiteColor;
    UIButton * unfold = [UIButton buttonWithType:UIButtonTypeSystem];
    [unfold setTintColor:UIColorFromRGB(0x999999)];
    [unfold setTitle:YCTLocalizedTableString(@"comment.unfold", @"Home") forState:UIControlStateNormal];
    unfold.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightMedium];
    @weakify(self);
    [[unfold rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        !self.tap ? : self.tap();
    }];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_unfold"]];
    
    [self.contentView addSubview:unfold];
    [self.contentView addSubview:image];
    
    [unfold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(58);
        make.centerY.equalTo(self.contentView);
    }];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(unfold.mas_right).offset(4);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
}

- (void)responseForTap:(dispatch_block_t)tap{
    _tap = tap;
}
@end
