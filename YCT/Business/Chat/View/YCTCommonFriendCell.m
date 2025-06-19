//
//  YCTCommonFriendCell.m
//  YCT
//
//  Created by 木木木 on 2021/12/22.
//

#import "YCTCommonFriendCell.h"

@interface YCTCommonFriendCell ()

@end

@implementation YCTCommonFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarView = [[UIImageView alloc] init];
        self.avatarView.mj_size = CGSizeMake(40, 40);
        self.avatarView.mj_x = 15;
        self.avatarView.mj_y = 10;
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.userInteractionEnabled = YES;
        self.avatarView.layer.cornerRadius = self.avatarView.frame.size.height / 2;
        [self.contentView addSubview:self.avatarView];
        
        @weakify(self);
        [self.avatarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            if (self.avatarClickBlock) {
                self.avatarClickBlock();
            }
        }]];
        
        self.vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_vip"]];
        self.vipImageView.hidden = YES;
        [self.contentView addSubview:self.vipImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont PingFangSCBold:14];
        self.titleLabel.textColor = UIColor.mainTextColor;
        [self.contentView addSubview:self.titleLabel];
        
        self.subLabel = [[UILabel alloc] init];
        self.subLabel.font = [UIFont PingFangSCMedium:12];
        self.subLabel.textColor = UIColor.mainGrayTextColor;
        [self.contentView addSubview:self.subLabel];
        
        self.followButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.followButton.mj_size = CGSizeMake(80, 30);
        self.followButton.layer.cornerRadius = 15;
        self.followButton.layer.masksToBounds = YES;
        self.followButton.titleLabel.font = [UIFont PingFangSCBold:14];
        self.followButton.backgroundColor = UIColor.mainThemeColor;
        [self.followButton setTitle:YCTLocalizedTableString(@"chat.cell.follow", @"Chat") forState:(UIControlStateNormal)];
        [self.followButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        [self.followButton setTitle:YCTLocalizedTableString(@"chat.cell.followed", @"Chat") forState:(UIControlStateSelected)];
        [self.followButton setTitleColor:UIColor.whiteColor forState:(UIControlStateSelected)];
        [self.contentView addSubview:self.followButton];
        
        [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(63);
            make.top.mas_equalTo(10);
        }];
        
        [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(self.followButton.mas_left).mas_offset(-10);
            make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(2);
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.width.height.mas_equalTo(16);
        }];
        
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(5);
        }];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setFollowHiddenState:(NSString *)userId {
    if ([YCTUserDataManager sharedInstance].isLogin && [[YCTChatUtil unwrappedImID:[YCTUserDataManager sharedInstance].loginModel.IMName] isEqualToString:userId]) {
        self.followButton.hidden = YES;
    } else {
        self.followButton.hidden = NO;
    }
}

@end
