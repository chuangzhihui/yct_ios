//
//  YCTMineUserInfoView.m
//  YCT
//
//  Created by 木木木 on 2021/12/12.
//

#import "YCTMineUserInfoView.h"
#import "NSMutableAttributedString+TagList.h"
#import "NSAttributedString+YCTAttachment.h"
#import "JXCategoryTitleView+Customization.h"
#import "YCTVendorFullIntroView.h"

#define kTagPlaceholderStackMiddleSpacing 9
#define kTagPlaceholderStackBottomSpacing 9

#define kTagStackMiddleSpacing 8
#define kTagStackBottomSpacing 8

#define kBriefStackMiddleSpacing 10
#define kBriefStackBottomSpacing 10

#define kTextFont [UIFont PingFangSCMedium:14]

#define kAvatarBorder 4
#define kAvatarSize 100
#define kNameAvatarHeight 100
#define kVipHeight 24
#define kMargin 15
#define kButtonHeight 44

#define kCountBaselineOffset 0
#define kPriority 999

#define kCarouselHeight (ceil((Iphone_Width - kMargin * 2) / (375.0 - kMargin * 2) * 100))

@interface YCTMineUserInfoView ()<JXCategoryViewDelegate>
@property (nonatomic, strong, readwrite) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *baseInfoView;
@property (nonatomic, strong) UIView *avatarNameView;
@property (nonatomic, strong, readwrite) UIImageView *avatarImageView;
@property (nonatomic, strong, readwrite) UILabel *nameLabel;
@property (nonatomic, strong, readwrite) UIImageView *vipImageView;
@property (nonatomic, strong, readwrite) UILabel *vipLabel;
@property (nonatomic, strong, readwrite) UILabel *likeCountLabel;
@property (nonatomic, strong, readwrite) UILabel *attentionCountLabel;
@property (nonatomic, strong, readwrite) UILabel *fansCountLabel;
@property (nonatomic, strong, readwrite) UILabel *likeTitleLabel;
@property (nonatomic, strong, readwrite) UILabel *attentionTitleLabel;
@property (nonatomic, strong, readwrite) UILabel *fansTitleLabel;
@property (nonatomic, strong, readwrite) UILabel *idTitleLabel;
@property (nonatomic, strong, readwrite) UILabel *idValueLabel;
@property (nonatomic, strong, readwrite) UIImageView *idCodeImageView;

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *categoryTitleContainerView;
@property (nonatomic, strong) JXCategoryTitleView *categoryTitleView;

@property (nonatomic, strong, readwrite) YCTMineUserVendorInfoView *vendorInfoView;
@property (nonatomic, strong, readwrite) CompanyBasicInfo *vendorInfoViewNew;
@property (nonatomic, strong) UIStackView *tagsStackView;
@property (nonatomic, strong) UIView *tagsContainerView;
@property (nonatomic, strong) UIButton *tagsButton;
@property (nonatomic, strong) UILabel *tagsPlaceholderLabel;
@property (nonatomic, strong) YYLabel *tagsLabel;
@property (nonatomic, strong) UIView *tagsMiddleSpace;
@property (nonatomic, strong) UIView *tagsBottomSpace;

@property (nonatomic, strong) UIStackView *briefStackView;
@property (nonatomic, strong) UIView *briefContainerView;
@property (nonatomic, strong) UIButton *briefButton;
@property (nonatomic, strong) YYLabel *briefLabel;
@property (nonatomic, strong) UIView *briefMiddleSpace;
@property (nonatomic, strong) UIView *briefBottomSpace;

@property (nonatomic, strong, readwrite) YCTCarouselView *carouselView;

@property (nonatomic, strong) UIView *bottomButtonContainerView;
@property (nonatomic, strong, readwrite) UIButton *leftButton;
@property (nonatomic, strong, readwrite) UIButton *rightButton;

@property (nonatomic, copy) NSArray<NSString *> *tags;
@property (nonatomic, copy) NSString *briefIntroStr;
@property (nonatomic, assign, readwrite) CGFloat contentHeight;
@property (nonatomic, assign) BOOL isOtherPeopleStyle;
@property (nonatomic, assign) BOOL isBusiness;
@property(nonatomic,strong)UILabel * tagsTitleLabel;
@property(nonatomic,strong)UILabel *becomeCompany;
@end

@implementation YCTMineUserInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isOtherPeopleStyle = NO;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    @weakify(self);
    
    self.bgImageView = ({
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            if (self.bgImageClickBlock) {
                self.bgImageClickBlock();
            }
        }]];
        view;
    });
    [self addSubview:self.bgImageView];
    self.bgImageView.frame = CGRectMake(0, 0, Iphone_Width, 210);
    
//    UIView *separator = [UIView new];
//    separator.backgroundColor = UIColor.separatorColor;
//    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.idTitleLabel.mas_bottom).mas_offset(15);
//        make.left.mas_equalTo(kMargin);
//        make.right.mas_equalTo(-kMargin).priority(kPriority);
//        make.height.mas_equalTo(1);
//        make.bottom.mas_equalTo(0);
//    }];
    
    /// 姓名、头像
    [self addSubview:self.avatarNameView];
    [self.avatarNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(110);
        make.right.mas_equalTo(0).priority(kPriority);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(kNameAvatarHeight + kVipHeight);
    }];

    [self.avatarNameView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-kMargin);
        make.width.height.mas_equalTo(kAvatarSize);
    }];
    
    [self.avatarNameView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.bottom.mas_equalTo(-kVipHeight);
    }];
    
    [self.avatarNameView addSubview:self.vipImageView];
    [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.width.height.mas_equalTo(24);
    }];
    
//    self.vipLabel.text = @"美妆优秀博主";
    [self.avatarNameView addSubview:self.vipLabel];
    [self.vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.vipImageView.mas_centerY).mas_offset(2);
        make.left.mas_equalTo(self.vipImageView.mas_right).mas_offset(5);
    }];
    
    /// 获赞、关注、粉丝
    [self addSubview:self.baseInfoView];
    [self.baseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarNameView.mas_bottom);
        make.right.mas_equalTo(0).priority(kPriority);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(95);
    }];
    
    [self.baseInfoView addSubview:self.likeTitleLabel];
    [self.likeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.top.mas_equalTo(10);
    }];
    
    [self.baseInfoView addSubview:self.likeCountLabel];
    [self.likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.mas_equalTo(self.likeTitleLabel.mas_baseline).mas_offset(kCountBaselineOffset);
        make.left.mas_equalTo(self.likeTitleLabel.mas_right).mas_offset(4);
    }];
    
    [self.baseInfoView addSubview:self.attentionTitleLabel];
    [self.attentionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.likeCountLabel.mas_right).mas_offset(30);
        make.centerY.mas_equalTo(self.likeTitleLabel.mas_centerY);
    }];
    
    [self.baseInfoView addSubview:self.attentionCountLabel];
    [self.attentionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.mas_equalTo(self.likeTitleLabel.mas_baseline).mas_offset(kCountBaselineOffset);
        make.left.mas_equalTo(self.attentionTitleLabel.mas_right).mas_offset(4);
    }];
    
    [self.baseInfoView addSubview:self.fansTitleLabel];
    [self.fansTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.attentionCountLabel.mas_right).mas_offset(30);
        make.centerY.mas_equalTo(self.likeTitleLabel.mas_centerY);
    }];
    
    [self.baseInfoView addSubview:self.fansCountLabel];
    [self.fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.mas_equalTo(self.likeTitleLabel.mas_baseline).mas_offset(kCountBaselineOffset);
        make.left.mas_equalTo(self.fansTitleLabel.mas_right).mas_offset(4);
    }];
    
    [self.baseInfoView addSubview:self.idTitleLabel];
    [self.idTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kMargin);
        make.top.mas_equalTo(self.likeCountLabel.mas_bottom).mas_offset(20);
        make.bottom.mas_equalTo(-25);
    }];
    
    [self.baseInfoView addSubview:self.idValueLabel];
    [self.idValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.idTitleLabel.mas_right);
        make.centerY.mas_equalTo(self.idTitleLabel.mas_centerY);
    }];
    
    [self.baseInfoView addSubview:self.idCodeImageView];
    [self.idCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.idValueLabel.mas_right).mas_offset(4);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.idTitleLabel.mas_centerY);
    }];
    
    UIView *cuttingLine = [[UIView alloc] init];
    cuttingLine.backgroundColor = UIColor.separatorColor;
    [self.baseInfoView addSubview:cuttingLine];
    [cuttingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(onePx);
        make.bottom.mas_equalTo(-10);
    }];
    
    /// 基本信息、厂家介绍 CategoryView
    [self.categoryTitleContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20).priority(kPriority);
    }];
    [self.categoryTitleContainerView addSubview:self.categoryTitleView];
    [self.categoryTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    /// 商家基本信息
//    [self.vendorInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(284).priority(kPriority);
//    }];
//    [self.vendorInfoViewNew mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(120).priority(kPriority);
//    }];
   
    /// 标签
    [self.tagsContainerView addSubview:self.tagsButton];
    [self.tagsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(32);
    }];
    self.tagsTitleLabel = [UILabel new];
    self.tagsTitleLabel.text =  YCTLocalizedTableString(@"mine.becomeCompany.companyTags", @"Mine");
    self.tagsTitleLabel.font = [UIFont boldSystemFontOfSize:14];
//    self.tagsTitleLabel.textColor = UIColor.mainTextColor;
//    UIView *lineView=[[UIView alloc] init];
    [self.tagsContainerView addSubview:self.tagsTitleLabel];
    [self.tagsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20).priority(kPriority);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
   
    [self.tagsContainerView addSubview:self.tagsLabel];
    [self.tagsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(10).priority(kPriority);
//        make.width.mas_equalTo(-100).priority(kPriority);
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.tagsMiddleSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kTagStackMiddleSpacing);
    }];
    [self.tagsBottomSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kTagStackBottomSpacing);
    }];
    [self.tagsStackView addArrangedSubview:self.tagsContainerView];
    [self.tagsStackView addArrangedSubview:self.tagsMiddleSpace];
    [self.tagsStackView addArrangedSubview:self.tagsContainerView];
    [self.tagsStackView addArrangedSubview:self.tagsPlaceholderLabel];
    [self.tagsStackView addArrangedSubview:self.tagsBottomSpace];
   
    
    // 普通用户简介
    
//    [self.briefContainerView addSubview:self.briefButton];
//    [self.briefButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.width.mas_equalTo(80);
//        make.height.mas_equalTo(32);
//    }];
//    UILabel *briefTitleLabel = [UILabel new];
//    briefTitleLabel.text = YCTLocalizedTableString(@"mine.userInfo.briefTitle", @"Mine");
//    briefTitleLabel.font = [UIFont PingFangSCMedium:12];
//    briefTitleLabel.textColor = UIColor.mainTextColor;
//    [self.briefContainerView addSubview:briefTitleLabel];
//    [briefTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//    }];
//    [self.briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(10).priority(kPriority);
//    }];
//    [self.briefContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(32).priority(kPriority);
//    }];
//    [self.briefMiddleSpace mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(kBriefStackMiddleSpacing);
//    }];
//    [self.briefBottomSpace mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(kBriefStackBottomSpacing);
//    }];
//    [self.briefStackView addArrangedSubview:self.briefContainerView];
//    [self.briefStackView addArrangedSubview:self.briefMiddleSpace];
//    [self.briefStackView addArrangedSubview:self.briefLabel];
//    [self.briefStackView addArrangedSubview:self.briefBottomSpace];
    
    [self.becomeCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@40);
    }];
    self.becomeCompany.hidden=YES;
    [self.stackView addArrangedSubview:self.becomeCompany];
    /// 商家轮播图
    [self.carouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kCarouselHeight).priority(kPriority);
    }];
    
    /// 底部按钮
    [self.bottomButtonContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kButtonHeight).priority(kPriority);
    }];
    [self.bottomButtonContainerView addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(kButtonHeight);
    }];
    [self.bottomButtonContainerView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.leftButton.mas_right).mas_offset(10);
        make.right.mas_equalTo(0).priority(kPriority);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(kButtonHeight);
    }];
    [self.stackView addArrangedSubview:self.categoryTitleContainerView];
    [self.stackView addArrangedSubview:self.vendorInfoViewNew];
   
    [self.stackView addArrangedSubview:self.vendorInfoView];
    
    [self.stackView addArrangedSubview:self.tagsStackView];
    [self.stackView addArrangedSubview:self.briefStackView];
    
    
    
    [self.stackView addArrangedSubview:self.carouselView];
    [self.stackView addArrangedSubview:self.bottomButtonContainerView];
    
    self.categoryTitleContainerView.hidden = YES;
    self.vendorInfoView.hidden = YES;
    self.tagsStackView.hidden = YES;
    self.briefStackView.hidden = YES;
    self.carouselView.hidden = YES;
//    self.bottomButtonContainerView.hidden = YES;
    
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.baseInfoView.mas_bottom);
        make.right.mas_equalTo(-kMargin).priority(kPriority);
        make.left.mas_equalTo(kMargin);
        make.bottom.mas_equalTo(0).priority(kPriority);;
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Iphone_Width).priority(kPriority);
    }];
    
    [self updateContentHeight];
}

- (void)updateContentHeight {
//    CGFloat contentViewWidth = Iphone_Width;
//    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
//    [self addConstraint:widthFenceConstraint];
    CGSize fittingSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    [self removeConstraint:widthFenceConstraint];
    self.contentHeight = fittingSize.height;
}
-(UILabel *)becomeCompany{
    if(!_becomeCompany){
        _becomeCompany=[[UILabel alloc] init];
        _becomeCompany.font=[UIFont boldSystemFontOfSize:18];
        _becomeCompany.textColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.00];
        _becomeCompany.text=YCTLocalizedTableString(@"mine.userInfo.becomeCompany", @"Mine");
    }
    return _becomeCompany;
}
#pragma mark - Public

- (void)setOtherPeopleStyle {
    self.isOtherPeopleStyle = YES;
}

- (void)setUserTags:(NSString *)userTags {
    YCTMineUserInfoModel* userInfoModel= [YCTUserDataManager sharedInstance].userInfoModel;
    NSLog(@"这里？");
    if(userInfoModel.userType==YCTMineUserTypeNormal && !self.isOtherPeopleStyle){
        NSLog(@"这里222？");
        [self.tagsContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(32).priority(kPriority);
        }];
        //普通用户
        self.tagsStackView.hidden =YES;
        self.tagsButton.hidden =YES;
        self.becomeCompany.hidden=NO;
        return;
    }
    if (userTags.length == 0) {
        self.tags = @[];
    } else {
        self.tags = [userTags componentsSeparatedByString:@","];
        
    }
    
    self.tagsStackView.hidden = (self.tags.count == 0 && self.isOtherPeopleStyle);
    self.tagsButton.hidden = self.tagsPlaceholderLabel.hidden = self.isOtherPeopleStyle;
    self.tagsButton.hidden =YES;
   
    if (!self.isOtherPeopleStyle) {
        self.tagsLabel.hidden = (self.tags.count == 0);
        self.tagsPlaceholderLabel.hidden = (self.tags.count != 0);
    }else{
        self.becomeCompany.hidden=YES;
        //如果是其它用户
        NSLog(@"其他用户");
        self.tagsTitleLabel.text = YCTLocalizedTableString(@"mine.becomeCompany.companyTags", @"Mine");
//        self.tagsTitleLabel.text = @"品牌/标签:";
        self.tagsStackView.hidden =NO;
        self.tagsLabel.hidden = NO;
        self.tagsPlaceholderLabel.hidden =YES;
    }
    
    NSString *title = (self.tags.count == 0) ? YCTLocalizedTableString(@"mine.userInfo.set", @"Mine") : YCTLocalizedTableString(@"mine.userInfo.modifyTags", @"Mine");
    [self.tagsButton setTitle:title forState:(UIControlStateNormal)];
    
    if (self.tags.count > 0) {
        self.tagsLabel.textLayout = [self userTagsLayout:self.tags];
        [self.tagsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.tagsLabel.textLayout.textBoundingSize.height).priority(kPriority);
        }];
    }else{
        self.tagsStackView.hidden =YES;
        self.tagsLabel.hidden = YES;
    }
}

- (void)setBriefIntro:(NSString *)briefIntro isBusiness:(BOOL)isBusiness {
    self.briefIntroStr = briefIntro ?: @"";
    self.isBusiness = isBusiness;
    
    self.briefButton.hidden = self.isOtherPeopleStyle;
    self.briefStackView.hidden = isBusiness;
    self.categoryTitleContainerView.hidden =
    self.vendorInfoViewNew.hidden = !isBusiness;
    self.vendorInfoView.hidden =YES;
//    self.categoryTitleContainerView.hidden = NO;
    
//    [self.categoryTitleView reloadData];
    if (!isBusiness) {
        NSString *text = briefIntro;
        if (briefIntro.length == 0) {
            if (self.isOtherPeopleStyle) {
                text = YCTLocalizedTableString(@"mine.userInfo.businessBriefPlaceholder.other", @"Mine");
            }
            else if (isBusiness) {
                text = YCTLocalizedTableString(@"mine.userInfo.businessBriefPlaceholder", @"Mine");
            }
            else {
                text = YCTLocalizedTableString(@"mine.userInfo.briefPlaceholder", @"Mine");
            }
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{
            NSFontAttributeName: kTextFont,
            NSForegroundColorAttributeName: (briefIntro.length == 0) ? UIColor.placeholderColor : UIColor.mainTextColor,
            NSParagraphStyleAttributeName: paragraphStyle,
        }];
        
        YYTextContainer *tagContainer = [YYTextContainer containerWithSize:CGSizeMake(Iphone_Width - kMargin * 2, 999)];
        tagContainer.truncationType = YYTextTruncationTypeEnd;
        tagContainer.maximumNumberOfRows = 4;
        YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:tagContainer text:attributedText];
        
        NSString *title = self.briefIntroStr.length == 0 ? YCTLocalizedTableString(@"mine.userInfo.set", @"Mine") : YCTLocalizedTableString(@"mine.userInfo.modifyBrief", @"Mine");
        [self.briefButton setTitle:title forState:(UIControlStateNormal)];
        
        self.briefLabel.attributedText = attributedText;
        [self.briefLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textLayout.textBoundingSize.height).priority(kPriority);
        }];
    }
}

- (void)setBanners:(NSArray<NSString *> *)banners {
    self.carouselView.urls = banners;
    self.carouselView.hidden = (banners.count == 0);
    self.carouselView.hidden = YES;
}

- (void)hideContactButton {
    self.bottomButtonContainerView.hidden = YES;
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
    if (contentOffsetY < 0) {
        CGRect frame = CGRectMake(0, 0, Iphone_Width, 210);
        frame.size.height -= contentOffsetY;
        frame.origin.y = contentOffsetY;
        self.bgImageView.frame = frame;
    } else if (CGRectEqualToRect(self.bgImageView.frame, CGRectMake(0, 0, Iphone_Width, 210))) {
        self.bgImageView.frame = CGRectMake(0, 0, Iphone_Width, 210);
    }
}

#pragma mark - Private

- (YYTextLayout *)userTagsLayout:(NSArray<NSString *> *)userTags {
    NSMutableArray *tags = [NSMutableArray arrayWithArray:userTags];
//    [tags addObject:YCTLocalizedTableString(@"mine.addTagText", @"Mine")];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    text.append(tags, ^(YCTTagListStyleMaker *make) {
        make.textColor = UIColor.mainTextColor;
        make.font = [UIFont PingFangSCMedium:12];
        make.fillColor = UIColorFromRGB(0xf8f8f8);
        make.cornerRadius = 100;
        make.insets = UIEdgeInsetsMake(-4, -12, -3, -12);
        make.maxWidth = Iphone_Width - kMargin * 2;
        make.margin = 10;
        
        make.lineSpace = 10;
    });
    text.yy_minimumLineHeight = 25;
    
    YYTextContainer *tagContainer = [YYTextContainer containerWithSize:CGSizeMake(Iphone_Width - kMargin * 2, 999)];
    return [YYTextLayout layoutWithContainer:tagContainer text:text];
}

- (UIBezierPath *)nameAvatarBezierPath {
    CGFloat avatarRadius = kNameAvatarHeight / 2;
    CGFloat topOffset = kNameAvatarHeight / 2;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, topOffset)];
    [bezierPath addLineToPoint:CGPointMake(Iphone_Width - kNameAvatarHeight - 15, topOffset)];
    [bezierPath addArcWithCenter:CGPointMake(Iphone_Width - avatarRadius - 15, topOffset) radius:avatarRadius startAngle:M_PI endAngle:M_PI * 2 clockwise:YES];
    [bezierPath addLineToPoint:CGPointMake(Iphone_Width, topOffset)];
    [bezierPath addLineToPoint:CGPointMake(Iphone_Width, kNameAvatarHeight + kVipHeight)];
    [bezierPath addLineToPoint:CGPointMake(0, kNameAvatarHeight + kVipHeight)];
    [bezierPath closePath];
    return bezierPath;
}

#pragma mark - JXCategoryViewDelegate

- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    if (index == 1) {
        !self.vendorInfoClickBlock ?: self.vendorInfoClickBlock();
        return NO;
    }
    return YES;
}

#pragma mark - Getter

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = ({
            UIStackView *view = [[UIStackView alloc] init];
            view.axis = UILayoutConstraintAxisVertical;
            view.alignment = UIStackViewAlignmentFill;
            view.distribution = UIStackViewDistributionFill;
            view.spacing = 1;
            view;
        });
    }
    return _stackView;
}

- (UIView *)avatarNameView {
    if (!_avatarNameView) {
        _avatarNameView = [[UIView alloc] init];
        _avatarNameView.backgroundColor = UIColor.whiteColor;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [self nameAvatarBezierPath].CGPath;
        _avatarNameView.layer.mask = maskLayer;
    }
    return _avatarNameView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.layer.borderWidth = kAvatarBorder;
            view.layer.cornerRadius = kAvatarSize / 2;
            view.layer.borderColor = UIColor.whiteColor.CGColor;
            view.layer.masksToBounds = YES;
            view.userInteractionEnabled = YES;
            @weakify(self);
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                @strongify(self);
                if (self.avatarClickBlock) {
                    self.avatarClickBlock();
                }
            }]];
            view;
        });
    }
    return _avatarImageView;
}

- (UIImageView *)vipImageView {
    if (!_vipImageView) {
        _vipImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.image = [UIImage imageNamed:@"mine_vip"];
            view.hidden = YES;
            view;
        });
    }
    return _vipImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view.text = @" ";
            view.font = [UIFont PingFangSCBold:23];
            view.textColor = UIColor.mainTextColor;
            view;
        });
    }
    return _nameLabel;
}

- (UILabel *)vipLabel {
    if (!_vipLabel) {
        _vipLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view.text = @" ";
            view.font = [UIFont PingFangSCMedium:13];
            view.textColor = UIColor.mainTextColor;
            view;
        });
    }
    return _vipLabel;
}

- (UILabel *)likeTitleLabel {
    if (!_likeTitleLabel) {
        _likeTitleLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view.text = YCTLocalizedTableString(@"mine.likesCount", @"Mine");
            view.font = [UIFont PingFangSCMedium:12];
            view.textColor = UIColor.mainGrayTextColor;
            view.userInteractionEnabled = YES;
            @weakify(self);
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                @strongify(self);
                if (self.likesClickBlock) {
                    self.likesClickBlock();
                }
            }]];
            view;
        });
    }
    return _likeTitleLabel;
}

- (UILabel *)likeCountLabel {
    if (!_likeCountLabel) {
        _likeCountLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view.font = [UIFont PingFangSCBold:16];
            view.textColor = UIColor.mainTextColor;
            view.userInteractionEnabled = YES;
            @weakify(self);
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                @strongify(self);
                if (self.likesClickBlock) {
                    self.likesClickBlock();
                }
            }]];
            view;
        });
    }
    return _likeCountLabel;
}

- (UILabel *)attentionTitleLabel {
    if (!_attentionTitleLabel) {
        _attentionTitleLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view.text = YCTLocalizedTableString(@"mine.attentionCount", @"Mine");
            view.font = [UIFont PingFangSCMedium:12];
            view.textColor = UIColor.mainGrayTextColor;
            view.userInteractionEnabled = YES;
            @weakify(self);
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                @strongify(self);
                if (self.followClickBlock) {
                    self.followClickBlock();
                }
            }]];
            view;
        });
    }
    return _attentionTitleLabel;
}

- (UILabel *)attentionCountLabel {
    if (!_attentionCountLabel) {
        _attentionCountLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view.font = [UIFont PingFangSCBold:16];
            view.textColor = UIColor.mainTextColor;
            view.userInteractionEnabled = YES;
            @weakify(self);
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                @strongify(self);
                if (self.followClickBlock) {
                    self.followClickBlock();
                }
            }]];
            view;
        });
    }
    return _attentionCountLabel;
}

- (UILabel *)fansTitleLabel {
    if (!_fansTitleLabel) {
        _fansTitleLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view.text = YCTLocalizedTableString(@"mine.fansCount", @"Mine");
            view.font = [UIFont PingFangSCMedium:12];
            view.textColor = UIColor.mainGrayTextColor;
            view.userInteractionEnabled = YES;
            @weakify(self);
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                @strongify(self);
                if (self.fansClickBlock) {
                    self.fansClickBlock();
                }
            }]];
            view;
        });
    }
    return _fansTitleLabel;
}

- (UILabel *)fansCountLabel {
    if (!_fansCountLabel) {
        _fansCountLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view.font = [UIFont PingFangSCBold:16];
            view.textColor = UIColor.mainTextColor;
            view.userInteractionEnabled = YES;
            @weakify(self);
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                @strongify(self);
                if (self.fansClickBlock) {
                    self.fansClickBlock();
                }
            }]];
            view;
        });
    }
    return _fansCountLabel;
}

- (UILabel *)idTitleLabel {
    if (!_idTitleLabel) {
        _idTitleLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view.font = [UIFont PingFangSCMedium:12];
            view.textColor = UIColor.mainTextColor;
            view.text = YCTLocalizedTableString(@"mine.IDTitle", @"Mine");
            view;
        });
    }
    return _idTitleLabel;
}

- (UILabel *)idValueLabel {
    if (!_idValueLabel) {
        _idValueLabel = ({
            UILabel *view = [[UILabel alloc] init];
            view.font = [UIFont PingFangSCMedium:12];
            view.textColor = UIColor.mainTextColor;
            view;
        });
    }
    return _idValueLabel;
}

- (UIImageView *)idCodeImageView {
    if (!_idCodeImageView) {
        _idCodeImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.contentMode = UIViewContentModeCenter;
            view.image = [UIImage imageNamed:@"mine_mine_idCode"];
            view.userInteractionEnabled = YES;
            @weakify(self);
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                @strongify(self);
                if (self.qrCodeClickBlock) {
                    self.qrCodeClickBlock();
                }
            }]];
            view;
        });
    }
    return _idCodeImageView;
}

- (UIView *)baseInfoView {
    if (!_baseInfoView) {
        _baseInfoView = [[UIView alloc] init];
        _baseInfoView.backgroundColor = UIColor.whiteColor;
    }
    return _baseInfoView;
}

- (UIView *)categoryTitleContainerView {
    if (!_categoryTitleContainerView) {
        _categoryTitleContainerView = [[UIView alloc] init];
        _categoryTitleContainerView.backgroundColor = UIColor.whiteColor;
    }
    return _categoryTitleContainerView;
}

- (JXCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = ({
            JXCategoryTitleView *view = [[JXCategoryTitleView alloc] init];
            view.titleColorGradientEnabled = YES;
            view.averageCellSpacingEnabled = NO;
            view.cellWidthZoomEnabled = YES;
            view.titleFont = [UIFont PingFangSCMedium:14];
            view.titleSelectedFont = [UIFont PingFangSCBold:16];
            view.titleColor = UIColor.segmentTitleColor;
            view.titleSelectedColor = UIColor.segmentSelectedTitleColor;
            view.cellSpacing = 24;
            view.contentEdgeInsetLeft = 0;
            view.delegate = self;
            view;
        });
        _categoryTitleView.titles = @[
            YCTLocalizedTableString(@"mine.userInfo.basicInfo", @"Mine"),
            YCTLocalizedTableString(@"mine.userInfo.vendorIntro", @"Mine")
        ];
    }
    return _categoryTitleView;
}
- (CompanyBasicInfo *)vendorInfoViewNew {
    if (!_vendorInfoViewNew) {
        _vendorInfoViewNew=[[CompanyBasicInfo alloc] init];
    }
    return _vendorInfoViewNew;
}

- (YCTMineUserVendorInfoView *)vendorInfoView {
    if (!_vendorInfoView) {
        _vendorInfoView = ({
            YCTMineUserVendorInfoView *view = [[NSBundle mainBundle] loadNibNamed:@"YCTMineUserVendorInfoView" owner:self options:nil].firstObject;
            view;
        });
    }
    return _vendorInfoView;
}

- (NSAttributedString *)truncationToken {
    NSMutableAttributedString *moreString = [[NSMutableAttributedString alloc] initWithString:YCTLocalizedTableString(@"mine.userInfo.briefTruncationToken", @"Mine")];
    moreString.yy_font = kTextFont;
    moreString.yy_color = UIColor.mainThemeColor;
    YYTextHighlight *hi = [YYTextHighlight new];
    @weakify(self);
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        @strongify(self);
        YCTVendorFullIntroView *view = [[YCTVendorFullIntroView alloc] initWithText:self.briefIntroStr];
        [view yct_showWithTitle:YCTLocalizedTableString(@"mine.userInfo.vendorIntro", @"Mine") cancelTitle:YCTLocalizedString(@"action.close")];
        
    };
    [moreString yy_setTextHighlight:hi range:NSMakeRange(0, moreString.length)];
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = moreString;
    [seeMore sizeToFit];
    
    return [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:moreString.yy_font alignment:YYTextVerticalAlignmentTop];
}

- (UIStackView *)tagsStackView {
    if (!_tagsStackView) {
        _tagsStackView = ({
            UIStackView *view = [[UIStackView alloc] init];
            view.axis = UILayoutConstraintAxisVertical;
            view.alignment = UIStackViewAlignmentFill;
            view.distribution = UIStackViewDistributionFill;
            view.spacing = 0;
            view;
        });
    }
    return _tagsStackView;
}

- (UIView *)tagsContainerView {
    if (!_tagsContainerView) {
        _tagsContainerView = [[UIView alloc] init];
        _tagsContainerView.backgroundColor = UIColor.whiteColor;
    }
    return _tagsContainerView;
}

- (UIButton *)tagsButton {
    if (!_tagsButton) {
        _tagsButton = ({
            UIButton *view = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [view setGrayStyleWithTitle:@"" fontSize:13 cornerRadius:16 imageName:nil];
            view.titleLabel.font = [UIFont PingFangSCBold:13];
            @weakify(self);
            [[view rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                if (self.addTagClickBlock) {
                    self.addTagClickBlock();
                }
            }];
            view;
        });
    }
    return _tagsButton;
}

- (UILabel *)tagsPlaceholderLabel {
    if (!_tagsPlaceholderLabel) {
        _tagsPlaceholderLabel = [[UILabel alloc] init];
        _tagsPlaceholderLabel.text = YCTLocalizedTableString(@"mine.userInfo.tagPlaceholder", @"Mine");
        _tagsPlaceholderLabel.font = [UIFont PingFangSCMedium:13];
        _tagsPlaceholderLabel.textColor = [UIColor placeholderColor];
    }
    return _tagsPlaceholderLabel;
}

- (YYLabel *)tagsLabel {
    if (!_tagsLabel) {
        _tagsLabel = ({
            YYLabel *view = [[YYLabel alloc] init];
            view;
        });
    }
    return _tagsLabel;
}

- (UIView *)tagsMiddleSpace {
    if (!_tagsMiddleSpace) {
        _tagsMiddleSpace = [[UIView alloc] init];
        _tagsMiddleSpace.backgroundColor = UIColor.whiteColor;
    }
    return _tagsMiddleSpace;
}

- (UIView *)tagsBottomSpace {
    if (!_tagsBottomSpace) {
        _tagsBottomSpace = [[UIView alloc] init];
        _tagsBottomSpace.backgroundColor = UIColor.whiteColor;
    }
    return _tagsBottomSpace;
}

- (UIStackView *)briefStackView {
    if (!_briefStackView) {
        _briefStackView = ({
            UIStackView *view = [[UIStackView alloc] init];
            view.axis = UILayoutConstraintAxisVertical;
            view.alignment = UIStackViewAlignmentFill;
            view.distribution = UIStackViewDistributionFill;
            view.spacing = 0;
            view;
        });
    }
    return _briefStackView;
}

- (UIView *)briefContainerView {
    if (!_briefContainerView) {
        _briefContainerView = [[UIView alloc] init];
        _briefContainerView.backgroundColor = UIColor.whiteColor;
    }
    return _briefContainerView;
}

- (YYLabel *)briefLabel {
    if (!_briefLabel) {
        _briefLabel = ({
            YYLabel *view = [[YYLabel alloc] init];
            view.numberOfLines = 4;
            view.truncationToken = [self truncationToken];
            view;
        });
    }
    return _briefLabel;
}

- (UIButton *)briefButton {
    if (!_briefButton) {
        _briefButton = ({
            UIButton *view = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [view setGrayStyleWithTitle:@"" fontSize:13 cornerRadius:16 imageName:nil];
            view.titleLabel.font = [UIFont PingFangSCBold:13];
            @weakify(self);
            [[view rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                if (self.briefIntroClickBlock) {
                    self.briefIntroClickBlock();
                }
            }];
            view;
        });
    }
    return _briefButton;
}

- (UIView *)briefMiddleSpace {
    if (!_briefMiddleSpace) {
        _briefMiddleSpace = [[UIView alloc] init];
        _briefMiddleSpace.backgroundColor = UIColor.whiteColor;
    }
    return _briefMiddleSpace;
}

- (UIView *)briefBottomSpace {
    if (!_briefBottomSpace) {
        _briefBottomSpace = [[UIView alloc] init];
        _briefBottomSpace.backgroundColor = UIColor.whiteColor;
    }
    return _briefBottomSpace;
}

- (YCTCarouselView *)carouselView {
    if (!_carouselView) {
        _carouselView = ({
            YCTCarouselView *view = [[YCTCarouselView alloc] init];
            view.cornerRadius = 5;
            view.itemWidth = Iphone_Width - 2 * kMargin;
            view.itemHeight = kCarouselHeight;
            view.itemSpacing = kMargin;
            view;
        });
    }
    return _carouselView;
}

- (UIView *)bottomButtonContainerView {
    if (!_bottomButtonContainerView) {
        _bottomButtonContainerView = [[UIView alloc] init];
        _bottomButtonContainerView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomButtonContainerView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = ({
            UIButton *view = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [view setDarkStyleWithTitle:YCTLocalizedTableString(@"mine.editInformation", @"Mine")
                               fontSize:15
                           cornerRadius:kButtonHeight / 2
                              imageName:@"mine_mine_edit"];
          
            @weakify(self);
            [[view rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                if (self.editInfoClickBlock) {
                    self.editInfoClickBlock();
                }
            }];
            view;
        });
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = ({
            UIButton *view = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [view setGrayStyleWithTitle:YCTLocalizedTableString(@"mine.addVendor", @"Mine")
                               fontSize:15
                           cornerRadius:kButtonHeight / 2
                              imageName:@"mine_mine_addVendor"];
            @weakify(self);
            [[view rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                if (self.addVendorClickBlock) {
                    self.addVendorClickBlock();
                }
            }];
            view;
        });
    }
    return _rightButton;
}

@end
