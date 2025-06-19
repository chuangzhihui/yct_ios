//
//  AiClassificationListCell.m
//  YCT
//
//  Created by 林涛 on 2025/3/25.
//

#import "AiClassificationListCell.h"

@interface AiClassificationListCell ()
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UIView *bgVw;
@property (nonatomic, strong) UIButton *nameBtn;
@end
@implementation AiClassificationListCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setViewUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setViewUI {
    [self.contentView addSubview:self.nameBtn];
    
    [self.nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark ------ Data ------
- (void)setDataModel:(Children *)dataModel {
    _dataModel = dataModel;
    if (_dataModel) {
        [_nameBtn setTitle:_dataModel.name forState:(UIControlStateNormal)];
    }
}

#pragma mark ------ method ------
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
//    _nameBtn.selected = selected;
//    UIColor *bgC = selected ? UIColorFromRGBA(0x032DA9, 0.1):UIColorFromRGBA(0xF7F7F7, 1.0);
//    [_nameBtn setBackgroundColor:bgC];
}

#pragma mark ------ Getters And Setters ------
//- (UIView *)bgVw {
//    if (!_bgVw) {
//        _bgVw = [[UIView alloc]init];
//        _bgVw.backgroundColor = UIColorFromRGBA(0x032DA9, 0.1);
//    }
//    return _bgVw;
//}
//- (UILabel *)nameLb {
//    if (!_nameLb) {
//        UILabel *label = [[UILabel alloc]init];
//        label.text = @"name";
//        label.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightBold)];
//        label.textColor = UIColorFromRGB(0x333333);
//        _nameLb = label;
//    }
//    return _nameLb;
//}
- (UIButton *)nameBtn {
    if (!_nameBtn) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:@"Name" forState:(UIControlStateNormal)];
        [btn setBackgroundColor:UIColorFromRGBA(0xF7F7F7, 1.0)];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
//        [btn setTitleColor:UIColorFromRGB(0x032DA9) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        btn.layer.cornerRadius = 35/2;
        btn.layer.masksToBounds = true;
        btn.userInteractionEnabled = false;
        _nameBtn = btn;
    }
    return _nameBtn;
}
@end
