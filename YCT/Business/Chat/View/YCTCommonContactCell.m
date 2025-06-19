//
//  YCTCommonContactCell.m
//  YCT
//
//  Created by 木木木 on 2021/12/22.
//

#import "YCTCommonContactCell.h"
#import "TUIDefine.h"
#import "YCTChatUIDefine.h"
#import "UIGestureRecognizer+Common.h"

@interface YCTCommonContactCell()
@property UIView *onlineView;
@property YCTChatFriendModel *contactData;
@end

@implementation YCTCommonContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarView = [[UIImageView alloc] initWithImage:DefaultAvatarImage];
        [self.contentView addSubview:self.avatarView];
        self.avatarView.mm_width(YCTConversationCell_ImageSize).mm_height(YCTConversationCell_ImageSize).mm_left(YCTConversationCell_Margin + 3).mm_top(YCTConversationCell_ImageTop);
    
        if ([TUIConfig defaultConfig].avatarType == TAvatarTypeRounded) {
            self.avatarView.layer.masksToBounds = YES;
            self.avatarView.layer.cornerRadius = self.avatarView.frame.size.height / 2;
        } else if ([TUIConfig defaultConfig].avatarType == TAvatarTypeRadiusCorner) {
            self.avatarView.layer.masksToBounds = YES;
            self.avatarView.layer.cornerRadius = [TUIConfig defaultConfig].avatarCornerRadius;
        }
        self.avatarView.userInteractionEnabled = YES;
        [self.avatarView addGestureRecognizer:({
            @weakify(self);
            [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                @strongify(self);
                !self.clickAvatarBlock ?: self.clickAvatarBlock(self.contactData);
            }];
        })];
        
        self.onlineView = [[UIView alloc] init];
        self.onlineView.backgroundColor = UIColorFromRGB(0x21E26E);
        self.onlineView.layer.cornerRadius = 9;
        self.onlineView.layer.borderWidth = 2;
        self.onlineView.layer.borderColor = UIColor.whiteColor.CGColor;
        [self.contentView addSubview:self.onlineView];
        self.onlineView.mm_width(18).mm_height(18).mm_left(self.avatarView.mm_x + 37).mm_top(self.avatarView.mm_y + 37);
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont PingFangSCBold:16];
        self.titleLabel.textColor = UIColor.mainTextColor;
        [self.contentView addSubview:self.titleLabel];
        
        self.subLabel = [[UILabel alloc] init];
        self.subLabel.font = [UIFont PingFangSCMedium:14];
        self.subLabel.textColor = UIColor.mainGrayTextColor;
        [self.contentView addSubview:self.subLabel];
        
        self.messageButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.messageButton.backgroundColor = UIColor.mainThemeColor;
        self.messageButton.layer.cornerRadius = 17;
        self.messageButton.layer.masksToBounds = YES;
        self.messageButton.titleLabel.font = [UIFont PingFangSCBold:14];
        [self.messageButton setTitle:YCTLocalizedTableString(@"chat.main.message", @"Chat") forState:(UIControlStateNormal)];
        [self.messageButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        [self.messageButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:self.messageButton];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)fillWithData:(YCTChatFriendModel *)contactData {
    self.contactData = contactData;
    
    self.onlineView.hidden = !contactData.isOnline;
    self.titleLabel.text = contactData.nickName;
    self.subLabel.text = contactData.subText;
    [self.avatarView loadImageGraduallyWithURL:[NSURL URLWithString:contactData.avatar] placeholderImageName:kDefaultAvatarImageName];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.messageButton.mm_width(70).mm_height(34).mm_right(15).mm_top(29);
    self.titleLabel.mm_sizeToFitThan(0, 30).mm_top(YCTConversationCell_Margin_Text + 5).mm_left(self.avatarView.mm_maxX + YCTConversationCell_Margin).mm_flexToRight(self.messageButton.mm_r + self.messageButton.mm_w + YCTConversationCell_Margin_Text);
    self.subLabel.mm_sizeToFitThan(0, 25).mm_left(self.titleLabel.mm_x).mm_flexToRight(self.messageButton.mm_r + self.messageButton.mm_w + YCTConversationCell_Margin_Text).mm_bottom(15);
}

- (void)messageButtonClick:(id)sender {
    if (self.clickMessageBlock) {
        self.clickMessageBlock(self.contactData);
    }
}

@end
