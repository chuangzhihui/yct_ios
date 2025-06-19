//
//  BecomeCompanySuccessPromptView.m
//  YCT
//
//  Created by 林涛 on 2025/5/9.
//

#import "BecomeCompanySuccessPromptView.h"

@interface BecomeCompanySuccessPromptView ()
@property (nonatomic, strong) UIView *rootVw;
@property (nonatomic, strong) UIView *bgVw;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *textLb;
@property (nonatomic, strong) UIImageView *typeImg;
@end

@implementation BecomeCompanySuccessPromptView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, Iphone_Width, Iphone_Height);
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.rootVw];
    [self.rootVw addSubview:self.bgVw];
    [self.bgVw addSubview:self.closeBtn];
    [self.bgVw addSubview:self.textLb];
    [self.bgVw addSubview:self.typeImg];
    
    [self.bgVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(kAutoScaleX(260));
//        make.height.mas_equalTo(kAutoScaleX(420));
        make.bottom.mas_equalTo(_typeImg.mas_bottom).offset(kAutoScaleX(20));
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kAutoScaleX(15));
        make.right.mas_equalTo(-kAutoScaleX(15));
        make.width.mas_equalTo(kAutoScaleX(30));
        make.height.mas_equalTo(kAutoScaleX(30));
    }];
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kAutoScaleX(35));
        make.left.mas_equalTo(kAutoScaleX(20));
        make.right.mas_equalTo(-kAutoScaleX(20));
    }];
    
    [self.typeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textLb.mas_bottom).offset(kAutoScaleX(20));
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(kAutoScaleX(55));
    }];
}

#pragma mark ------ Data ------

#pragma mark ------ method ------
- (void)closeBtnTouch {
    [UIView animateWithDuration:0.3 animations:^{
        self.rootVw.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        self.rootVw.alpha = 1.0;
    }];
}

#pragma mark ------ Getters And Setters ------
- (UIView *)rootVw {
    if (!_rootVw) {
        _rootVw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Iphone_Width, Iphone_Height)];
        _rootVw.backgroundColor = UIColorFromRGBA(0x000000, 0.4);
        _rootVw.alpha = 0.0;
    }
    return _rootVw;
}
- (UIView *)bgVw {
    if (!_bgVw) {
        _bgVw = [[UIView alloc]init];
        _bgVw.backgroundColor = UIColorFromRGBA(0xFFFFFF, 1);
        _bgVw.layer.cornerRadius = 16;
    }
    return _bgVw;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setImage:[UIImage imageNamed:@"home_pop_prompt_close"] forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(closeBtnTouch) forControlEvents:(UIControlEventTouchUpInside)];
        _closeBtn = btn;
    }
    return _closeBtn;
}
- (UILabel *)textLb {
    if (!_textLb) {
        UILabel *label = [[UILabel alloc]init];
        label.text = YCTLocalizedTableString(@"home.becomeCompanySuccessPrompt", @"Home");
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGBA(0x333333, 1);
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _textLb = label;
    }
    return _textLb;
}
- (UIImageView *)typeImg {
    if (!_typeImg) {
        UIImageView * view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_pop_prompt_tab"]];
        view.contentMode = UIViewContentModeScaleAspectFit;
        _typeImg = view;
    }
    return _typeImg;
}

@end
