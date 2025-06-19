//
//  YCTChatSettingUserCell.m
//  YCT
//
//  Created by 木木木 on 2022/1/3.
//

#import "YCTChatSettingUserCell.h"

@implementation YCTCharSettingUserCellData
@end

@interface YCTChatSettingUserCell ()
@property YCTCharSettingUserCellData *customData;
@end

@implementation YCTChatSettingUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarView = [[UIImageView alloc] init];
        self.avatarView.mj_size = CGSizeMake(50, 50);
        self.avatarView.mj_x = 15;
        self.avatarView.mj_y = 25;
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.layer.cornerRadius = self.avatarView.frame.size.height / 2;
        [self.contentView addSubview:self.avatarView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont PingFangSCBold:14];
        self.titleLabel.textColor = UIColor.mainTextColor;
        [self.contentView addSubview:self.titleLabel];
        
        self.followButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.followButton.mj_size = CGSizeMake(80, 30);
        self.followButton.layer.cornerRadius = 15;
        self.followButton.layer.masksToBounds = YES;
        self.followButton.titleLabel.font = [UIFont PingFangSCBold:16];
        self.followButton.backgroundColor = UIColor.mainThemeColor;
        [self.followButton addTarget:self action:@selector(followClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.followButton setTitle:YCTLocalizedTableString(@"chat.cell.follow", @"Chat") forState:(UIControlStateNormal)];
        [self.followButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        [self.followButton setTitle:YCTLocalizedTableString(@"chat.cell.followed", @"Chat") forState:(UIControlStateSelected)];
        [self.followButton setTitleColor:UIColor.whiteColor forState:(UIControlStateSelected)];
        self.followButton.hidden = YES;
        [self.contentView addSubview:self.followButton];
        
        [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(75);
            make.centerY.mas_equalTo(0);
        }];
        
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)fillWithData:(YCTCharSettingUserCellData *)data {
    self.customData = data;
    [self.avatarView loadImageGraduallyWithURL:data.avatarUrl placeholderImageName:kDefaultAvatarImageName];
    self.titleLabel.text = data.name;
}

- (void)followClick:(UIButton *)sender {
    if (self.customData.clickSelector && self.customData.clickTarget) {
        if ([self.customData.clickTarget respondsToSelector:self.customData.clickSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.customData.clickTarget performSelector:self.customData.clickSelector withObject:self];
#pragma clang diagnostic pop
        }
    }
}

@end
