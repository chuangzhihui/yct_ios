//
//  YCTMineUserInfoView.h
//  YCT
//
//  Created by 木木木 on 2021/12/12.
//

#import <UIKit/UIKit.h>
#import "YCTCarouselView.h"
#import "YCTMineUserVendorInfoView.h"
#import "CompanyBasicInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface YCTMineUserInfoView : UIView

@property (nonatomic, strong, readonly) UIImageView *bgImageView;//背景图
@property (nonatomic, strong, readonly) UIImageView *avatarImageView;//头像
@property (nonatomic, strong, readonly) UILabel *nameLabel;//昵称
@property (nonatomic, strong, readonly) UIImageView *vipImageView;//厂家标识
@property (nonatomic, strong, readonly) UILabel *vipLabel;//厂家标签
@property (nonatomic, strong, readonly) UILabel *likeCountLabel;//获赞数
@property (nonatomic, strong, readonly) UILabel *attentionCountLabel;//关注数
@property (nonatomic, strong, readonly) UILabel *fansCountLabel;//粉丝数
@property (nonatomic, strong, readonly) UILabel *idValueLabel;//id
@property (nonatomic, strong, readonly) UIImageView *idCodeImageView;//二维码图标
@property (nonatomic, strong, readonly) YCTCarouselView *carouselView;
@property (nonatomic, strong, readonly) UIButton *leftButton;
@property (nonatomic, strong, readonly) UIButton *rightButton;
@property (nonatomic, strong, readonly) YCTMineUserVendorInfoView *vendorInfoView;
@property (nonatomic, strong, readonly) CompanyBasicInfo *vendorInfoViewNew;
@property (nonatomic, copy) void (^bgImageClickBlock)(void);
@property (nonatomic, copy) void (^avatarClickBlock)(void);
@property (nonatomic, copy) void (^likesClickBlock)(void);
@property (nonatomic, copy) void (^followClickBlock)(void);
@property (nonatomic, copy) void (^fansClickBlock)(void);
@property (nonatomic, copy) void (^qrCodeClickBlock)(void);
@property (nonatomic, copy) void (^editInfoClickBlock)(void);
@property (nonatomic, copy) void (^addTagClickBlock)(void);
@property (nonatomic, copy) void (^briefIntroClickBlock)(void);
@property (nonatomic, copy) void (^addVendorClickBlock)(void);
@property (nonatomic, copy) void (^vendorInfoClickBlock)(void);

@property (nonatomic, assign, readonly) CGFloat contentHeight;

- (void)setOtherPeopleStyle;

- (void)updateContentHeight;

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;

- (void)setUserTags:(NSString *)userTags;

- (void)setBriefIntro:(NSString *)briefIntro isBusiness:(BOOL)isBusiness;

- (void)setBanners:(nullable NSArray<NSString *> *)banners;

- (void)hideContactButton;

@end

NS_ASSUME_NONNULL_END
