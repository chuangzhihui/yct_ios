//
//  YCTResizeImageViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/24.
//

#import "YCTResizeImageViewController.h"
#import <JPImageresizerView/JPImageresizerView.h>
#import <JPBasic/JPConstant.h>
#import <JPBasic/JPProgressHUD.h>

#define JPMargin 16.0

@interface YCTResizeImageViewController ()

@property (strong, nonatomic) JPImageresizerView *imageresizerView;

@end

@implementation YCTResizeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupImageresizerView];
    [self setupBase];
    
    [self.imageresizerView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

- (void)setupBase {
//    self.view.layer.backgroundColor = UIColor.clearColor.CGColor;
    self.view.backgroundColor = self.configure.bgColor;
    
    if (@available(iOS 11.0, *)) {
        
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
}

- (void)setupImageresizerView {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(JPMargin, JPMargin, JPMargin, JPMargin);
    contentInsets.top += JPStatusBarH ;
    contentInsets.bottom += 15 + (JPis_iphoneX ? JPDiffTabBarH : JPStatusBarH);
    self.configure.contentInsets = contentInsets;
    self.configure.viewFrame = [UIScreen mainScreen].bounds;
    
    @weakify(self);
    JPImageresizerView *imageresizerView = [JPImageresizerView imageresizerViewWithConfigure:self.configure imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        @strongify(self);
        if (!self) return;
        
    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        @strongify(self);
        if (!self) return;
        // 当预备缩放设置按钮不可点，结束后可点击
//        BOOL enabled = !isPrepareToScale;
        
    }];
    [self.view insertSubview:imageresizerView atIndex:0];
    self.imageresizerView = imageresizerView;
    
    self.imageresizerView.borderImage = nil;
    self.imageresizerView.frameType = JPClassicFrameType;
    self.imageresizerView.isShowGridlinesWhenIdle = NO;
    self.imageresizerView.isShowGridlinesWhenDragging = YES;
    self.imageresizerView.isArbitrarily = NO;
    self.imageresizerView.isLockResizeFrame = YES;
//    self.imageresizerView.blurEffect = nil;
}

- (BOOL)naviagtionBarHidden {
    return YES;
}

@end
