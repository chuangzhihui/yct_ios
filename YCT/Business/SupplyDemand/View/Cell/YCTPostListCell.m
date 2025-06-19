//
//  YCTPostListCell.m
//  YCT
//
//  Created by 木木木 on 2021/12/9.
//

#import "YCTPostListCell.h"
#import "YCTPostListTagsView.h"

@interface YCTPostListCell ()

@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *releaseInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (weak, nonatomic) IBOutlet YCTPostListTagsView *tagsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesViewHeight;

@property (weak, nonatomic) IBOutlet UIView *contentLabelView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *siteView;
@property (weak, nonatomic) IBOutlet UIView *siteContainerView;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;

@end

@implementation YCTPostListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bottomView.backgroundColor = UIColor.tableBackgroundColor;
    
    self.userIconImageView.layer.cornerRadius = 20;
    self.userIconImageView.clipsToBounds = YES;
    
    self.userNameLabel.textColor = UIColor.mainTextColor;
    self.userNameLabel.font = [UIFont PingFangSCBold:14];
    
    self.goodstypeLabel.textColor = UIColor.mainTextColor;
    self.goodstypeLabel.font = [UIFont PingFangSCMedium:16];
    
    self.goodstypeTitleLabel.textColor = UIColor.mainTextColor;
    self.goodstypeTitleLabel.font = [UIFont PingFangSCMedium:14];
    self.goodstypeTitleLabel.text = YCTLocalizedTableString(@"post.productType", @"Post");
    
    self.followButton.backgroundColor = UIColor.mainThemeColor;
    self.followButton.titleLabel.font = [UIFont PingFangSCBold:14];
    [self.followButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    self.followButton.layer.cornerRadius = 15;
    [self.followButton setTitle:YCTLocalizedTableString(@"chat.cell.follow", @"Chat") forState:(UIControlStateNormal)];
    [self.followButton setTitle:YCTLocalizedTableString(@"chat.cell.followed", @"Chat") forState:(UIControlStateSelected)];
    
    self.contentLabel.textColor = UIColor.mainTextColor;
    self.contentLabel.font = [UIFont PingFangSCBold:16];
    
    self.siteLabel.textColor = UIColor.mainGrayTextColor;
    self.siteLabel.font = [UIFont PingFangSCMedium:12];
    self.siteContainerView.layer.borderColor = UIColor.separatorColor.CGColor;
    self.siteContainerView.layer.borderWidth = 1;
    self.siteContainerView.layer.cornerRadius = 13;
    
    @weakify(self);
    self.imagesView.imagViewClickBlock = ^(NSUInteger index) {
        @strongify(self);
        !self.imageClickBlock ? : self.imageClickBlock(self, index);
    };
    
    self.userIconImageView.userInteractionEnabled = YES;
    [self.userIconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        !self.avatarClickBlock ? : self.avatarClickBlock(self.model);
    }]];
}

- (void)updateWithModel:(YCTSupplyDemandItemModel *)model {
    self.model = model;
    
    self.followButton.hidden =
    [YCTUserDataManager sharedInstance].isLogin
    && [[YCTChatUtil unwrappedImID:[YCTUserDataManager sharedInstance].loginModel.IMName] isEqualToString:model.userId]
    ;
    
    @weakify(self);
    [[RACObserve(model, isFollow) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        self.followButton.selected = x.boolValue;
        self.followButton.backgroundColor = x.boolValue ? UIColor.selectedButtonBgColor : UIColor.mainThemeColor;
    }];
    
    [[[self.followButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[YCTUserFollowHelper sharedInstance] handleFollowStateWithUser:model];
    }];
    
    [self.userIconImageView loadImageGraduallyWithURL:[NSURL URLWithString:model.avatar] placeholderImageName:kDefaultAvatarImageName];
    
    self.vipImageView.hidden = !model.isauthentication;
    
    self.userNameLabel.text = model.nickName;
    
    self.releaseInfoLabel.attributedText = model.releaseText;
    
    if (model.tagsLayout) {
        self.tagsView.hidden = NO;
        self.tagsView.tagTextLayout = model.tagsLayout;
        self.tagsViewHeight.constant = model.tagsLayout.textBoundingSize.height;
    } else {
        self.tagsView.hidden = YES;
    }
    
    self.contentLabel.text = model.title;
    self.contentLabelView.hidden = model.title.length == 0;
    
    self.imagesViewHeight.constant = [YCTPostImagesView heightWithTotal:model.imgs.count];
    self.imagesView.hidden = (model.imgs.count == 0);
    [self.imagesView updateWithUrls:model.imgs];
    
    self.goodstypeLabel.text = model.goodstype.length == 0 ? @" " : model.goodstype;
    
    self.siteLabel.text = model.address ?: @"";
}

@end
