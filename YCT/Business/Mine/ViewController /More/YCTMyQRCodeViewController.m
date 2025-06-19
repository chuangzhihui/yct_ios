//
//  YCTMyQRCodeViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/17.
//

#import "YCTMyQRCodeViewController.h"
#import "YCTMyQRCodeShareView.h"
#import "YCTQRCodeScanViewController.h"
#import "UIImage+Common.h"
#import <Photos/Photos.h>
#import "YCTOtherPeopleHomeViewController.h"
#import "YCTApiMineQRCode.h"
#import "YCTShareFriendListView.h"
#import "YCTDragPresentView.h"
#import "YCTWebviewURLProvider.h"
#import "YCTChatUtil.h"
#import <Photos/PHPhotoLibrary.h>
#define kQRCodeSize (CGSize){(Iphone_Width - 63 * 2 - 25 * 2), (Iphone_Width - 63 * 2 - 25 * 2)}

@interface YCTMyQRCodeViewController ()
@property (nonatomic, strong) YCTQRCodeUserInfoModel *model;
@property (nonatomic, strong) UITapGestureRecognizer *errorTap;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIImageView *qrCodeImageView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *errorMsgLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *sloganLabel;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIButton *scanButton;
@property (nonatomic, weak) IBOutlet UIButton *downloadButton;
@end

@implementation YCTMyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = YCTLocalizedTableString(@"mine.title.myQRCode", @"Mine");
    self.view.backgroundColor = UIColor.mainTextColor;
    
    @weakify(self);
    self.errorTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        [self requestUserId];
    }];
    self.errorTap.enabled = NO;
    self.qrCodeImageView.userInteractionEnabled = YES;
    [self.qrCodeImageView addGestureRecognizer:self.errorTap];
    
    self.errorMsgLabel.text = YCTLocalizedString(@"empty.error.info");
    self.errorMsgLabel.textColor = UIColor.mainTextColor;
    self.errorMsgLabel.font = [UIFont PingFangSCBold:15];
    self.errorMsgLabel.hidden = YES;
    
    if (@available(iOS 13.0, *)) {
        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
        self.indicatorView.color = UIColor.mainTextColor;
    } else {
        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.indicatorView.color = UIColor.mainTextColor;
    }
    
    self.shareButton.hidden = YES;
    self.scanButton.hidden = YES;
    self.downloadButton.hidden = YES;
    
    [self requestUserId];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeNavigationBarColor:UIColor.mainTextColor titleColor:UIColor.whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self changeNavigationBarColor:UIColor.whiteColor titleColor:UIColor.navigationBarTitleColor];
}

- (void)dealloc {
    self.qrCodeImageView.image = nil;
}

- (void)bindViewModel {
    RAC(self.nameLabel, text) = RACObserve([YCTUserDataManager sharedInstance], userInfoModel.nickName);
}

- (void)setupView {
    [self.shareButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    [self.shareButton setTitle:YCTLocalizedTableString(@"mine.myQRCode.share", @"Mine") forState:(UIControlStateNormal)];
    self.shareButton.titleLabel.font = [UIFont PingFangSCMedium:12];
    
    [self.scanButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    [self.scanButton setTitle:YCTLocalizedTableString(@"mine.myQRCode.scan", @"Mine") forState:(UIControlStateNormal)];
    self.scanButton.titleLabel.font = [UIFont PingFangSCMedium:12];
    
    [self.downloadButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    [self.downloadButton setTitle:YCTLocalizedTableString(@"mine.myQRCode.save", @"Mine") forState:(UIControlStateNormal)];
    self.downloadButton.titleLabel.font = [UIFont PingFangSCMedium:12];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [self containerPath].CGPath;
    self.containerView.layer.mask = maskLayer;
    
    self.nameLabel.textColor = UIColor.mainTextColor;
    self.nameLabel.font = [UIFont PingFangSCBold:18];
    
    self.qrCodeImageView.backgroundColor = UIColor.mainTextColor;
    self.qrCodeImageView.layer.cornerRadius = 8;
    self.qrCodeImageView.layer.masksToBounds = YES;
    self.qrCodeImageView.backgroundColor = UIColor.whiteColor;
    
    self.sloganLabel.textColor = UIColor.mainGrayTextColor;
    self.sloganLabel.font = [UIFont PingFangSCMedium:14];
    self.sloganLabel.text = YCTLocalizedTableString(@"mine.myQRCode.slogon", @"Mine");
}

#pragma mark - Private

- (void)requestUserId {
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
    YCTApiMineQRCode *api = [[YCTApiMineQRCode alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        YCTMineQRCodeModel *qrCodeModel = request.responseDataModel;
        self.model = qrCodeModel.user;
        if (self.model.userId) {
            [self generateQRCode:self.model.userId];
            self.shareButton.hidden = NO;
            self.scanButton.hidden = NO;
            self.downloadButton.hidden = NO;
            
            self.errorTap.enabled = NO;
            self.errorMsgLabel.hidden = YES;
        } else {
            self.errorTap.enabled = YES;
            self.errorMsgLabel.hidden = NO;
        }
        self.indicatorView.hidden = YES;
        [self.indicatorView stopAnimating];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.indicatorView.hidden = YES;
        [self.indicatorView stopAnimating];
        self.errorTap.enabled = YES;
        self.errorMsgLabel.hidden = NO;
    }];
}

- (void)generateQRCode:(NSString *)userId {
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[YCTUserDataManager sharedInstance].userInfoModel.avatar] options:(SDWebImageHighPriority) progress:NULL completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image) {
            self.avatarImageView.image = image;
        }
    }];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        
//        "https://video.honghukeji.net/index.html#/index?id=" + personid + "&lan=" + lan;
        
        int lan = [[YCTSanboxTool getCurrentLanguage] isEqualToString:EN] ? 2 : 1;
        
        NSString *shareUserUrl = [NSString stringWithFormat:@"https://yct.vnppp.net/index.html#/index?id=%@&lan=%d", userId, lan];
        
        UIImage *image = [UIImage createQRCodeWithText:shareUserUrl qrCodeSize:kQRCodeSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.qrCodeImageView.image = image;
        });
    });
}

- (UIBezierPath *)containerPath {
    CGFloat width = (Iphone_Width - 63 * 2);
    CGFloat codeWidth = width - 25 * 2;
    CGFloat height = width + 100;
    CGFloat _radius = 10;
    CGFloat gapRadius = 9;
    
    CGPoint hLeftUpPoint = CGPointMake(_radius, 0);
    CGPoint hRightUpPoint = CGPointMake(width - _radius, 0);
    CGPoint hLeftDownPoint = CGPointMake(_radius, height);
    
    CGPoint vLeftUpPoint = CGPointMake(0, _radius);
    CGPoint vRightDownPoint = CGPointMake(width, height - _radius);
    
    CGPoint centerLeftUp = CGPointMake(_radius, _radius);
    CGPoint centerRightUp = CGPointMake(width - _radius, _radius);
    CGPoint centerLeftDown = CGPointMake(_radius, height - _radius);
    CGPoint centerRightDown = CGPointMake(width - _radius, height - _radius);
    
    CGPoint leftGapPoint = CGPointMake(0, 25 + codeWidth + 33 + gapRadius * 2);
    CGPoint centerLeftGap = CGPointMake(0, 25 + codeWidth + 33 + gapRadius);
    CGPoint rightGapPoint = CGPointMake(width, 25 + codeWidth + 33);
    CGPoint centerRightGap = CGPointMake(width, 25 + codeWidth + 33 + gapRadius);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:hLeftUpPoint];
    [bezierPath addLineToPoint:hRightUpPoint];
    [bezierPath addArcWithCenter:centerRightUp radius:_radius startAngle:(M_PI * 3 / 2) endAngle:(M_PI * 2) clockwise:YES];
    
    [bezierPath addLineToPoint:rightGapPoint];
    [bezierPath addArcWithCenter:centerRightGap radius:gapRadius startAngle:-(M_PI / 2) endAngle:-(M_PI * 3 / 2) clockwise:NO];
    
    [bezierPath addLineToPoint:vRightDownPoint];
    [bezierPath addArcWithCenter:centerRightDown radius:_radius startAngle:0 endAngle:(M_PI / 2) clockwise:true];
    [bezierPath addLineToPoint:hLeftDownPoint];
    [bezierPath addArcWithCenter:centerLeftDown radius:_radius startAngle:(M_PI / 2) endAngle:(M_PI) clockwise:YES];
    
    [bezierPath addLineToPoint:leftGapPoint];
    [bezierPath addArcWithCenter:centerLeftGap radius:gapRadius startAngle:-(M_PI * 3 / 2) endAngle:-(M_PI * 5 / 2) clockwise:NO];
    
    [bezierPath addLineToPoint:vLeftUpPoint];
    [bezierPath addArcWithCenter:centerLeftUp radius:_radius startAngle:(M_PI) endAngle:(M_PI * 3 / 2) clockwise:YES];
    [bezierPath addLineToPoint:hLeftUpPoint];
    [bezierPath closePath];
    return bezierPath;
}

#pragma mark - Action

- (void)showShareFriendList {
    YCTShareFriendListView *view = [[YCTShareFriendListView alloc] initWithShareBlock:^(YCTShareType shareType, YCTShareResultModel * _Nullable resultModel) {
        [resultModel.userIds enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [YCTChatUtil sendFollowMsg:[YCTUserDataManager sharedInstance].userInfoModel.nickName avatarUrl:[YCTUserDataManager sharedInstance].userInfoModel.avatar followUserId:self.model.userId userId:obj remark:resultModel.note];
        }];
    }];
    [[YCTDragPresentView sharePresentView] showView:view];
}

- (IBAction)shareClick:(id)sender {
    YCTMyQRCodeShareView *shareView = [[YCTMyQRCodeShareView alloc] init];
    shareView.clickBlock = ^(YCTShareType shareType) {
        if (shareType == YCTSharePrivateMessage) {
            [self showShareFriendList];
        } else {
            YCTOpenPlatformType type = YCTOpenPlatformTypeZalo;
            if (shareType == YCTShareWeChatTimeLine) {
                type = YCTOpenPlatformTypeWeChatTimeLine;
            } else if (shareType == YCTShareWeChat) {
                type = YCTOpenPlatformTypeWeChatSession;
            }else if (shareType == YCTShareFB) {
                type = YCTOpenPlatformTypeFaceBook;
            }
            [self shareWithType:type];
        }
    };
    [shareView yct_show];
}

- (IBAction)scanQRCodeClick:(id)sender {
    
   
    YCTQRCodeScanViewController *vc = [[YCTQRCodeScanViewController alloc] init];
    vc.scanResultBlock = ^(NSString *result) {
        NSString *idStr = [YCTChatUtil unwrappedUserIdFromUrl:result];
        if (!idStr) return;
        
        NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:YCTQRCodeScanViewController.class]) {
                [vcs removeObject:obj];
                *stop = YES;
            }
        }];
        [vcs addObject:[YCTOtherPeopleHomeViewController otherPeopleHomeWithUserId:idStr]];
        [self.navigationController setViewControllers:vcs.copy animated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)saveQRCodeClick:(id)sender {
    [UIImage generateSnapshotWithView:self.containerView completion:^(UIImage * _Nullable image) {
        [self saveImage:image];
    }];
}

- (void)shareWithType:(YCTOpenPlatformType)type {
    YCTShareWebpageItem *item = [YCTShareWebpageItem new];
    item.webpageUrl = [YCTWebviewURLProvider sharedUserHomePageUrlWithId:self.model.userId].absoluteString;
    item.desc = [YCTUserDataManager sharedInstance].userInfoModel.nickName;
    item.thumbImage = [YCTUserDataManager sharedInstance].userInfoModel.avatar;
    YCTOpenMessageObject *msg = [YCTOpenMessageObject new];
    msg.shareObject = item;
    [[YCTOpenPlatformManager defaultManager] sendMessage:msg toPlatform:type completion:^(BOOL isSuccess, NSString * _Nullable error) {
        if (isSuccess) {
            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedString(@"alert.shareSuccess")];
        } else {
            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedString(@"alert.shareFailed")];
        }
    }];
}

- (void)saveImage:(UIImage *)image {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        } else {
            [[YCTHud sharedInstance] showToastHud:YCTLocalizedString(@"share.saveFailed")];
        }
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [[YCTHud sharedInstance] showToastHud:YCTLocalizedString(@"share.saveSuccess")];
    } else {
        [[YCTHud sharedInstance] showToastHud:YCTLocalizedString(@"share.saveFailed")];
    }
}

#pragma mark - Override

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
