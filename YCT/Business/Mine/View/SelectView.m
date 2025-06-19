//
//  SelectView.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/11.
//

#import "SelectView.h"

@implementation SelectView
-(instancetype)init{
    self=[super init];
    if(self){
        
    }
    return self;
}
-(UILabel *)title{
    if(!_title){
        _title=[[UILabel alloc] init];
        _title.textColor=rgba(193,193,193,1);
        _title.font=fontSize(14);
        [self addSubview:_title];
    }
    return  _title;
}
-(UIImageView *)icon{
    if(!_icon){
        _icon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downIcon"]];
        [self addSubview:_icon];
    }
    return _icon;
}
@end
