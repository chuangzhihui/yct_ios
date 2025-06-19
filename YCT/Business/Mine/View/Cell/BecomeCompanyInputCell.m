//
//  BecomeCompanyInputCell.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/10.
//

#import "BecomeCompanyInputCell.h"

@implementation BecomeCompanyInputCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(NSInteger)type{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initUI:type];
    }
    return self;
}
-(void)initUI:(NSInteger)type{
    [self.start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(30);
        make.centerY.equalTo(self.title.mas_centerY);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(25);
        make.left.equalTo(self.start.mas_right);
    }];
    if(type==1){
        [self.input mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(30);
            make.top.equalTo(self.title.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-6);
            make.right.equalTo(self.contentView.mas_right).offset(-30);
            make.height.mas_equalTo(30);
        }];
    }
    if(type==2){
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake((WIDTH-60), 100));
            make.left.equalTo(self.contentView.mas_left).offset(30);
            make.top.equalTo(self.title.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-6);
        }];
        [self.textViewTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.textView.mas_right).offset(-5);
            make.bottom.equalTo(self.textView.mas_bottom).offset(-5);
        }];
    }
    if(type==3){
        [self.chooseTxt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.left.equalTo(self.contentView.mas_left).offset(30);
            make.top.equalTo(self.title.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-6);
            make.right.equalTo(self.contentView.mas_right).offset(-50);
        }];
        [self.jt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(14, 14));
            make.centerY.equalTo(self.chooseTxt.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-30);
        }];
    }
    if(type==6){
        [self.chooseTxt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.left.equalTo(self.contentView.mas_left).offset(30);
            make.top.equalTo(self.title.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-6);
            make.right.equalTo(self.contentView.mas_right).offset(-150);
        }];
        [self.jt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(14, 14));
            make.centerY.equalTo(self.chooseTxt.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-30);
        }];
        [self.chooseTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.chooseTxt.mas_centerY);
            make.right.equalTo(self.jt.mas_left).offset(-10);
        }];
    }
    if(type==4){
        [self.uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake((WIDTH-60), 120));
            make.left.equalTo(self.contentView.mas_left).offset(30);
            make.top.equalTo(self.title.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-6);
        }];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.uploadView.mas_centerX);
            make.centerY.equalTo(self.uploadView.mas_centerY).offset(-9);
            make.size.sizeOffset(CGSizeMake(24, 24));
        }];
        [self.uploadTxt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.uploadView.mas_centerX);
            make.top.equalTo(self.icon.mas_bottom).offset(5);
        }];
        
        [self.uploadImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake((WIDTH-60), 120));
            make.left.equalTo(self.contentView.mas_left).offset(30);
            make.top.equalTo(self.title.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-6);
        }];
        
        [self.removeImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(16, 16));
            make.right.equalTo(self.uploadImg.mas_right);
            make.top.equalTo(self.uploadImg.mas_top);
        }];
        self.uploadImg.hidden=YES;
    }
    if(type==5){
        [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(30);
            make.size.sizeOffset(CGSizeMake((WIDTH-90)/3, 30));
            make.top.equalTo(self.title.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-6);
        }];
        [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btn1.mas_right).offset(15);
            make.size.sizeOffset(CGSizeMake((WIDTH-90)/3, 30));
            make.centerY.equalTo(self.btn1);
        }];
        [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btn2.mas_right).offset(15);
            make.size.sizeOffset(CGSizeMake((WIDTH-90)/3, 30));
            make.centerY.equalTo(self.btn1);
        }];
    }
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(30);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}
-(UILabel *)start{
    if(!_start){
        _start=[[UILabel alloc] init];
        _start.text=@"*";
        _start.font=fontSize(14);
        _start.textColor=rgba(254,43,84,1);
        [self.contentView addSubview:_start];
    }
    return _start;
}
-(UILabel *)title{
    if(!_title){
        _title=[[UILabel alloc] init];
        _title.font=fontSize(14);
        _title.textColor=rgba(51,51,51,1);
        [self.contentView addSubview:_title];
    }
    return _title;
}
-(UITextField *)input{
    if(!_input){
        _input=[[UITextField alloc] init];
        NSAttributedString *attrString = [
            [NSMutableAttributedString alloc] initWithString:@""
            attributes: @{
              NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16],
              NSForegroundColorAttributeName: [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1.00],
          }];
        _input.attributedPlaceholder=attrString;
        _input.textColor=rgba(51, 51, 51, 1);
        [self.contentView addSubview:_input];
    }
    return _input;
}
-(UIView *)line{
    if(!_line){
        _line=[[UIView alloc] init];
        _line.backgroundColor=rgba(239,239,239,1);
        [self.contentView addSubview:_line];
    }
    return _line;
}

-(UITextView *)textView{
    if(!_textView){
        _textView=[[UITextView alloc] init];
        [self.contentView addSubview:_textView];
        _textView.backgroundColor=rgba(239, 239, 239, 1);
        _textView.layer.masksToBounds=YES;
        _textView.layer.cornerRadius=3;
      
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 25, 10);
        _textView.font=fontSize(16);
        [_textView addSubview:self.textViewPlaceholder];
        [_textView setValue:self.textViewPlaceholder forKey:@"_placeholderLabel"];
        _textView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    }
    return _textView;
}
-(UILabel *)textViewTips{
    if(!_textViewTips){
        _textViewTips=[[UILabel alloc] init];
        
        _textViewTips.font=fontSize(12);
        _textViewTips.textColor=rgba(193,193,193,1);
        [self.contentView addSubview:_textViewTips];
    }
    return _textViewTips;
}
-(UILabel *)textViewPlaceholder{
    if(!_textViewPlaceholder){
        _textViewPlaceholder=[[UILabel alloc] init];
        
        _textViewPlaceholder.numberOfLines=0;
        _textViewPlaceholder.font=fontSize(16);
        _textViewPlaceholder.textColor=rgba(153,153,153,1);
        [_textViewPlaceholder sizeToFit];
        [self.textView addSubview:_textViewPlaceholder];
    }
    return _textViewPlaceholder;
}
-(UILabel *)chooseTxt{
    if(!_chooseTxt){
        _chooseTxt=[[UILabel alloc] init];
        [self.contentView addSubview:_chooseTxt];
        _chooseTxt.textColor=rgba(193,193,193,1);
        _chooseTxt.font=fontSize(16);
    }
    return _chooseTxt;
}
-(UILabel *)chooseTips{
    if(!_chooseTips){
        _chooseTips=[[UILabel alloc] init];
        [self.contentView addSubview:_chooseTips];
        _chooseTips.textColor=rgba(51, 51, 51, 1);
        _chooseTips.font=fontSize(16);
    }
    return _chooseTips;
}
-(UIImageView *)jt{
    if(!_jt){
        _jt=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"publish_right_arrow"]];
        [self.contentView addSubview:_jt];
    }
    return _jt;
}
-(UIImageView *)uploadImg{
    if(!_uploadImg){
        _uploadImg=[[UIImageView alloc] init];
        [self.contentView addSubview:_uploadImg];
    }
    return _uploadImg;
}
-(UIButton *)removeImgBtn{
    if(!_removeImgBtn){
        _removeImgBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_removeImgBtn setImage:[UIImage imageNamed:@"post_addImage_delete"] forState:UIControlStateNormal];
        [self.uploadImg addSubview:_removeImgBtn];
    }
    return _removeImgBtn;
}
-(UIView *)uploadView{
    if(!_uploadView){
        _uploadView=[[UIView alloc] init];
        _uploadView.backgroundColor=rgba(239,239,239,1);
        [self.contentView addSubview:_uploadView];
    }
    return _uploadView;
}

-(UIImageView *)icon{
    if(!_icon){
        _icon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"post_addImage"]];
        [self.uploadView addSubview:_icon];
    }
    return _icon;
}
-(UILabel *)uploadTxt{
    if(!_uploadTxt){
        _uploadTxt=[[UILabel alloc] init];
        _uploadTxt.textColor=rgba(153,153,153,1);
        _uploadTxt.font=fontSize(12);
        _uploadTxt.text=YCTLocalizedTableString(@"mine.becomeCompany.img", @"Mine");
        [self.uploadView addSubview:_uploadTxt];
    }
    return _uploadTxt;
}

-(GoodsBtn *)btn1{
    if(!_btn1){
        _btn1=[[GoodsBtn alloc] init];
        _btn1.title.text=YCTLocalizedTableString(@"mine.becomeCompany.select", @"Mine");
        [self.contentView addSubview:_btn1];
    }
    return _btn1;
}
-(GoodsBtn *)btn2{
    if(!_btn2){
        _btn2=[[GoodsBtn alloc] init];
        _btn2.title.text=YCTLocalizedTableString(@"mine.becomeCompany.select", @"Mine");
        [self.contentView addSubview:_btn2];
    }
    return _btn2;
}
-(GoodsBtn *)btn3{
    if(!_btn3){
        _btn3=[[GoodsBtn alloc] init];
        _btn3.title.text=YCTLocalizedTableString(@"mine.becomeCompany.select", @"Mine");
        [self.contentView addSubview:_btn3];
    }
    return _btn3;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.textViewTips){
        self.textViewTips.text=[NSString stringWithFormat:@"%lu/%d",(unsigned long)self.textView.text.length,self.maxLength];
    }
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
