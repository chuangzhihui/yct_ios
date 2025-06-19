//
//  YCTChooseIndustryCell.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/11.
//

#import "YCTChooseIndustryCell.h"

@implementation YCTChooseIndustryCell



-(UILabel *)title{
    if(!_title){
        _title=[[UILabel alloc] init];
        _title.textColor=rgba(51, 51, 51, 1);
        _title.font=fontSize(16);
        [self.contentView addSubview:_title];
    }
    return _title;
}
-(UIImageView *)jt{
    if(!_jt){
        _jt=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"publish_right_arrow"]];
        [self.contentView addSubview:_jt];
    }
    return _jt;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    [self.jt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.sizeOffset(CGSizeMake(14, 14));
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
