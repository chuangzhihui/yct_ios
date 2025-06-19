//
//  YCTVideoTableCell.m
//  YCT
//
//  Created by hua-cloud on 2021/12/12.
//

#import "YCTVideoTableCell.h"
#import "YCTFavoriteView.h"
#import "YCTShareView.h"
#import "YCTMoreBottomView.h"
#import "YCTOtherPeopleHomeViewController.h"
#import "YCTFeedBackViewController.h"
#import "UIDevice+Common.h"
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>
#import "YCTWebviewURLProvider.h"
#import "YCTVideoFullScreenVC.h"
#import "UIWindow+Common.h"

@interface YCTVideoTableCell()

#pragma mark ------------ playerContanier
@property (weak, nonatomic) IBOutlet UIImageView *videoCoverImageView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *playSlider;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@property (weak, nonatomic) IBOutlet UIView *seekGesView;
@property (weak, nonatomic) IBOutlet UILabel *seekCurrent;
@property (weak, nonatomic) IBOutlet UILabel *seekDuration;
@property (weak, nonatomic) IBOutlet UIStackView *seekTimeContainer;
@property (assign, nonatomic) CGFloat originValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playSliderBottom;



#pragma mark - avatar
@property (weak, nonatomic) IBOutlet UIView *avatarBGView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

#pragma mark - like
@property (weak, nonatomic) IBOutlet YCTFavoriteView *likeView;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

#pragma mark - comment
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

#pragma mark - share
@property (weak, nonatomic) IBOutlet UIView *shareContainer;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;

#pragma mark - more
@property (weak, nonatomic) IBOutlet UIView *moreContainer;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;

#pragma mark - album
@property (weak, nonatomic) IBOutlet UIImageView *albumBGImage;
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;

#pragma mark - container
@property (weak, nonatomic) IBOutlet UIStackView *rightContainer;
@property (weak, nonatomic) IBOutlet UIStackView *leftContainer;

#pragma mark ------------

@property (weak, nonatomic) IBOutlet UIButton *beFocused;
@property (weak, nonatomic) IBOutlet UIView *adressBGView;
@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UIStackView *musicBG;

@property (assign, nonatomic) bool beginSeek;
@property (strong, nonatomic) YCTVideoCellViewModel * viewModel;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenButton;
@end

@implementation YCTVideoTableCell

+ (UINib *)nib {
    return [UINib nibWithNibName:[[self class] cellReuseIdentifier] bundle:[NSBundle mainBundle]];
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.type = YCTVideoDetailTypeOther;
    [self.playSlider setThumbImage:[UIImage imageNamed:@"video_dot"] forState:UIControlStateNormal];
    [self.playSlider setThumbImage:[UIImage imageNamed:@"video_dot"] forState:UIControlStateHighlighted];
    self.shareLabel.text = YCTLocalizedString(@"share.share");
    self.moreLabel.text = YCTLocalizedString(@"share.more");
    [self.fullScreenButton setTitle:YCTLocalizedString(@"video.clickOnTheFullScreen") forState:UIControlStateNormal];
    self.playSlider.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    self.beFocused.layer.cornerRadius = 10.f;
    [self.beFocused setTitle:YCTLocalizedTableString(@"video.mySubscribe", @"Home") forState:UIControlStateNormal];
    self.avatarBGView.layer.cornerRadius = 25.f;
    self.avatarImageView.layer.cornerRadius = 24.f;
    self.attentionButton.layer.cornerRadius = 8.f;
    self.adressBGView.layer.cornerRadius = 10.f;

    UITapGestureRecognizer * nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameGesture:)];
    nameTap.numberOfTapsRequired =1;
    nameTap.numberOfTouchesRequired  =1;
    [self.userName addGestureRecognizer:nameTap];
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    singleTap.numberOfTapsRequired =1;
    singleTap.numberOfTouchesRequired  =1;
    [self.contentView addGestureRecognizer:singleTap];
               
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
    doubleTapGesture.numberOfTapsRequired =2;
    doubleTapGesture.numberOfTouchesRequired =1;
    [self.contentView addGestureRecognizer:doubleTapGesture];
    
    [singleTap requireGestureRecognizerToFail:doubleTapGesture];
    
    UIPanGestureRecognizer * seekGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(seekGesture:)];
    [self.seekGesView addGestureRecognizer:seekGesture];
    
    UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGes:)];
    longGes.minimumPressDuration = 0.5;
    longGes.delaysTouchesBegan = YES;
    [self.contentView addGestureRecognizer:longGes];
    
    @weakify(self);
    [self.likeView setTapCallBack:^{
        @strongify(self);
        @weakify(self);
        [YCTNavigationCoordinator loginIfNeededWithAction:^{
            @strongify(self);
            [self.viewModel requeustForZanVideo];
        }];
    }];
    
    [[self.attentionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        @weakify(self);
        [YCTNavigationCoordinator loginIfNeededWithAction:^{
            @strongify(self);
            [self.viewModel requeustForFollowUser];
        }];
    }];
    
    [RACObserve(self, type) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.type == YCTVideoDetailTypeOther) {
            self.moreContainer.hidden = YES;
            self.shareContainer.hidden = NO;
        }else if(self.type == YCTVideoDetailTypeMine){
            self.moreContainer.hidden = NO;
            self.shareContainer.hidden = YES;
        }else{
            self.rightContainer.hidden = YES;
        }
    }];
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGes{
    [self.viewModel handlePauseOrPlay];
}

- (void)triggerForStopPlaying{
    if (self.viewModel.isPlaying) {
        [self.viewModel handlePauseOrPlay];
    }
}

- (void)triggerTapGestureAction {
    // Create a dummy UITapGestureRecognizer if necessary
    UITapGestureRecognizer *dummyTapGesture = [[UITapGestureRecognizer alloc] init];
    [self tapGesture:dummyTapGesture];
}

- (void)nameGesture:(UITapGestureRecognizer *)tapGes{
    [self responseChainWithEventName:k_even_avatar_click userInfo:@{@"user_id":self.viewModel.videoModel.userId}];
}

- (void)doubleTapGesture:(UITapGestureRecognizer *)tapGes{
    @weakify(self);
    [YCTNavigationCoordinator loginIfNeededWithAction:^{
        @strongify(self);
        [self.viewModel requeustForZanVideo];
    }];
}

- (void)longGes:(UILongPressGestureRecognizer *)longGes{
    if (longGes.state == UIGestureRecognizerStateBegan && self.type == YCTVideoDetailTypeOther) {
        [UIDevice launchImpactFeedback];
        [self shareClickResponse:nil];
    }
}

- (void)seekGesture:(UIPanGestureRecognizer *)panGes{
    
    CGPoint tranPoint=[panGes translationInView:self];//播放进度
    CGFloat duration = self.playSlider.maximumValue;
    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
        UIPanGestureRecognizerDirectionUndefined,
        UIPanGestureRecognizerDirectionUp,
        UIPanGestureRecognizerDirectionDown,
        UIPanGestureRecognizerDirectionLeft,
        UIPanGestureRecognizerDirectionRight
    };
    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    switch (panGes.state) {
            case UIGestureRecognizerStateBegan: {
                self.seekTimeContainer.hidden = NO;
                [self contentTransformWithAlpha:0.0 animation:YES];
                if (!self.viewModel.isSeeking) {
                    self.playSliderBottom.constant = 6;
                    self.playSlider.transform = CGAffineTransformMakeScale(1.0f,3.0f);
                    self.seekDuration.text = [self formatDateWithTimeinterval:duration];
                }
                self.viewModel.isSeeking = YES;
                self.originValue = self.playSlider.value;// 记录开始滑动位置
                if (direction == UIPanGestureRecognizerDirectionUndefined) {
                    CGPoint velocity = [panGes velocityInView:self];
                    BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
                    if (isVerticalGesture) {
                        if (velocity.y > 0) {
                            direction = UIPanGestureRecognizerDirectionDown;
                        } else {
                            direction = UIPanGestureRecognizerDirectionUp;
                        }
                    }
                    else {
                        if (velocity.x > 0) {
                            direction = UIPanGestureRecognizerDirectionRight;
                        } else {
                            direction = UIPanGestureRecognizerDirectionLeft;
                        }
                    }
                }
                break;
            }
            case UIGestureRecognizerStateChanged: {
                switch (direction) {
                    case UIPanGestureRecognizerDirectionLeft:
                    case UIPanGestureRecognizerDirectionRight:{
                        self.playSlider.value= MAX(0.f, MIN(duration - 0.1, tranPoint.x/Iphone_Width * duration+self.originValue));
                        self.seekCurrent.text = [self formatDateWithTimeinterval:self.playSlider.value];
                    }
                        break;
                    default: {
                        break;
                    }
                }
                break;
            }
            case UIGestureRecognizerStateEnded: {
                self.seekTimeContainer.hidden = YES;
                self.playSlider.transform = CGAffineTransformMakeScale(1.0f,1.0f);
                self.playSliderBottom.constant = 2;
                [self.viewModel hanldeToSeekWithValue:self.playSlider.value];
                [self contentTransformWithAlpha:1.0 animation:YES];
                direction = UIPanGestureRecognizerDirectionUndefined;
                self.viewModel.isSeeking = NO;
                break;
            }
            default:
                break;
        }
}

- (NSString *)formatDateWithTimeinterval:(int)timenterval{
    int second = timenterval%60;//秒
    int minutes = timenterval/60;//分钟的。
    NSString *strTime = [NSString stringWithFormat:@"%02d:%02d",minutes,second];
    return strTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cellPrepareDisplayWithViewModel:(YCTVideoCellViewModel *)viewModel{
    _viewModel = viewModel;
    [self.videoCoverImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.coverImageUrl]];
    [self.avatarImageView loadImageGraduallyWithURL:[NSURL URLWithString:viewModel.avatarUrl] placeholderImageName:kDefaultAvatarImageName];
    [self.albumImage sd_setImageWithURL:[NSURL URLWithString:viewModel.albumImageUrl]];
    self.userName.text = viewModel.userName;
    NSLog(@"content:%@",viewModel.content);
    self.content.text = viewModel.content;
    self.musicName.text = viewModel.musicName;
    self.adress.text = viewModel.adress;
    self.musicBG.hidden = !YCT_IS_VALID_STRING(viewModel.musicName);
    self.adressBGView.hidden = !YCT_IS_VALID_STRING(viewModel.adress);

    RAC(self.likeLabel, text) = [RACObserve(viewModel, likeCount) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.likeView, selected) = [RACObserve(viewModel, islike) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.commentLabel, text) = [RACObserve(viewModel, commentCount) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.attentionButton, hidden) = [RACObserve(viewModel, beFocused) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.beFocused, hidden) = [[[RACSignal merge:@[RACObserve(viewModel, beFocused),RACObserve(viewModel, isSelf)]] takeUntil:self.rac_prepareForReuseSignal] map:^id _Nullable(id  _Nullable value) {
        return viewModel.isSelf ? @(YES) : @(!viewModel.beFocused);
    }];
    RAC(self.playSlider, value) = [RACObserve(viewModel, playProgress) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.playSlider, maximumValue) = [RACObserve(viewModel, progressMax) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.fullScreenButton, hidden) = [[RACObserve(viewModel, isHengping) takeUntil:self.rac_prepareForReuseSignal] map:^id _Nullable(id  _Nullable value) {
        return @(![value boolValue]);
    }];
    
    @weakify(self);
    [[RACObserve(viewModel, isPlaying) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.playButton.hidden = [x boolValue];
    }];
    
    [self.viewModel.loadingSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self showLoading:[x boolValue]];
    }];
    
//    self.viewModel.
 }

- (void)showLoading:(bool)show{
    if (show && self.loadingView.hidden) {
        self.loadingView.backgroundColor = UIColor.whiteColor;
        [self.loadingView setHidden:NO];
        [self.loadingView.layer removeAllAnimations];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.duration = 0.5;
        animationGroup.beginTime = CACurrentMediaTime() + 0.5;
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animation];
        scaleAnimation.keyPath = @"transform.scale.x";
        scaleAnimation.fromValue = @(1.0f);
        scaleAnimation.toValue = @(1.0f * Iphone_Width);
        
        CABasicAnimation * alphaAnimation = [CABasicAnimation animation];
        alphaAnimation.keyPath = @"opacity";
        alphaAnimation.fromValue = @(1.0f);
        alphaAnimation.toValue = @(0.5f);
        [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
        [self.loadingView.layer addAnimation:animationGroup forKey:nil];
        self.playSlider.hidden = YES;
    } else {
        [self.loadingView.layer removeAllAnimations];
        [self.loadingView setHidden:YES];
        self.playSlider.hidden = NO;
    }
}

- (void)contentTransformWithAlpha:(CGFloat)alpha animation:(BOOL)animation{
    if (animation) {
        [UIView animateWithDuration:0.25 animations:^{
            self.leftContainer.alpha = alpha;
            self.rightContainer.alpha = alpha;
        }];
    }else{
        self.leftContainer.alpha = alpha;
        self.rightContainer.alpha = alpha;
    }
}
- (void)contentTransformWhenDragging{
    [self contentTransformWithAlpha:0.5 animation:NO];
}

- (void)contentTransformWhenEndDragging{
    [self contentTransformWithAlpha:1.0 animation:NO];
}

- (IBAction)commentClickResponse:(UIButton *)sender {
    @weakify(self);
    [YCTNavigationCoordinator loginIfNeededWithAction:^{
        @strongify(self);
        [self responseChainWithEventName:k_even_comment_click userInfo:@{@"video_id":self.viewModel.videoModel.id,@"comment_count":@(self.viewModel.videoModel.commentNum),@"vm":self.viewModel}];
    }];
}

- (IBAction)avatarClickResponse:(UIButton *)sender {
    @weakify(self);
    [YCTNavigationCoordinator loginIfNeededWithAction:^{
        @strongify(self);
        [self responseChainWithEventName:k_even_avatar_click userInfo:@{@"user_id":self.viewModel.videoModel.userId}];
    }];
    
}

- (IBAction)shareClickResponse:(UIButton *)sender {
    @weakify(self);
    [YCTNavigationCoordinator loginIfNeededWithAction:^{
        @strongify(self);
        YCTShareView *view = [YCTShareView new];
        
        YCTShareType types = (YCTShareReport | YCTShareBlacklist | (self.viewModel.videoModel.isCollection ? YCTShareCollected : YCTShareCollect) | (self.viewModel.videoModel.isZan ? YCTShareLiked : YCTShareLike));
        if (self.viewModel.videoModel.allowSave) types |= YCTShareDownloadSave;
        if (self.viewModel.videoModel.allowShare) types |= YCTShareWeChatTimeLine | YCTShareWeChat | YCTShareUser | YCTSharePrivateMessage | YCTShareZalo;
        @weakify(self);
        [view setShareTypes:types shareBlock:^(YCTShareType shareType, YCTShareResultModel * _Nullable resultModel) {
            @strongify(self);
            switch (shareType) {
                case YCTShareDownloadSave:
                    [self.viewModel downloadAndSave];
                    break;
                case YCTShareUser: {
                    [resultModel.userIds enumerateObjectsUsingBlock:^(NSString * _Nonnull userId, NSUInteger idx, BOOL * _Nonnull stop) {
                        [YCTChatUtil sendVideoMsg:self.viewModel.videoModel.videoUrl thumbUrl:self.viewModel.videoModel.thumbUrl videoId:self.viewModel.videoModel.id videoUserId:self.viewModel.videoModel.userId videoNickName:self.viewModel.videoModel.nickName userId:userId remark:resultModel.note];
                    }];
                    [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedString(@"alert.sendSuccess")];
                }
                    break;
                case YCTShareWeChat:
                case YCTShareZalo:
                case YCTShareFB:
                case YCTShareWeChatTimeLine: {
                    YCTOpenPlatformType type = YCTOpenPlatformTypeZalo;
                    if (shareType == YCTShareWeChatTimeLine) {
                        type = YCTOpenPlatformTypeWeChatTimeLine;
                    } else if (shareType == YCTShareWeChat) {
                        type = YCTOpenPlatformTypeWeChatSession;
                    }else if (shareType == YCTShareFB) {
                        type = YCTOpenPlatformTypeFaceBook;
                    }
                    
                    YCTShareWebpageItem *webpageItem = [YCTShareWebpageItem new];
                    webpageItem.desc = self.viewModel.videoModel.title;
                    webpageItem.webpageUrl = [YCTWebviewURLProvider sharedVideoUrlWithId:self.viewModel.videoModel.id].absoluteString;
                    webpageItem.thumbImage = self.viewModel.videoModel.thumbUrl;
                    YCTOpenMessageObject *msg = [YCTOpenMessageObject new];
                    msg.shareObject = webpageItem;
                    [[YCTOpenPlatformManager defaultManager] sendMessage:msg toPlatform:type completion:^(BOOL isSuccess, NSString * _Nullable error) {
                        if (isSuccess) {
                            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedString(@"alert.shareSuccess")];
                        } else {
                            [[YCTHud sharedInstance] showDetailToastHud:YCTLocalizedString(@"alert.shareFailed")];
                        }
                    }];
                }
                    break;
                case YCTShareCollected:
                case YCTShareCollect:
                    [self.viewModel requestForCollection];
                    break;
                case YCTShareLike:
                case YCTShareLiked:
                    [self.viewModel requeustForZanVideo];
                    break;
                case YCTShareBlacklist: {
                    [UIView showAlertSheetWith:YCTLocalizedString(@"alert.addBlacklist") clickAction:^{
                        [self.viewModel requestForBlackList];
                    }];
                }
                    break;
                case YCTShareReport:{
                    YCTFeedBackViewController * report = [[YCTFeedBackViewController alloc] initWithReportType:YCTReportTypeVideo reportId:self.viewModel.videoModel.id];
                    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:report];
                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                    [[UIViewController currentViewController] presentViewController:nav animated:YES completion:nil];
                }
                    break;
                default:
                    break;
            }
        }];
        [view show];
    }];
    
}
- (IBAction)fullScreenResponse:(UIButton *)sender {
    [self responseChainWithEventName:@"k_even_video_fullScreen" userInfo:@{@"vm":self.viewModel}];
}

- (IBAction)moreClickResponse:(UIButton *)sender {
    YCTMoreBottomView *shareView = [[YCTMoreBottomView alloc] initWithIsColletion:self.viewModel.videoModel.isCollection];
    @weakify(self);
    shareView.clickBlock = ^(int buttonIndex) {
        @strongify(self);
        if (buttonIndex == 0) {
            @weakify(self);
            [self.viewModel requestFordeleteWithCompletion:^{
                @strongify(self);
                [self responseChainWithEventName:k_even_video_delete userInfo:@{}];
            }];
        }else if (buttonIndex == 1){
            [self.viewModel requestForCollection];
        }else{
            [self.viewModel downloadAndSave];
        }
    };
    [shareView yct_showWithTitle:YCTLocalizedString(@"share.MoreOperations")];
}
@end
