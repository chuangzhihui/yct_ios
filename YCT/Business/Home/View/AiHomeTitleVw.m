//
//  AiHomeTitleVw.m
//  YCT
//
//  Created by 林涛 on 2025/4/17.
//

#import "AiHomeTitleVw.h"

@interface AiHomeTitleVw ()
@property (nonatomic, strong) UILabel *textLb;
@property (nonatomic, strong) UIImageView *lineImg1;
@property (nonatomic, strong) UIImageView *lineImg2;
@end

@implementation AiHomeTitleVw

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setUI {
    [self addSubview:self.textLb];
    [self addSubview:self.lineImg1];
    [self addSubview:self.lineImg2];
    
    [self.textLb setContentCompressionResistancePriority:UILayoutPriorityRequired
                                              forAxis:UILayoutConstraintAxisHorizontal];
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(16);
    }];
    
    [self.lineImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_textLb);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(_textLb.mas_left).offset(-5);
        make.height.mas_equalTo(3);
    }];
    [self.lineImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_textLb);
        make.left.mas_equalTo(_textLb.mas_right).offset(5);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(3);
    }];
    
}

#pragma mark ------ Data ------

#pragma mark ------ method ------

#pragma mark ------ Getters And Setters ------
- (UILabel *)textLb {
    if (!_textLb) {
        UILabel *label = [[UILabel alloc]init];
        label.text = YCTLocalizedTableString(@"ai.productClassification", @"Home");
        label.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
        label.textColor = UIColorFromRGB(0x666666);
        _textLb = label;
    }
    return _textLb;
}
- (UIImageView *)lineImg1 {
    if (!_lineImg1) {
        UIImageView * view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ai_home_title_line_L"]];
        view.contentMode = UIViewContentModeScaleToFill;
        _lineImg1 = view;
    }
    return _lineImg1;
}
- (UIImageView *)lineImg2 {
    if (!_lineImg2) {
        UIImageView * view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ai_home_title_line_R"]];
        view.contentMode = UIViewContentModeScaleToFill;
        _lineImg2 = view;
    }
    return _lineImg2;
}
@end
