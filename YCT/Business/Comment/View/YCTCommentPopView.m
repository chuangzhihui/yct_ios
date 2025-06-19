//
//  YCTCommentPopView.m
//  YCT
//
//  Created by hua-cloud on 2022/1/22.
//

#import "YCTCommentPopView.h"

@implementation YCTCommentPopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}


- (void)setupView{
    
    @weakify(self);
    UIView * reply = [self getTitleViewWithTitle:YCTLocalizedTableString(@"comment.reply",@"Home") handlerClick:^{
        @strongify(self);
        @weakify(self);
        [self yct_closeWithCompletion:^{
            @strongify(self);
            !self.handlerClick ? : self.handlerClick(YCTCommentPopViewSelectedTypeReply);
        }];
    }];
    
    UIView * copy = [self getTitleViewWithTitle:YCTLocalizedTableString(@"comment.copy",@"Home") handlerClick:^{
        @strongify(self);
        @weakify(self);
        [self yct_closeWithCompletion:^{
            @strongify(self);
            !self.handlerClick ? : self.handlerClick(YCTCommentPopViewSelectedTypeCopy);
        }];
    }];
    
    UIView * report = [self getTitleViewWithTitle:YCTLocalizedString(@"share.report") handlerClick:^{
        @strongify(self);
        @weakify(self);
        [self yct_closeWithCompletion:^{
            @strongify(self);
            !self.handlerClick ? : self.handlerClick(YCTCommentPopViewSelectedTypeReport);
        }];
    }];
    
    UIView * backList = [self getTitleViewWithTitle:YCTLocalizedTableString(@"mine.privacy.block",@"Mine") handlerClick:^{
        @strongify(self);
        @weakify(self);
        [self yct_closeWithCompletion:^{
            @strongify(self);
            !self.handlerClick ? : self.handlerClick(YCTCommentPopViewSelectedTypeBlock);
        }];
    }];
    
    UIStackView * stack = [[UIStackView alloc] initWithArrangedSubviews:@[reply,copy,report,backList]];
    stack.distribution = UIStackViewDistributionFill;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentFill;
    stack.spacing = 5;
    
    [self addSubview:stack];
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [stack.arrangedSubviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(45);
        }];
    }];
    
    self.frame = CGRectMake(0, 0, Iphone_Width - 75, 195);
}


- (UIView *)getTitleViewWithTitle:(NSString *)title handlerClick:(dispatch_block_t)handlerClick{
    UIView * view = [UIView new];
    UILabel * titleLabel = [UILabel new];
    titleLabel.textColor = UIColor.mainTextColor;
    titleLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightMedium];
    titleLabel.text = title;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [view addSubview:titleLabel];
    [view addSubview:button];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(25.5);
        make.centerY.equalTo(view);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        !handlerClick ? :handlerClick();
    }];
    
    return view;
}
@end
