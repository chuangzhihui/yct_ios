//
//  YCTBecomeCompanyAuditListCell.m
//  YCT
//
//  Created by 林涛 on 2025/4/1.
//

#import "YCTBecomeCompanyAuditListCell.h"

@interface YCTBecomeCompanyAuditListCell ()
@property (nonatomic, strong) UIView *bgVw;
@property (nonatomic, strong) UIView *typeBgVw;
@property (nonatomic, strong) UIImageView *typeImg;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *stateLb;
@property (nonatomic, strong) UIView *lineVw;
@property (nonatomic, strong) UILabel *reasonLb;
@end

@implementation YCTBecomeCompanyAuditListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setViewUI];
    }
    return self;
}

#pragma mark ------ UI ------
- (void)setViewUI {
    [self.contentView addSubview:self.bgVw];
    [self.contentView addSubview:self.typeBgVw];
    [self.typeBgVw addSubview:self.typeImg];
    [self.contentView addSubview:self.nameLb];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.stateLb];
    [self.contentView addSubview:self.lineVw];
    [self.contentView addSubview:self.reasonLb];
    
    [self.bgVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7.5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(_reasonLb.mas_bottom).offset(10);
    }];
    [self.typeBgVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18+7.5);
        make.left.mas_equalTo(_bgVw.mas_left).offset(15);
        make.width.height.mas_equalTo(30);
    }];
    [self.typeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_typeBgVw);
        make.width.height.mas_equalTo(16);
    }];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15+7.5);
        make.left.mas_equalTo(_bgVw.mas_left).offset(55);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-100);
    }];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLb.mas_bottom).offset(5);
        make.left.mas_equalTo(_nameLb);
        make.height.mas_equalTo(15);
    }];
    [self.stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25.5+7.5);
        make.right.mas_equalTo(_bgVw.mas_right).offset(-15);
        make.height.mas_equalTo(14);
    }];
    
    [self.lineVw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLb.mas_bottom).offset(10);
        make.left.mas_equalTo(_bgVw.mas_left).offset(15);
        make.right.mas_equalTo(_bgVw.mas_right).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    [self.reasonLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineVw.mas_bottom).offset(10);
        make.left.mas_equalTo(_lineVw);
        make.right.mas_equalTo(_lineVw);
        make.bottom.mas_equalTo(-(10+7.5));
    }];
    
    [self setShowData];
}

#pragma mark ------ Data ------
- (void)setShowData {
    YCTMineUserInfoModel *userInfoModel=[YCTUserDataManager sharedInstance].userInfoModel;
    _nameLb.text = userInfoModel.companyName;
    _timeLb.text = userInfoModel.process_time;
    if (userInfoModel.status == 0) {
        _stateLb.text = YCTLocalizedTableString(@"mine.audit.wait", @"Mine");
        _stateLb.textColor = UIColorFromRGB(0x032DA9);
        [self setShowReasonTextUI:false text:nil];
    } else if (userInfoModel.status == 1) {
        if ([userInfoModel.reason isEqualToString:@""] ||  userInfoModel.reason == nil) {
            _stateLb.text =  YCTLocalizedTableString(@"mine.audit.pass", @"Mine");
            _stateLb.textColor = UIColorFromRGB(0x032DA9);
            [self setShowReasonTextUI:false text:nil];
        } else {
            _stateLb.text = YCTLocalizedTableString(@"mine.audit.fail", @"Mine");
            _stateLb.textColor = UIColorFromRGB(0xFF1F1F);
            [self setShowReasonTextUI:true text:userInfoModel.reason];
        }
    }
//    else if (userInfoModel.status == 2) {
//        _stateLb.text = @"失败";
//        [self setShowReasonTextUI:true text:userInfoModel.reason];
//    }
}

#pragma mark ------ method ------
- (void)setShowReasonTextUI:(BOOL)isShow text:(nullable NSString *)text {
    if (isShow == false) {
        _reasonLb.text = @"";
        _lineVw.hidden = true;
        [self.lineVw mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_timeLb.mas_bottom).offset(0);
        }];
        [self.reasonLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_lineVw.mas_bottom).offset(0);
        }];
    } else {
        if (text == nil || [text isEqualToString:@""]) {
            _reasonLb.text = @"失败原因：请重新提交信息";
        } else {
            _reasonLb.text = [NSString stringWithFormat:@"失败原因：%@",text];
        }
        _lineVw.hidden = false;
        [self.lineVw mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_timeLb.mas_bottom).offset(10);
        }];
        [self.reasonLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_lineVw.mas_bottom).offset(10);
        }];
    }
}

#pragma mark ------ Getters And Setters ------
- (UIView *)bgVw {
    if (!_bgVw) {
        _bgVw = [[UIView alloc]init];
        _bgVw.backgroundColor = UIColor.whiteColor;
        _bgVw.layer.cornerRadius = 10;
        _bgVw.layer.borderColor = UIColorFromRGB(0xE5E5E5).CGColor;
        _bgVw.layer.borderWidth = 1;
    }
    return _bgVw;
}
- (UIView *)typeBgVw {
    if (!_typeBgVw) {
        _typeBgVw = [[UIView alloc]init];
        _typeBgVw.backgroundColor = UIColorFromRGBA(0x032DA9, 0.1);
        _typeBgVw.layer.cornerRadius = 10;
        _typeBgVw.layer.cornerRadius = 30/2;
    }
    return _typeBgVw;
}
- (UIImageView *)typeImg {
    if (!_typeImg) {
        UIImageView * view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_audit_material"]];
        view.contentMode = UIViewContentModeScaleAspectFill;
        _typeImg = view;
    }
    return _typeImg;
}
- (UILabel *)nameLb {
    if (!_nameLb) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"name";
        label.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightBold)];
        label.textColor = UIColorFromRGB(0x333333);
        _nameLb = label;
    }
    return _nameLb;
}
- (UILabel *)timeLb {
    if (!_timeLb) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"time";
        label.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        label.textColor = UIColorFromRGB(0x999999);
        _timeLb = label;
    }
    return _timeLb;
}
- (UILabel *)stateLb {
    if (!_stateLb) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"state";
        label.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)];
        label.textColor = UIColorFromRGB(0x032DA9);
        _stateLb = label;
    }
    return _stateLb;
}
- (UIView *)lineVw {
    if (!_lineVw) {
        _lineVw = [[UIView alloc]init];
        _lineVw.backgroundColor = UIColorFromRGBA(0xE5E5E5, 0.5);
    }
    return _lineVw;
}
- (UILabel *)reasonLb {
    if (!_reasonLb) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"失败原因：请重新提交信息";
        label.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        label.textColor = UIColorFromRGB(0x333333);
        label.numberOfLines = 0;
        _reasonLb = label;
    }
    return _reasonLb;
}
@end
