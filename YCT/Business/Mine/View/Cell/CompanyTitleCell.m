//
//  CompanyTitleCell.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/11.
//

#import "CompanyTitleCell.h"

@implementation CompanyTitleCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.top.equalTo(self.contentView.mas_top).offset(15);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}
-(UILabel *)title{
    if(!_title){
        _title=[[UILabel alloc] init];
        _title.font=[UIFont boldSystemFontOfSize:18];
        _title.textColor=rgba(51,51,51,1);
        [self.contentView addSubview:_title];
    }
    return _title;
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
