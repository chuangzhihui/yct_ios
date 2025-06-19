//
//  AiHomeCell.m
//  YCT
//
//  Created by 林涛 on 2025/3/24.
//

#import "AiHomeCell.h"

@interface AiHomeCell ()
@property (nonatomic, strong) UIView *bgVw;

@property (nonatomic, strong) UIImageView *arrowImg;

@end

@implementation AiHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setViewUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setViewUI {
    [self.contentView addSubview:self.bgVw];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.textLb];
    [self.contentView addSubview:self.arrowImg];
    
    [self.bgVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22.5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
//        make.height.mas_equalTo(109);
        make.bottom.mas_equalTo(_textLb.mas_bottom).offset(20);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgVw.mas_top).offset(20);
        make.left.mas_equalTo(_bgVw.mas_left).offset(15);
        make.right.mas_equalTo(_bgVw.mas_right).offset(-15);
    }];
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLb.mas_bottom).offset(15);
        make.left.mas_equalTo(_bgVw.mas_left).offset(15);
        make.right.mas_equalTo(_bgVw.mas_right).offset(-15);
        make.bottom.mas_equalTo(-(22.5));
    }];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgVw.mas_top).offset(26.6/2);
        make.right.mas_equalTo(_bgVw.mas_right).offset(-(25/2));
        make.width.mas_equalTo(30/2);
        make.height.mas_equalTo(8.4/2);
    }];
}

#pragma mark ------ Data ------

#pragma mark ------ method ------

#pragma mark ------ Getters And Setters ------
- (UIView *)bgVw {
    if (!_bgVw) {
        _bgVw = [[UIView alloc]init];
        _bgVw.backgroundColor = UIColor.whiteColor;
        _bgVw.layer.cornerRadius = 10;
        _bgVw.layer.borderColor = UIColorFromRGB(0xE5E5E5).CGColor;
        _bgVw.layer.borderWidth = 1;
        _bgVw.layer.masksToBounds = true;
    }
    return _bgVw;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"AI";
        label.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightBold)];
        label.textColor = UIColorFromRGB(0x333333);
        label.numberOfLines = 0;
        _nameLb = label;
    }
    return _nameLb;
}
- (UILabel *)textLb {
    if (!_textLb) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"Ftozon building with AI.";
        label.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightBold)];
        label.textColor = UIColorFromRGB(0x666666);
        label.numberOfLines = 0;
        _textLb = label;
    }
    return _textLb;
}
- (UIImageView *)arrowImg {
    if (!_arrowImg) {
        UIImageView * view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ai_home_arrow"]];
        view.contentMode = UIViewContentModeScaleAspectFill;
        _arrowImg = view;
    }
    return _arrowImg;
}

@end
