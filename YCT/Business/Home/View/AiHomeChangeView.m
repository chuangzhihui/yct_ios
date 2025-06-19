//
//  AiHomeChangeView.m
//  YCT
//
//  Created by 林涛 on 2025/3/26.
//

#import "AiHomeChangeView.h"

@interface AiHomeChangeView ()

@property (nonatomic, strong) UIView *lineVw;

@end

@implementation AiHomeChangeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        self.hidden = true;
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.bgVw];
    [self addSubview:self.selectVw];
    [self.selectVw addSubview:self.btn1];
    [self.selectVw addSubview:self.lineVw];
    [self.selectVw addSubview:self.btn2];
    
    [self.bgVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    CGFloat y = kStatusBarHeight+31;
    [self.selectVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(y);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(91.5);
        make.height.mas_equalTo(87);
    }];
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(43);
    }];
    [self.lineVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_btn1.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_btn1.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(43);
    }];
}

#pragma mark ------ Data ------

#pragma mark ------ method ------
- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.selectVw.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = true;
        }
    }];
}
- (void)show {
    self.hidden = false;
    [UIView animateWithDuration:0.3 animations:^{
        self.selectVw.alpha = 1.0;
    }];
}

#pragma mark ------ Getters And Setters ------
- (UIView *)bgVw {
    if (!_bgVw) {
        _bgVw = [[UIView alloc]init];
    }
    return _bgVw;
}
- (UIView *)selectVw {
    if (!_selectVw) {
        _selectVw = [[UIView alloc]init];
        _selectVw.backgroundColor = UIColor.whiteColor;
        _selectVw.alpha = 0.0;
        _selectVw.layer.cornerRadius = 5;
        _selectVw.layer.borderColor = UIColorFromRGB(0xE5E5E5).CGColor;
        _selectVw.layer.borderWidth = 0.5;
        
        // 设置阴影
        _selectVw.layer.shadowColor = UIColorFromRGB(0xEEEEEE).CGColor;  // 阴影颜色
        _selectVw.layer.shadowOffset = CGSizeMake(0, 5);           // 阴影偏移量 (x, y)
        _selectVw.layer.shadowOpacity = 1;                       // 阴影透明度 (0-1)
        _selectVw.layer.shadowRadius = 10;                         // 阴影模糊半径
    }
    return _selectVw;
}

- (UIButton *)btn1 {
    if (!_btn1) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:@"中文" forState:(UIControlStateNormal)];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightRegular)];
        _btn1 = btn;
    }
    return _btn1;
}
- (UIView *)lineVw {
    if (!_lineVw) {
        _lineVw = [[UIView alloc]init];
        _lineVw.backgroundColor = UIColorFromRGB(0xE5E5E5);
    }
    return _lineVw;
}
- (UIButton *)btn2 {
    if (!_btn2) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:@"English" forState:(UIControlStateNormal)];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightRegular)];
        _btn2 = btn;
    }
    return _btn2;
}
@end
