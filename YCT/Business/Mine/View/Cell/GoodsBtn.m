//
//  GoodsBtn.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/26.
//

#import "GoodsBtn.h"

@implementation GoodsBtn
-(instancetype)init{
    self=[super init];
    if(self){
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=3;
        self.layer.borderWidth=0.5;
        self.layer.borderColor=rgba(239,239,239,1).CGColor;
        [self addSubview:self.title];
        [self addSubview:self.icon];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.icon.mas_left).offset(-7);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.size.sizeOffset(CGSizeMake(10, 6));
            make.right.equalTo(self.mas_right).offset(-10);
        }];
    }
    return self;
}
-(UILabel *)title{
    if(!_title){
        _title=[[UILabel alloc] init];
        _title.textColor=rgba(193,193,193,1);
        _title.font=fontSize(14);
//        [_btn1 setImage:[UIImage imageNamed:@"downIcon"] forState:UIControlStateNormal];
//        [self.contentView addSubview:_btn1];
//        _btn1.layer.borderWidth=0.5;
//        _btn1.layer.borderColor=rgba(239,239,239,1).CGColor;
//        _btn1.layer.masksToBounds=YES;
//        _btn1.layer.cornerRadius=3;
//        _btn1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
//        [_btn1 setTitleColor:rgba(193,193,193,1) forState:UIControlStateNormal];
//        [_btn1 setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//        [_btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
//        [_btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    return _title;
}
-(UIImageView *)icon{
    if(!_icon){
        _icon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downIcon"]];
    }
    return _icon;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
