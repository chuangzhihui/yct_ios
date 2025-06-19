//
//  CompanyBasicInfoLine.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/9.
//

#import "CompanyBasicInfoLine.h"

@implementation CompanyBasicInfoLine

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    self=[super init];
    if(self){
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            
            make.top.equalTo(self.mas_top).offset(10);
            
        }];
        [self.cont mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_left);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.title.mas_bottom).offset(5);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
  
}

-(UILabel *)title{
    if(!_title){
        _title=[[UILabel alloc] init];
        _title.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.00];
        _title.font=[UIFont boldSystemFontOfSize:14];
        [self addSubview:_title];
    }
    return _title;
}
-(UILabel *)cont{
    if(!_cont){
        _cont=[[UILabel alloc] init];
        _cont.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.00];
        _cont.font=[UIFont systemFontOfSize:14];
        _cont.textAlignment=NSTextAlignmentLeft;
        _cont.numberOfLines=0;
        [self addSubview:_cont];
    }
    return _cont;
}

@end
