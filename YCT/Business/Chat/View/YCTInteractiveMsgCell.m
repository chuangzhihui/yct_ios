//
//  YCTInteractiveMsgCell.m
//  YCT
//
//  Created by 木木木 on 2022/1/3.
//

#import "YCTInteractiveMsgCell.h"

@implementation YCTInteractiveMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    self.avatarImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.cornerRadius = 20;
        view.layer.masksToBounds = YES;
        view;
    });
    [self.contentView addSubview:self.avatarImageView];
    
    
    self.thumbImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view;
    });
    [self.contentView addSubview:self.thumbImageView];
    
    self.nameLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont PingFangSCMedium:14];
        view.textColor = UIColor.mainTextColor;
        view;
    });
    [self.contentView addSubview:self.nameLabel];
    
    self.vipImageView = ({
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_vip"]];
        view;
    });
    [self.contentView addSubview:self.vipImageView];
    
    self.identityLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.textAlignment = NSTextAlignmentCenter;
        view.font = [UIFont PingFangSCMedium:10];
        view.textColor = UIColor.mainTextColor;
        view.layer.cornerRadius = 7;
        view.layer.masksToBounds = YES;
        view.backgroundColor = UIColor.tableBackgroundColor;
        view;
    });
    [self.contentView addSubview:self.identityLabel];
    
    self.timeLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont PingFangSCMedium:12];
        view.textColor = UIColor.subTextColor;
        view;
    });
    [self.contentView addSubview:self.timeLabel];
    
    self.contentLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.font = [UIFont PingFangSCMedium:15];
        view.textColor = UIColor.mainTextColor;
        view.numberOfLines = 0;
        view;
    });
    [self.contentView addSubview:self.contentLabel];
}

- (void)setModel:(YCTInteractionMsgModel *)model {
    _model = model;
    
    self.avatarImageView.frame = model.avatarFrame;
    self.nameLabel.frame = model.nameFrame;
    self.vipImageView.frame = model.vipFrame;
    self.identityLabel.frame = model.identityFrame;
    self.contentLabel.frame = model.contentFrame;
    self.timeLabel.frame = model.timeFrame;
    self.thumbImageView.frame = model.thumbFrame;
    self.vipImageView.hidden = !model.isauthentication;
    
    [self.avatarImageView loadImageGraduallyWithURL:[NSURL URLWithString:model.avatar] placeholderImageName:kDefaultAvatarImageName];
    [self.thumbImageView loadImageGraduallyWithURL:[NSURL URLWithString:model.thumbUrl] placeholderImageName:kDefaultAvatarImageName];
    
    self.nameLabel.text = model.nickName;
    self.identityLabel.text = model.identityStr;
    self.contentLabel.text = model.msg;
    self.timeLabel.text = model.timeStr;
}

@end
