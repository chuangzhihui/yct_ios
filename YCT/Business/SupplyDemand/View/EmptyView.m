//
//  EmptyView.m
//  YCT
//
//  Created by 张大爷的 on 2022/8/8.
//

#import "EmptyView.h"

@implementation EmptyView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    self.backgroundColor=[UIColor redColor];
    if(self){
        [self addSubview:self.icon];
        [self addSubview:self.msg];
       
    }
    return self;
}
-(UIImageView *)icon{
    if(!_icon){
        _icon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"empty_search"]];
    }
    return _icon;
}
-(UILabel *)msg{
    if(!_msg){
        _msg=[[UILabel alloc] init];
        _msg.font=fontSize(14);
        _msg.textColor=rgba(153,153,153,1);
        _msg.text=YCTLocalizedTableString(@"post.time.empty", @"Post");
    }
    return _msg;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(150, 150));
        make.top.equalTo(self.mas_top).offset(50);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.msg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.icon.mas_bottom).offset(10);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
