//
//  CompanyInfoTableViewCell.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/11.
//

#import "CompanyInfoTableViewCell.h"

@implementation CompanyInfoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initUI];
    }
    return self;
}
-(void)initUI{
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 20, 15));
    }];
    [self.xinyong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content.mas_left).offset(20);
        make.top.equalTo(self.content.mas_top).offset(20);
    }];
    [self.xinyongVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content.mas_left).offset(20);
        make.top.equalTo(self.xinyong.mas_bottom).offset(5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.leixing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.xinyongVal.mas_bottom).offset(15);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.leixingVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.leixing.mas_bottom).offset(5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.riqi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.leixingVal.mas_bottom).offset(15);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.riqiVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.riqi.mas_bottom).offset(5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.faren mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.riqiVal.mas_bottom).offset(15);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.farenVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.faren.mas_bottom).offset(5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.ziben mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.farenVal.mas_bottom).offset(15);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.zibenVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.ziben.mas_bottom).offset(5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.zibenVal.mas_bottom).offset(20);
        make.height.mas_equalTo(0.5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.diqu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.line1.mas_bottom).offset(20);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.diquVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.diqu.mas_bottom).offset(5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.dizhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.diquVal.mas_bottom).offset(15);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    self.dizhiVal.numberOfLines=0;
    [self.dizhiVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.dizhi.mas_bottom).offset(5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.jieshao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.dizhiVal.mas_bottom).offset(15);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    self.jieshaoVal.numberOfLines=0;
    [self.jieshaoVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.jieshao.mas_bottom).offset(5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.jieshaoVal.mas_bottom).offset(20);
        make.height.mas_equalTo(0.5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.contact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.line2.mas_bottom).offset(20);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.contactVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.contact.mas_bottom).offset(5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.mobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.contactVal.mas_bottom).offset(15);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.mobileVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.mobile.mas_bottom).offset(5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.email mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.mobileVal.mas_bottom).offset(15);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.emailVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.email.mas_bottom).offset(5);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.website mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.emailVal.mas_bottom).offset(15);
        make.right.equalTo(self.content.mas_right).offset(-20);
    }];
    [self.websiteVal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xinyong.mas_left);
        make.top.equalTo(self.website.mas_bottom).offset(5);
        make.right.equalTo(self.content.mas_right).offset(-20);
        make.bottom.equalTo(self.content.mas_bottom).offset(-18);
    }];
}





-(UIView *)content{
    if(!_content){
        _content=[[UIView alloc] init];
        [self.contentView addSubview:_content];
        _content.backgroundColor=rgba(248,248,248,1);
        _content.layer.borderColor=rgba(239,239,239,1).CGColor;
        _content.layer.cornerRadius=10;
        _content.layer.borderWidth=0.5;
    }
    return _content;
}
-(UILabel *)xinyong{
    if(!_xinyong){
        _xinyong=[[UILabel alloc] init];
        [self.content addSubview:_xinyong];
    }
    return _xinyong;
}
-(YYCopyLabel *)xinyongVal{
    if(!_xinyongVal){
        _xinyongVal=[[YYCopyLabel alloc] init];
        _xinyongVal.textColor=UIColor.mainGrayTextColor;
        [self.content addSubview:_xinyongVal];
        [_xinyongVal setCopyEnabled:YES];
    }
    return _xinyongVal;
}
-(UILabel *)leixing{
    if(!_leixing){
        _leixing=[[UILabel alloc] init];
        [self.content addSubview:_leixing];
    }
    return _leixing;
}
-(YYCopyLabel *)leixingVal{
    if(!_leixingVal){
        _leixingVal=[[YYCopyLabel alloc] init];
        _leixingVal.textColor=UIColor.mainGrayTextColor;
        [self.content addSubview:_leixingVal];
        [_leixingVal setCopyEnabled:YES];
    }
    return _leixingVal;
}
-(UILabel *)riqi{
    if(!_riqi){
        _riqi=[[UILabel alloc] init];
        [self.content addSubview:_riqi];
    }
    return _riqi;
}
-(YYCopyLabel *)riqiVal{
    if(!_riqiVal){
        _riqiVal=[[YYCopyLabel alloc] init];
        _riqiVal.textColor=UIColor.mainGrayTextColor;
        [self.content addSubview:_riqiVal];
        [_riqiVal setCopyEnabled:YES];
    }
    return _riqiVal;
}
-(UILabel *)faren{
    if(!_faren){
        _faren=[[UILabel alloc] init];
        [self.content addSubview:_faren];
    }
    return _faren;
}
-(YYCopyLabel *)farenVal{
    if(!_farenVal){
        _farenVal=[[YYCopyLabel alloc] init];
        _farenVal.textColor=UIColor.mainGrayTextColor;
        [self.content addSubview:_farenVal];
        [_farenVal setCopyEnabled:YES];
    }
    return _farenVal;
}
-(UILabel *)ziben{
    if(!_ziben){
        _ziben=[[UILabel alloc] init];
        [self.content addSubview:_ziben];
    }
    return _ziben;
}
-(YYCopyLabel *)zibenVal{
    if(!_zibenVal){
        _zibenVal=[[YYCopyLabel alloc] init];
        _zibenVal.textColor=UIColor.mainGrayTextColor;
        [self.content addSubview:_zibenVal];
        [_zibenVal setCopyEnabled:YES];
    }
    return _zibenVal;
}
-(UILabel *)diqu{
    if(!_diqu){
        _diqu=[[UILabel alloc] init];
        [self.content addSubview:_diqu];
    }
    return _diqu;
}
-(YYCopyLabel *)diquVal{
    if(!_diquVal){
        _diquVal=[[YYCopyLabel alloc] init];
        _diquVal.textColor=UIColor.mainGrayTextColor;
        [self.content addSubview:_diquVal];
        [_diquVal setCopyEnabled:YES];
    }
    return _diquVal;
}
-(UILabel *)dizhi{
    if(!_dizhi){
        _dizhi=[[UILabel alloc] init];
        [self.content addSubview:_dizhi];
    }
    return _dizhi;
}
-(YYCopyLabel *)dizhiVal{
    if(!_dizhiVal){
        _dizhiVal=[[YYCopyLabel alloc] init];
        _dizhiVal.textColor=UIColor.mainGrayTextColor;
        [self.content addSubview:_dizhiVal];
        [_dizhiVal setCopyEnabled:YES];
    }
    return _dizhiVal;
}
-(UILabel *)jieshao{
    if(!_jieshao){
        _jieshao=[[UILabel alloc] init];
        [self.content addSubview:_jieshao];
    }
    return _jieshao;
}
-(YYCopyLabel *)jieshaoVal{
    if(!_jieshaoVal){
        _jieshaoVal=[[YYCopyLabel alloc] init];
        _jieshaoVal.textColor=UIColor.mainGrayTextColor;
        [self.content addSubview:_jieshaoVal];
        [_jieshaoVal setCopyEnabled:YES];
    }
    return _jieshaoVal;
}
-(UILabel *)contact{
    if(!_contact){
        _contact=[[UILabel alloc] init];
        [self.content addSubview:_contact];
    }
    return _contact;
}
-(YYCopyLabel *)contactVal{
    if(!_contactVal){
        _contactVal=[[YYCopyLabel alloc] init];
        _contactVal.textColor=UIColor.mainGrayTextColor;
        [self.content addSubview:_contactVal];
        [_contactVal setCopyEnabled:YES];
    }
    return _contactVal;
}
-(UILabel *)mobile{
    if(!_mobile){
        _mobile=[[UILabel alloc] init];
        [self.content addSubview:_mobile];
    }
    return _mobile;
}
-(YYCopyLabel *)mobileVal{
    if(!_mobileVal){
        _mobileVal=[[YYCopyLabel alloc] init];
        _mobileVal.textColor=UIColor.mainGrayTextColor;
        [self.content addSubview:_mobileVal];
        [_mobileVal setCopyEnabled:YES];
    }
    return _mobileVal;
}
-(UILabel *)email{
    if(!_email){
        _email=[[UILabel alloc] init];
        [self.content addSubview:_email];
    }
    return _email;
}
-(YYCopyLabel *)emailVal{
    if(!_emailVal){
        _emailVal=[[YYCopyLabel alloc] init];
        _emailVal.textColor=UIColor.mainGrayTextColor;
        [self.content addSubview:_emailVal];
        [_emailVal setCopyEnabled:YES];
    }
    return _emailVal;
}
-(UILabel *)website{
    if(!_website){
        _website=[[UILabel alloc] init];
        [self.content addSubview:_website];
    }
    return _website;
}
-(YYCopyLabel *)websiteVal{
    if(!_websiteVal){
        _websiteVal=[[YYCopyLabel alloc] init];
        _websiteVal.textColor=UIColor.mainGrayTextColor;
        [self.content addSubview:_websiteVal];
        [_websiteVal setCopyEnabled:YES];
    }
    return _websiteVal;
}
-(UIView *)line1{
    if(!_line1){
       _line1= [[UIView alloc] init];
        _line1.backgroundColor=rgba(239,239,239,1);
        [self.content addSubview:_line1];
    }
    return _line1;
}
-(UIView *)line2{
    if(!_line2){
        _line2= [[UIView alloc] init];
        _line2.backgroundColor=rgba(239,239,239,1);
        [self.content addSubview:_line2];
    }
    return _line2;
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
