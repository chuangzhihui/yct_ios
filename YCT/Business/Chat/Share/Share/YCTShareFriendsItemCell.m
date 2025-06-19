//
//  YCTShareFriendsItemCell.m
//  YCT
//
//  Created by 木木木 on 2021/12/20.
//

#import "YCTShareFriendsItemCell.h"

@implementation YCTShareFriendsItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.avatarImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.layer.cornerRadius = 18;
        view.layer.masksToBounds = YES;
        view;
    });
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(14);
        make.width.height.mas_equalTo(36);
    }];
    
    self.shareButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addTarget:self action:@selector(shareClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [view setTitle:YCTLocalizedString(@"share.share") forState:(UIControlStateNormal)];
        [view setTitle:YCTLocalizedString(@"share.shared") forState:(UIControlStateSelected)];
        [view setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        [view setBackgroundColor:UIColor.mainThemeColor];
        view.titleLabel.font = [UIFont PingFangSCBold:14];
        view.layer.cornerRadius = 15;
        view;
    });
    [self.contentView addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(18);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    
    self.nameLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.textColor = UIColor.mainTextColor;
        view.font = [UIFont PingFangSCMedium:15];
        view;
    });
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.avatarImageView.mas_centerY);
        make.right.mas_equalTo(self.shareButton.mas_right).mas_offset(-10);
    }];
}

- (void)shareClick:(id)sender {
    NSLog(@"%s", __FUNCTION__);
}

@end
