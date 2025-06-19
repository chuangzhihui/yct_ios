//
//  YCTVipView.m
//  YCT
//
//  Created by 张大爷的 on 2023/4/4.
//

#import "YCTVipView.h"

@implementation YCTVipView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)init{
    self=[super init];
    if(self)
    {
//        self.backgroundColor=[UIColor redColor];
        
        [self addSubview:self.title1];
        [self addSubview:self.title2];
//        [self addSubview:self.title3];
//        [self addSubview:self.title4];
//        [self addSubview:self.title5];
        [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        [self.title2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.title1.mas_bottom).offset(5);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
//        [self.title3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(10);
//            make.top.equalTo(self.title2.mas_bottom).offset(5);
//            make.right.equalTo(self.mas_right).offset(-10);
//        }];
//        [self.title4 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(10);
//            make.top.equalTo(self.title3.mas_bottom).offset(5);
//            make.right.equalTo(self.mas_right).offset(-10);
//        }];
//        [self.title5 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(10);
//            make.top.equalTo(self.title4.mas_bottom).offset(5);
//            make.right.equalTo(self.mas_right).offset(-10);
//            make.bottom.equalTo(self.mas_bottom).offset(-10);
//        }];
    }
    return self;
}
-(UILabel *)title1{
    if(!_title1){
        _title1=[[UILabel alloc] init];
//        _title1.textColor=[UIColor blueColor];
        _title1.font=fontSize(14);
        _title1.numberOfLines=0;
        _title1.text=@"Our videos are free, and we can help you match to a suitable factory according to your needs.";
    }
    return _title1;
}
-(UILabel *)title2{
    if(!_title2){
        _title2=[[UILabel alloc] init];
//        _title2.textColor=[UIColor grayColor];
        _title2.font=fontSize(14);
        _title2.text=@"EMAIL : vnpppdev2022@gmail.com";
    }
    return _title2;
}
-(UILabel *)title3{
    if(!_title3){
        _title3=[[UILabel alloc] init];
//        _title3.textColor=[UIColor grayColor];
        _title3.font=fontSize(14);
        _title3.text=@"ACCOUNT NUMBER : 8133020936";
    }
    return _title3;
}
-(UILabel *)title4{
    if(!_title4){
        _title4=[[UILabel alloc] init];
//        _title4.textColor=[UIColor grayColor];
        _title4.font=fontSize(14);
        _title4.text=@"Account Bank : EAST WEST BANK USA";
    }
    return _title4;
}
-(UILabel *)title5{
    if(!_title5){
        _title5=[[UILabel alloc] init];
//        _title5.textColor=[UIColor grayColor];
        _title5.font=fontSize(14);
        _title5.text=@"SWIFT ADDRESS/BIC : EWBKUS66XXX UNITED STATES";
    }
    return _title5;
}
@end
