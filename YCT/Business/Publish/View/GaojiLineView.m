//
//  GaojiLineView.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/13.
//

#import "GaojiLineView.h"

@implementation GaojiLineView
-(instancetype)init{
    self=[super init];
    if(self){
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(15);
        }];
        [self.kg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(60, 30));
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
    }
    return self;
}
-(UILabel *)title{
    if(!_title){
        _title=[[UILabel alloc] init];
        [self addSubview:_title];
        _title.font=[UIFont boldSystemFontOfSize:16];
        _title.textColor=rgba(51,51,51,1);
    }
    return _title;
}
-(UISwitch *)kg{
    if(!_kg){
        _kg=[[UISwitch alloc] init];
        [self addSubview:_kg];
        _kg.onTintColor=UIColor.mainThemeColor;
        _kg.thumbTintColor=rgba(153,153,153,1);
    }
    return _kg;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
