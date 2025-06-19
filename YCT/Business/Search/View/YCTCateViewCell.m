//
//  YCTCateViewCell.m
//  YCT
//
//  Created by 张大爷的 on 2022/10/10.
//

#import "YCTCateViewCell.h"

@implementation YCTCateViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self.contentView addSubview:self.title];
        
    }
    return self;
}
-(UILabel *)title{
    if(!_title){
        _title=[[UILabel alloc] init];
        _title.font=fontSize(16);
    }
    return _title;
}

-(void)setCellUI:(YCTCatesModel *)model{
    self.title.text=model.name;
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        if(model.level==1){
            make.left.equalTo(self.contentView.mas_left).offset(20);
        }else if(model.level==2){
            make.left.equalTo(self.contentView.mas_left).offset(40);
        }else{
            make.left.equalTo(self.contentView.mas_left).offset(60);
        }
       
    }];
    if(model.level==1){
        self.title.textColor=rgba(51,51,51,1);
    }else if(model.level==2){
        self.title.textColor=rgba(51,51,51,0.8);
    }else{
        self.title.textColor=rgba(51,51,51,0.6);
    }
}

-(void)setCellUIForHomeSearch:(YCTCatesModel *)model{
    self.title.text=model.name;
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
    self.title.textColor=rgba(51,51,51,1);
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
