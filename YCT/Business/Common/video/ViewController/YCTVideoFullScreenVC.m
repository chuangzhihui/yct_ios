//
//  YCTVideoFullScreenVC.m
//  YCT
//
//  Created by hua-cloud on 2022/5/10.
//

#import "YCTVideoFullScreenVC.h"

#import "YCTVideoFullScreenVC.h"
@interface YCTVideoFullScreenVC ()<SJEdgeControlLayerDelegate>

@end

@implementation YCTVideoFullScreenVC
- (BOOL)shouldAutorotate {
    return  NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    self.player = SJVideoPlayer.player;
    self.player.automaticallyPerformRotationOrFitOnScreen = NO;
    [self.player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Full];
    [self.player.defaultEdgeControlLayer.topAdapter removeItemForTag:SJEdgeControlLayerTopItem_Back];
    [self.player.defaultEdgeControlLayer.topAdapter removeItemForTag:SJEdgeControlLayerTopItem_Title];
    [self.player.defaultEdgeControlLayer.topAdapter removeItemForTag:SJEdgeControlLayerTopItem_More];
    // 返回按钮
    // 全屏按钮
    SJEdgeControlButtonItem *backItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49x49 tag:SJEdgeControlLayerTopItem_Back];
    backItem.resetsAppearIntervalWhenPerformingItemAction = NO;
    [backItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(back)]];
    [self.player.defaultEdgeControlLayer.topAdapter addItem:backItem];
    
    SJEdgeControlButtonItem *fullItem = [SJEdgeControlButtonItem placeholderWithType:SJButtonItemPlaceholderType_49x49 tag:SJEdgeControlLayerBottomItem_Full];
    fullItem.resetsAppearIntervalWhenPerformingItemAction = NO;
    [fullItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(back)]];
    [self.player.defaultEdgeControlLayer.bottomAdapter addItem:fullItem];
    [self.player.defaultEdgeControlLayer.topAdapter reload];
    [self.view addSubview:self.player.view];
    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.left.right.offset(0);
        make.height.equalTo(self.player.view.mas_width).multipliedBy(9/16.0);
    }];

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        @strongify(self);
//        [self.player rotate:SJOrientation_LandscapeLeft animated:YES completion:^(__kindof SJBaseVideoPlayer * _Nonnull player) {
////            vc.view.hidden = NO;
//
//        }];
//    });
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_player vc_viewDidAppear];
    
    [self.player rotate:SJOrientation_LandscapeLeft animated:YES completion:NULL];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_player vc_viewDidDisappear];
}

//- (void)backItemWasTappedForControlLayer:(id<SJControlLayer>)controlLayer{
//    [self dismissViewControllerAnimated:YES completion:^{
//            
//    }];
//}

- (void)back{
    @weakify(self);
    [self.player rotate:SJOrientation_Portrait animated:YES completion:^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        @strongify(self);
        [self dismissViewControllerAnimated:NO completion:^{
            !self.dismissCallBack ? : self.dismissCallBack(self.player.currentTime);
        }];
    }];
}
@end
