//
//  SetBannerTableViewCell.m
//  YCT
//
//  Created by 张大爷的 on 2022/7/11.
//

#import "SetBannerTableViewCell.h"

@implementation SetBannerTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
    }
    return self;
}
-(void)setUpUi{
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.top.equalTo(self.contentView.mas_top);
        make.size.sizeOffset(CGSizeMake((WIDTH-30), self.height));
    }];
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(50, 24));
        make.top.equalTo(self.img.mas_top).offset(10);
        make.right.equalTo(self.setTop.mas_left).offset(-20);
    }];
    [self.setTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(50, 24));
        make.top.equalTo(self.img.mas_top).offset(10);
        make.right.equalTo(self.img.mas_right).offset(-10);
    }];
}
-(UIImageView *)img{
    if(!_img){
        _img=[[UIImageView alloc] init];
        [self.contentView addSubview:_img];
        _img.layer.masksToBounds=YES;
        _img.layer.cornerRadius=5;
    }
    return _img;
}
-(UIButton *)delBtn{
    if(!_delBtn){
        _delBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setTitle:YCTLocalizedTableString(@"mine.becomeCompany.remove", @"Mine") forState:UIControlStateNormal];
        [self.contentView addSubview:_delBtn];
        _delBtn.layer.masksToBounds=YES;
        _delBtn.layer.cornerRadius=3;
        _delBtn.backgroundColor=rgba(0, 0, 0, 0.2);
        [_delBtn setTitleColor:rgba(255,255,255,1) forState:UIControlStateNormal];
        _delBtn.titleLabel.font=fontSize(12);
    }
    return _delBtn;
}
-(UIButton *)setTop{
    if(!_setTop){
        _setTop=[UIButton buttonWithType:UIButtonTypeCustom];
        [_setTop setTitle:YCTLocalizedTableString(@"mine.becomeCompany.setTop", @"Mine") forState:UIControlStateNormal];
        [self.contentView addSubview:_setTop];
        _setTop.layer.masksToBounds=YES;
        _setTop.layer.cornerRadius=3;
        _setTop.backgroundColor=rgba(0, 0, 0, 0.2);
        [_setTop setTitleColor:rgba(255,255,255,1) forState:UIControlStateNormal];
        _setTop.titleLabel.font=fontSize(12);
    }
    return _setTop;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setImgSize:(NSURL *)imgUrl{
    [self.img sd_setImageWithURL:imgUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGFloat height=(WIDTH-30)*(image.size.height/image.size.width);
//        [self.img mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).offset(15);
//            make.right.equalTo(self.contentView.mas_right).offset(-15);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
//            make.top.equalTo(self.contentView.mas_top);
//            make.size.sizeOffset(CGSizeMake((WIDTH-30), height));
//        }];
        [self.img mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake((WIDTH-30), height));
        }];
       
    }];
}
@end
