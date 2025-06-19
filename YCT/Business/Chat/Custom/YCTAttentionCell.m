//
//  YCTAttentionCell.m
//  YCT
//
//  Created by 木木木 on 2021/12/21.
//

#import "YCTAttentionCell.h"

@interface YCTAttentionCell ()

@property (nonatomic, strong) UIImageView *bubbleView;

@end

@implementation YCTAttentionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.bubbleView.userInteractionEnabled = YES;
        self.bubbleView.image = [[UIImage imageNamed:@"chat_bubble_in"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
        [self.container addSubview:self.bubbleView];
        self.bubbleView.mm_fill();
        self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.attentionNameLabel = [[UILabel alloc] init];
        self.attentionNameLabel.font = [UIFont PingFangSCBold:16];
        self.attentionNameLabel.textColor = UIColor.mainTextColor;
        [self.bubbleView addSubview:self.attentionNameLabel];
        
        self.avatarImageView = [[UIImageView alloc] init];
        self.avatarImageView.layer.cornerRadius = 18;
        self.avatarImageView.layer.masksToBounds = YES;
        [self.bubbleView addSubview:self.avatarImageView];
        
        self.attentionButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.attentionButton.backgroundColor = UIColor.mainThemeColor;
        self.attentionButton.layer.cornerRadius = 15;
        self.attentionButton.layer.masksToBounds = YES;
        self.attentionButton.titleLabel.font = [UIFont PingFangSCMedium:14];
        [self.attentionButton addTarget:self action:@selector(attentionClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.attentionButton setTitle:YCTLocalizedTableString(@"chat.cell.follow", @"Chat") forState:(UIControlStateNormal)];
        [self.attentionButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        [self.bubbleView addSubview:self.attentionButton];
    }
    return self;
}

- (void)fillWithData:(YCTAttentionCellData *)data {
    [super fillWithData:data];
    self.customData = data;
    self.attentionNameLabel.text = data.followUserName;
    [self.avatarImageView loadImageGraduallyWithURL:[NSURL URLWithString:data.followAvatarUrl] placeholderImageName:kDefaultAvatarImageName];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.avatarImageView.mm_top(8).mm_left(10).mm_width(36).mm_height(36);
    self.attentionButton.mm_width(60).mm_height(30).mm_right(10).mm_top(10);
    self.attentionNameLabel.mm_width(self.customData.contentSize.width - 130).mm_height(40).mm_left(self.avatarImageView.mm_maxX + 6).mm__centerY(self.bubbleView.mm_centerY);
}

- (void)attentionClick:(UIButton *)sender {
    [self responseChainWithEventName:k_even_followCell_click userInfo:@{@"userId": self.customData.followUserId ?: @""}];
}

@end
