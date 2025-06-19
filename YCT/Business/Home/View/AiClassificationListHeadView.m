//
//  AiClassificationListHeadView.m
//  YCT
//
//  Created by 林涛 on 2025/3/25.
//

#import "AiClassificationListHeadView.h"

@interface AiClassificationListHeadView ()

@end

@implementation AiClassificationListHeadView
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
    [self addSubview:self.nameLb];
    
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(15);
    }];
}

#pragma mark ------ Data ------

#pragma mark ------ method ------

#pragma mark ------ Getters And Setters ------
- (UILabel *)nameLb {
    if (!_nameLb) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"Name";
        label.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
        label.textColor = UIColorFromRGB(0x333333);
        label.numberOfLines = 0;
        _nameLb = label;
    }
    return _nameLb;
}
@end
