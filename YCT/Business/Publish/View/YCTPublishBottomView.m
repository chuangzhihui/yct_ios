//
//  YCTPublishBottomView.m
//  YCT
//
//  Created by hua-cloud on 2021/12/31.
//

#import "YCTPublishBottomView.h"
#import "YCTVerticalButton.h"
#import "YCTUGCWrapper.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UIViewControllerCJHelper.h"
#import "UIWindow+Common.h"
#define kButtonWidth 100
#define kButtonHeight 80

@interface YCTPublishBottomView ()
@property (strong,nonatomic) UIView * titleView;
@property (strong,nonatomic) UILabel *title;
@property (strong,nonatomic) UISegmentedControl *radioGroup;
@property (strong, nonatomic) YCTVerticalButton *videoButton;
@property (strong, nonatomic) YCTVerticalButton *photoButton;
@property (strong, nonatomic) YCTVerticalButton *pictureButton;
@property (strong, nonatomic) YCTVerticalButton *liveButton;
@property (strong, nonatomic) UIButton *okBtn;
@property (nonatomic, assign) BOOL isAuthenticated; // Property
@property (nonatomic, assign) BOOL close; // Property
@property int  type;//默认为企业
@end
@implementation YCTPublishBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    @weakify(self);
    self.type=1;
    self.isAuthenticated = NO;
    self.titleView=[[UIView alloc] init];
//    self.titleView.backgroundColor=[UIColor redColor];
    [self addSubview:self.titleView];
    
    self.title=[[UILabel alloc] init];
    self.title.text=YCTLocalizedTableString(@"publish.choose_title", @"Publish");
    [self.titleView addSubview:self.title];
    self.radioGroup=[[UISegmentedControl alloc] initWithItems:@[YCTLocalizedTableString(@"publish.choose_business", @"Publish"), YCTLocalizedTableString(@"publish.choose_personal", @"Publish")]];
    [self.titleView addSubview:self.radioGroup];
    self.radioGroup.selectedSegmentIndex=0;
    [self.radioGroup addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(15);
        make.height.equalTo(@80);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleView.mas_left);
        make.top.equalTo(self.titleView.mas_top);
    }];
    [self.radioGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(15);
        make.left.equalTo(self.titleView.mas_left);
        make.size.sizeOffset(CGSizeMake(250, 50));
    }];
    
//    [self addSubview:self.okBtn];
//    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.radioGroup.mas_bottom).offset(25);
//        make.left.equalTo(self.titleView.mas_left);
//        make.right.mas_equalTo(-15);
//        make.height.mas_equalTo(40);
//    }];
    
    self.videoButton = [self buttonWithTitle:@"publish.video" imageName:@"publish_video"];
//    self.videoButton.hidden = true;
    [self addSubview:self.videoButton];
    [[self.videoButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickAtIndex:0];
    }];
    
    self.photoButton = [self buttonWithTitle:@"publish.shot" imageName:@"publish_take_photo"];
//    self.photoButton.hidden = true;
    [self addSubview:self.photoButton];
    [[self.photoButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickAtIndex:1];
    }];
    
    self.pictureButton = [self buttonWithTitle:@"publish.pic" imageName:@"publish_photo"];
//    self.pictureButton.hidden = true;
    [self addSubview:self.pictureButton];
    [[self.pictureButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickAtIndex:2];
    }];
    
    self.liveButton = [self buttonWithTitle:@"publish.live" imageName:@"publish_live"];
//    self.liveButton.hidden = true;
    [self addSubview:self.liveButton];
    [[self.liveButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        [self buttonClickAtIndex:3];
    }];
    
    CGFloat top = 119;
    CGFloat buttonCount = 4;
    CGFloat padding = 8;
    CGFloat margin = ceil((Iphone_Width - kButtonWidth * buttonCount - padding * 2) / (buttonCount + 1)) + padding;
    self.videoButton.frame = CGRectMake(margin, top, kButtonWidth, kButtonHeight);
    self.photoButton.frame = CGRectMake(CGRectGetMaxX(self.videoButton.frame) + margin - padding, top, kButtonWidth, kButtonHeight);
    self.pictureButton.frame = CGRectMake(CGRectGetMaxX(self.photoButton.frame) + margin - padding, top, kButtonWidth, kButtonHeight);
    self.liveButton.frame = CGRectMake(CGRectGetMaxX(self.pictureButton.frame) + margin - padding, top, kButtonWidth, kButtonHeight);
    
    
    self.bounds = (CGRect){0, 0, Iphone_Width, 230};
//    self.bounds = (CGRect){0, 0, Iphone_Width, 170};
}
- (void)segmentChanged:(UISegmentedControl *)sender {
    NSLog(@"选中的段索引: %ld", (long)sender.selectedSegmentIndex);
    // 根据选中的段执行不同的操作
    switch (sender.selectedSegmentIndex) {
        case 0:
            NSLog(@"选择了选项1");
            self.type=1;
//            self.liveButton.hidden=NO;
            break;
        case 1:
            NSLog(@"选择了选项2");
            self.type=2;
//            self.liveButton.hidden=YES;
            break;
        default:
            break;
    }
}
- (void)buttonClickAtIndex:(int)index {
    
    // Check if vendor info needs to be completed (authentication)
    self.close=YES;
    [YCTNavigationCoordinator checkIfNeededCompleteVendorInfoWithNav:(UINavigationController *)self.inputViewController
                                                               index:index
                                                           user_type:self.type
                                                        alertContent:YCTLocalizedString(@"alert.publishVideoNeedAuth")
                                                              action:^{
        NSLog(@"111111");
        self.isAuthenticated = YES;
       
        UIViewController *rootView = [UIViewControllerCJHelper findCurrentShowingViewController];
        
        if (index == 3) {
            // Live stream
           
        } else if(index!=1){
            PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];//相册权限
            if(photoAuthorStatus==PHAuthorizationStatusDenied){
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:YCTLocalizedTableString(@"mine.scan.tipsPhoto", @"Mine") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelaction = [UIAlertAction actionWithTitle:YCTLocalizedString(@"lbs.cancel") style:UIAlertActionStyleDefault handler:NULL];
                [alert addAction:cancelaction];
                
                UIAlertAction * setaction = [UIAlertAction actionWithTitle:YCTLocalizedString(@"lbs.goset") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:nil completionHandler:^{
//                        
//                    }];
                }];
                [alert addAction:setaction];
                
                [rootView presentViewController:alert animated:YES completion:nil];
                self.isAuthenticated = NO;
                self.close=NO;
                return;
            }
        }else{
            //检查权限
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            AVAuthorizationStatus authStatus1 = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
            if(authStatus==AVAuthorizationStatusDenied || authStatus==AVAuthorizationStatusRestricted){
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:YCTLocalizedTableString(@"mine.scan.tipsCamera", @"Mine") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelaction = [UIAlertAction actionWithTitle:YCTLocalizedString(@"lbs.cancel") style:UIAlertActionStyleDefault handler:NULL];
                [alert addAction:cancelaction];
                
                UIAlertAction * setaction = [UIAlertAction actionWithTitle:YCTLocalizedString(@"lbs.goset") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }];
                [alert addAction:setaction];
                
                [rootView presentViewController:alert animated:YES completion:nil];
                self.isAuthenticated = NO;
                self.close=NO;
                return;
            }
            if(authStatus1==AVAuthorizationStatusDenied || authStatus1==AVAuthorizationStatusRestricted){
                //没有麦克风
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:YCTLocalizedTableString(@"mine.scan.tipsAudio", @"Mine") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelaction = [UIAlertAction actionWithTitle:YCTLocalizedString(@"lbs.cancel") style:UIAlertActionStyleDefault handler:NULL];
                [alert addAction:cancelaction];
                
                UIAlertAction * setaction = [UIAlertAction actionWithTitle:YCTLocalizedString(@"lbs.goset") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }];
                [alert addAction:setaction];
                
                [rootView presentViewController:alert animated:YES completion:nil];
                self.isAuthenticated = NO;
                self.close=NO;
                return;
            }
        }
    } profileAction:^ {
        [self yct_closeWithCompletion:^{}];
        if (self.moveToProfileAdd) {
            self.moveToProfileAdd();
        }
    }];
//    if (self.isAuthenticated==false) { //测试录制
    NSLog(@"22222");
    if (self.isAuthenticated) {
        [self yct_closeWithCompletion:^{
            if (index == 0) {
                [[YCTUGCWrapper sharedInstance] videoPublish];
            }else if (index == 1){
                [[YCTUGCWrapper sharedInstance] recordPublish];
            }else if (index == 2){
                [[YCTUGCWrapper sharedInstance] picturePublish];
            }else {
                [[YCTUGCWrapper sharedInstance] createLive];
            }
            
            YCTUGCWrapper *ugcWrapper = [YCTUGCWrapper sharedInstance];
            ugcWrapper.onButtonClick = ^{
                if (self.onButtonClick) {
                    self.onButtonClick();
                }
            };
            ugcWrapper.onVideoRoPhotoClick = ^(NSInteger touchType) {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self buttonClickAtIndex:(int)touchType];
                });
            };
            
        }];
    } else {
        NSLog(@"33333");
        if(self.close)
        {
            [self yct_closeWithCompletion:^{}];
        }
       
    }
        
}

- (void)okBtnTouch {
    [self buttonClickAtIndex:1];
}

#pragma mark - Getter
- (YCTVerticalButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    YCTVerticalButton *view = [YCTVerticalButton buttonWithType:(UIButtonTypeSystem)];
    view.titleLabel.font = [UIFont PingFangSCMedium:12];
    [view setTitleColor:UIColor.mainTextColor forState:(UIControlStateNormal)];
    [view configTitle:YCTLocalizedTableString(title, @"Publish") imageName:imageName];
    view.spacing = 10;
    return view;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:YCTLocalizedString(@"action.confirm") forState:(UIControlStateNormal)];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)];
        [btn setBackgroundColor:UIColor.mainThemeColor];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = true;
        [btn addTarget:self action:@selector(okBtnTouch) forControlEvents:(UIControlEventTouchUpInside)];
        _okBtn = btn;
    }
    return _okBtn;
}
@end
