//
//  YCTShareView.m
//  YCT
//
//  Created by 木木木 on 2021/12/18.
//

#import "YCTShareView.h"
#import "YCTShareContactListView.h"
#import "YCTShareHorizontalListView.h"
#import "YCTShareInputView.h"
#import "YCTShareFriendListView.h"
#import "YCTDragPresentView.h"
#import "YCTApiMyFriendsList.h"

@interface YCTShareView ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YCTShareContactListView *contactListView;
@property (nonatomic, strong) YCTShareHorizontalListView *shareView;
@property (nonatomic, strong) YCTShareHorizontalListView *operationView;
@property (nonatomic, strong) YCTShareInputView *inputView;

@property (nonatomic, assign) YCTShareType shareType;
@property (nonatomic, copy) void (^shareBlock)(YCTShareType shareType, YCTShareResultModel * _Nullable resultModel);

@property (nonatomic, copy) NSArray *shareArray;
@property (nonatomic, copy) NSArray *operationArray;

@end

@implementation YCTShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

kDeallocDebugTest

- (void)setupViews {
    self.backgroundColor = UIColor.whiteColor;
    
    self.titleLabel = ({
        UILabel *view = [[UILabel alloc] init];
        view.text = YCTLocalizedString(@"share.title");
        view.textColor = UIColor.mainTextColor;
        view.font = [UIFont PingFangSCBold:15];
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
    }];
    
    self.contactListView = [[YCTShareContactListView alloc] init];
    [self.contactListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(120).priorityHigh();
    }];
    
    self.shareView = [[YCTShareHorizontalListView alloc] init];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(110).priorityHigh();
    }];
    
    self.operationView = [[YCTShareHorizontalListView alloc] init];
    [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(110).priorityHigh();
    }];
    
    self.inputView = [[YCTShareInputView alloc] init];
    self.inputView.hidden = YES;
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(220).priorityHigh();
    }];
    
    [self.stackView addArrangedSubview:self.titleLabel];
    [self.stackView addArrangedSubview:self.contactListView];
    [self.stackView addArrangedSubview:self.shareView];
    [self.stackView addArrangedSubview:self.operationView];
    [self.stackView addArrangedSubview:self.inputView];
    
    [self addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    self.frame = CGRectMake(0, 0, Iphone_Width, 390 + YCTSafeBottom);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.layer.masksToBounds = YES;
    
    @weakify(self);
    self.contactListView.selectedIndexPathsChangeBlock = ^(NSArray<NSIndexPath *> * _Nullable selectedIndexPaths) {
        @strongify(self);
        [self contactSelectedIndexPathsChange:selectedIndexPaths];
    };
    
    [[self.inputView.sendButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.shareBlock) {
            YCTShareResultModel *model = [YCTShareResultModel new];
            model.userIds = self.contactListView.selectedUserIds;
            model.note = self.inputView.text;
            self.shareBlock(YCTShareUser, model);
        }
        [self dismissForDragPresent];
    }];
}

#pragma mark - Private

- (void)contactSelectedIndexPathsChange:(NSArray<NSIndexPath *> *)selectedIndexPaths {
    self.inputView.hidden = selectedIndexPaths.count == 0;
    self.shareView.hidden = selectedIndexPaths.count > 0;
    self.operationView.hidden = selectedIndexPaths.count > 0;
}

#pragma mark - Public

- (void)setShareTypes:(YCTShareType)shareType
           shareBlock:(void (^)(YCTShareType shareType, YCTShareResultModel *resultModel))shareBlock {
    _shareType = shareType;
    NSMutableArray *shares = @[].mutableCopy;
    NSMutableArray *operates = @[].mutableCopy;
    if (_shareType & YCTSharePrivateMessage) {
        YCTShareItem *item = [YCTShareItem new];
        item.shareType = YCTSharePrivateMessage;
        item.shareTitle = YCTLocalizedString(@"share.private");
        item.imageName = @"share_privateSend";
        [shares addObject:item];
    }
//    if (_shareType & YCTShareWeChatTimeLine) {
//        YCTShareItem *item = [YCTShareItem new];
//        item.shareType = YCTShareWeChatTimeLine;
//        item.shareTitle = YCTLocalizedString(@"share.friends");
//        item.imageName = @"share_wechat_friend";
//        [shares addObject:item];
//    }
//    if (_shareType & YCTShareWeChat) {
//        YCTShareItem *item = [YCTShareItem new];
//        item.shareType = YCTShareWeChat;
//        item.shareTitle = YCTLocalizedString(@"share.weChat");
//        item.imageName = @"share_wechat";
//        [shares addObject:item];
//    }
    if (_shareType & YCTShareZalo) {
        YCTShareItem *item = [YCTShareItem new];
        item.shareType = YCTShareZalo;
        item.shareTitle = YCTLocalizedString(@"share.zalo");
        item.imageName = @"share_zalo";
        [shares addObject:item];
    }
    YCTShareItem *item = [YCTShareItem new];
    item.shareType = YCTShareFB;
    item.shareTitle = @"FaceBook";
    item.imageName = @"facebook";
    [shares addObject:item];
    if (_shareType & YCTShareDownloadSave) {
        YCTShareItem *item = [YCTShareItem new];
        item.shareType = YCTShareDownloadSave;
        item.shareTitle = YCTLocalizedString(@"share.save");
        item.imageName = @"share_download";
        [operates addObject:item];
    }
    if (_shareType & YCTShareCollect) {
        YCTShareItem *item = [YCTShareItem new];
        item.shareType = YCTShareCollect;
        item.shareTitle = YCTLocalizedString(@"share.collect");
        item.imageName = @"share_collect";
        [operates addObject:item];
    }
    if (_shareType & YCTShareCollected) {
        YCTShareItem *item = [YCTShareItem new];
        item.shareType = YCTShareCollected;
        item.shareTitle = YCTLocalizedString(@"share.collected");
        item.imageName = @"share_collected";
        [operates addObject:item];
    }
    if (_shareType & YCTShareReport) {
        YCTShareItem *item = [YCTShareItem new];
        item.shareType = YCTShareReport;
        item.shareTitle = YCTLocalizedString(@"share.report");
        item.imageName = @"share_report";
        [operates addObject:item];
    }
    if (_shareType & YCTShareLike) {
        YCTShareItem *item = [YCTShareItem new];
        item.shareType = YCTShareLike;
        item.shareTitle = YCTLocalizedString(@"share.like");
        item.imageName = @"share_like";
        [operates addObject:item];
    }
    if (_shareType & YCTShareLiked) {
        YCTShareItem *item = [YCTShareItem new];
        item.shareType = YCTShareLiked;
        item.shareTitle = YCTLocalizedString(@"share.liked");
        item.imageName = @"share_liked";
        [operates addObject:item];
    }
    if (_shareType & YCTShareDislike) {
        YCTShareItem *item = [YCTShareItem new];
        item.shareType = YCTShareDislike;
        item.shareTitle = YCTLocalizedString(@"share.dislike");
        item.imageName = @"share_dislike";
        [operates addObject:item];
    }
    if (_shareType & YCTShareBlacklist) {
        YCTShareItem *item = [YCTShareItem new];
        item.shareType = YCTShareBlacklist;
        item.shareTitle = YCTLocalizedString(@"share.blacklist");
        item.imageName = @"share_blacklist";
        [operates addObject:item];
    }
    if (_shareType & YCTShareRemark) {
        YCTShareItem *item = [YCTShareItem new];
        item.shareType = YCTShareRemark;
        item.shareTitle = YCTLocalizedString(@"share.remark");
        item.imageName = @"share_edit";
        [operates addObject:item];
    }
    
    self.shareArray = shares.copy;
    self.operationArray = operates.copy;
    
    self.shareBlock = shareBlock;
    
    @weakify(self);
    [self.shareView configItems:self.shareArray clickBlock:^(NSUInteger shareType) {
        @strongify(self);
        [self dismissForDragPresentWithCompletion:^{
            if (shareType == YCTSharePrivateMessage) {
                [self showShareFriendList];
            }
            else if (self.shareBlock) {
                self.shareBlock(shareType, nil);
            }
        }];
    }];

    [self.operationView configItems:self.operationArray clickBlock:^(NSUInteger shareType) {
        @strongify(self);
        [self dismissForDragPresentWithCompletion:^{
            if (shareType == YCTSharePrivateMessage) {
                [self showShareFriendList];
            }
            else if (self.shareBlock) {
                self.shareBlock(shareType, nil);
            }
        }];
    }];
    
    CGFloat height = 390 + YCTSafeBottom;
//    if (!(_shareType & YCTShareUser)) {
//        self.contactListView.hidden = YES;
//        height -= 120;
//    }
    
    if (self.shareArray.count == 0) {
        self.shareView.hidden = YES;
        height -= 110;
    }
    
    if (self.operationArray.count == 0) {
        self.operationView.hidden = YES;
        height -= 110;
    }
    
    self.frame = CGRectMake(0, 0, Iphone_Width, height);
}

- (void)showShareFriendList {
    YCTShareFriendListView *view = [[YCTShareFriendListView alloc] initWithShareBlock:self.shareBlock];
    [[YCTDragPresentView sharePresentView] showView:view];
}

- (void)show {
    void (^completion)(NSArray<YCTChatFriendModel *> *models) = ^(NSArray<YCTChatFriendModel *> *models) {
        
        if (models.count > 0) {
            self.contactListView.models = models;
        } else {
            self.contactListView.hidden = YES;
            self.frame = CGRectMake(0, 0, Iphone_Width, self.frame.size.height - 120);
        }
        
        [[YCTDragPresentView sharePresentView] showView:self configMaker:^(YCTDragPresentConfig * config) {
            config.ignoreViewHeight = NO;
            config.ignoreScrollGestureHandle = YES;
        }];
    };
    
    if ((_shareType & YCTShareUser)) {
        [[YCTHud sharedInstance] showLoadingHud];
        YCTApiMyFriendsList *api = [[YCTApiMyFriendsList alloc] init];
        api.page = 1;
        api.size = 20;
        [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
            [[YCTHud sharedInstance] hideHud];
            completion(request.responseDataModel);
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [[YCTHud sharedInstance] hideHud];
            completion(nil);
        }];
    } else {
        completion(nil);
    }
    
}

#pragma mark - Getter

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.backgroundColor = UIColor.whiteColor;
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _stackView;
}

@end
