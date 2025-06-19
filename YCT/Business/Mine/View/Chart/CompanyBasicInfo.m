//
//  CompanyBasicInfo.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/9.
//

#import "CompanyBasicInfo.h"

@implementation CompanyBasicInfo
-(instancetype)init{
    self=[super init];
    if(self){
        [self.companyNameLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top).offset(20);
            make.right.equalTo(self.mas_right);
           
        }];
        [self.companyDescLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.companyNameLine.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
        [self.mainProduct mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.companyDescLine.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
        [self.industry mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mainProduct.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CompanyBasicInfoLine *)companyNameLine{
    if(!_companyNameLine){
        _companyNameLine=[[CompanyBasicInfoLine alloc] init];
        _companyNameLine.title.text=YCTLocalizedTableString(@"mine.companyInfo.companyName", @"Mine");
        [self addSubview:_companyNameLine];
    }
    return _companyNameLine;
}
-(CompanyBasicInfoLine *)companyDescLine{
    if(!_companyDescLine){
        _companyDescLine=[[CompanyBasicInfoLine alloc] init];
        _companyDescLine.title.text=YCTLocalizedTableString(@"mine.companyInfo.companyDesc", @"Mine");
        [self addSubview:_companyDescLine];
    }
    return _companyDescLine;
}
-(CompanyBasicInfoLine *)mainProduct{
    if(!_mainProduct){
        _mainProduct=[[CompanyBasicInfoLine alloc] init];
        _mainProduct.title.text=YCTLocalizedTableString(@"mine.companyInfo.mainProduct", @"Mine");
        [self addSubview:_mainProduct];
    }
    return _mainProduct;
}
-(CompanyBasicInfoLine *)industry{
    if(!_industry){
        _industry=[[CompanyBasicInfoLine alloc] init];
        _industry.title.text=YCTLocalizedTableString(@"mine.companyInfo.industry", @"Mine");
        [self addSubview:_industry];
    }
    return _industry;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
