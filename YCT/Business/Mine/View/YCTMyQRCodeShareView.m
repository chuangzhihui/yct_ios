//
//  YCTMyQRCodeShareView.m
//  YCT
//
//  Created by 木木木 on 2021/12/18.
//

#import "YCTMyQRCodeShareView.h"
#import "YCTVerticalButton.h"

#define kButtonWidth 48
#define kButtonHeight 64

@interface YCTMyQRCodeShareView ()

@property (strong, nonatomic) YCTVerticalButton *messageButton;
@property (strong, nonatomic) YCTVerticalButton *friendsZoneButton;
@property (strong, nonatomic) YCTVerticalButton *wechatButton;
@property (strong, nonatomic) YCTVerticalButton *zaloButton;
@property (strong, nonatomic) YCTVerticalButton *facebookButton;
@end

@implementation YCTMyQRCodeShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    @weakify(self);
    
    self.messageButton = [self buttonWithTitle:YCTLocalizedTableString(@"mine.myQRCode.private", @"Mine") imageName:@"share_privateSend"];;
    [self addSubview:self.messageButton];
    [[self.messageButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickWithType:YCTSharePrivateMessage];
    }];
    
    self.friendsZoneButton = [self buttonWithTitle:YCTLocalizedTableString(@"mine.myQRCode.friends", @"Mine") imageName:@"share_wechat_friend"];
    [self addSubview:self.friendsZoneButton];
    [[self.friendsZoneButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickWithType:YCTShareWeChatTimeLine];
    }];
    
    self.wechatButton = [self buttonWithTitle:YCTLocalizedTableString(@"mine.myQRCode.weChat", @"Mine") imageName:@"share_wechat"];
    [self addSubview:self.wechatButton];
    [[self.wechatButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickWithType:YCTShareWeChat];
    }];
    
    self.zaloButton = [self buttonWithTitle:YCTLocalizedString(@"share.zalo") imageName:@"share_zalo"];
    [self addSubview:self.zaloButton];
    [[self.zaloButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickWithType:YCTShareZalo];
    }];
    self.facebookButton = [self buttonWithTitle:@"FaceBook" imageName:@"facebook"];
    [self addSubview:self.facebookButton];
    [[self.facebookButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickWithType:YCTShareFB];
    }];
    CGFloat top = 39;
    
    CGFloat margin = ceil((Iphone_Width - kButtonWidth * 5 - 8 * 2) / 6.0) + 8;
    self.messageButton.frame = CGRectMake(margin, top, kButtonWidth, kButtonHeight);
    self.friendsZoneButton.frame = CGRectMake(CGRectGetMaxX(self.messageButton.frame) + margin - 8, top, kButtonWidth, kButtonHeight);
    self.wechatButton.frame = CGRectMake(CGRectGetMaxX(self.friendsZoneButton.frame) + margin - 8, top, kButtonWidth, kButtonHeight);
    self.zaloButton.frame = CGRectMake(CGRectGetMaxX(self.wechatButton.frame) + margin - 8, top, kButtonWidth, kButtonHeight);
    self.facebookButton.frame = CGRectMake(CGRectGetMaxX(self.zaloButton.frame) + margin - 8, top, kButtonWidth, kButtonHeight);
    self.bounds = (CGRect){0, 0, Iphone_Width, 150};
}

- (void)buttonClickWithType:(YCTShareType)shareType {
    [self yct_closeWithCompletion:^{
        if (self.clickBlock) {
            self.clickBlock(shareType);
        }
    }];
}

#pragma mark - Getter

- (YCTVerticalButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    YCTVerticalButton *view = [YCTVerticalButton buttonWithType:(UIButtonTypeSystem)];
    view.titleLabel.font = [UIFont PingFangSCMedium:10];
    [view setTitleColor:UIColor.mainTextColor forState:(UIControlStateNormal)];
    [view configTitle:title imageName:imageName];
    view.spacing = 10;
    return view;
}

@end
