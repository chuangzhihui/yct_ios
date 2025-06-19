//
//  YCTUGCWrapper.m
//  YCT
//
//  Created by hua-cloud on 2022/1/5.
//

#import "YCTUGCWrapper.h"
#import <UGCKit/UGCKit.h>
#import "YCTRootViewController.h"
#import "YCTPublishViewController.h"
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>

#import "YCT-Swift.h"

@interface YCTUGCWrapper ()
@property (nonatomic, copy) NSString * editingBgmId;
@end
@implementation YCTUGCWrapper

- (void)setEdtingBgmId:(NSString *)bgmId{
    _editingBgmId = bgmId;
}

- (NSString *)getEditingBgmId{
    return self.editingBgmId;
}
#pragma mark - record
- (void)recordPublish{
    UGCKitRecordConfig *config = [[UGCKitRecordConfig alloc] init];
    config.recoverDraft = YES;
    config.maxDuration = 60;
    UGCKitRecordViewController *videoRecord = [[UGCKitRecordViewController alloc] initWithConfig:config theme:[UGCKitTheme sharedTheme]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:videoRecord];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    @weakify(self,nav);
    videoRecord.completion = ^(UGCKitResult *result) {
        @strongify(self,nav);
        if (result.code == 0 && !result.cancelled) {
            [self showEditViewController:result rotation:TCEditRotation0 inNavigationController:nav];
        } else {
            [nav dismissViewControllerAnimated:YES completion:nil];
        }
    };
    videoRecord.videoRoPhotoCompletion = ^(NSInteger touchType) {
        @strongify(self);
        if (self.onVideoRoPhotoClick) {
            self.onVideoRoPhotoClick(touchType);
        }
    };
    YCTRootViewController * vc = (YCTRootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [vc presentViewController:nav animated:YES completion:nil];
}


#pragma mark - selelctedVideo
-(void)videoPublish
{
    UGCKitMediaPickerConfig *config = [[UGCKitMediaPickerConfig alloc] init];
    config.mediaType = UGCKitMediaTypeVideo;
    config.maxItemCount = NSIntegerMax;
    UGCKitMediaPickerViewController *imagePickerController = [[UGCKitMediaPickerViewController alloc] initWithConfig:config theme:[UGCKitTheme sharedTheme]];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    @weakify(self);
    imagePickerController.completion = ^(UGCKitResult *result) {
        @strongify(self);
        if (!result.cancelled && result.code == 0) {
            [self _showVideoCutView:result inNavigationController:nav];
        } else {
            [nav dismissViewControllerAnimated:YES completion:^{
                if (!result.cancelled) {
                    [[YCTHud sharedInstance] showFailedHud:result.info[NSLocalizedDescriptionKey]];
                }
            }];
        }
    };
    
    imagePickerController.onButtonClick = ^{
        if (self.onButtonClick) {
            self.onButtonClick();
        }
    };
    YCTRootViewController * vc = (YCTRootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [vc presentViewController:nav animated:YES completion:nil];
}
- (void)videoPublish:(UIViewController *)suprVc
{
    UGCKitMediaPickerConfig *config = [[UGCKitMediaPickerConfig alloc] init];
    config.mediaType = UGCKitMediaTypeVideo;
    config.maxItemCount = NSIntegerMax;
    UGCKitMediaPickerViewController *imagePickerController = [[UGCKitMediaPickerViewController alloc] initWithConfig:config theme:[UGCKitTheme sharedTheme]];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    @weakify(self);
    imagePickerController.completion = ^(UGCKitResult *result) {
        @strongify(self);
        if (!result.cancelled && result.code == 0) {
            [self _showVideoCutView:result inNavigationController:nav];
        } else {
            [nav dismissViewControllerAnimated:YES completion:^{
                if (!result.cancelled) {
                    [[YCTHud sharedInstance] showFailedHud:result.info[NSLocalizedDescriptionKey]];
                }
            }];
        }
    };
    
    imagePickerController.onButtonClick = ^{
        if (self.onButtonClick) {
            self.onButtonClick();
        }
    };
    [suprVc presentViewController:nav animated:YES completion:nil];
}




#pragma mark - selelctedPic
-(void)picturePublish
{
    UGCKitMediaPickerConfig *config = [[UGCKitMediaPickerConfig alloc] init];
    config.mediaType = UGCKitMediaTypePhoto;
    config.minItemCount = 3;
    config.maxItemCount = NSIntegerMax;
    UGCKitMediaPickerViewController *imagePickerController = [[UGCKitMediaPickerViewController alloc] initWithConfig:config theme:[UGCKitTheme sharedTheme]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    @weakify(self);
    imagePickerController.completion = ^(UGCKitResult *result) {
        @strongify(self);
        if (!result.cancelled && result.code == 0) {
            [self _showVideoCutView:result inNavigationController:nav];
        } else {
            [nav dismissViewControllerAnimated:YES completion:^{
                if (!result.cancelled) {
                    [[YCTHud sharedInstance] showFailedHud:result.info[NSLocalizedDescriptionKey]];
                }
            }];
        }
    };
    YCTRootViewController * vc = (YCTRootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    [vc presentViewController:nav animated:YES completion:nil];
}
-(void)picturePublish:(UIViewController *)suprVc
{
    UGCKitMediaPickerConfig *config = [[UGCKitMediaPickerConfig alloc] init];
    config.mediaType = UGCKitMediaTypePhoto;
    config.minItemCount = 3;
    config.maxItemCount = NSIntegerMax;
    UGCKitMediaPickerViewController *imagePickerController = [[UGCKitMediaPickerViewController alloc] initWithConfig:config theme:[UGCKitTheme sharedTheme]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    @weakify(self);
    imagePickerController.completion = ^(UGCKitResult *result) {
        @strongify(self);
        if (!result.cancelled && result.code == 0) {
            [self _showVideoCutView:result inNavigationController:nav];
        } else {
            [nav dismissViewControllerAnimated:YES completion:^{
                if (!result.cancelled) {
                    [[YCTHud sharedInstance] showFailedHud:result.info[NSLocalizedDescriptionKey]];
                }
            }];
        }
    };
    [suprVc presentViewController:nav animated:YES completion:nil];
}

#pragma mark - create Live
-(void)createLive
{
    YCTRootViewController * rootVC = (YCTRootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;

    YCTSettingLiveRoomViewModel *settingLiveRoomVM = [[YCTSettingLiveRoomViewModel alloc] initWithLiveStreamManager: LiveStreamManager.shared];
    YCTSettingLiveRoomViewController *settingLiveRoomVC = [[YCTSettingLiveRoomViewController alloc] initWithViewModel:settingLiveRoomVM];
    settingLiveRoomVC.hidesBottomBarWhenPushed = YES;
    [rootVC.selectedViewController pushViewController:settingLiveRoomVC animated:true];

    [settingLiveRoomVC didCreateLiveStreamWithCallback:^(NSString * liveEventId) {
        NSLog(@"Thong LiveEventId ", liveEventId);
        
        YCTLiveRoomHostViewModel *liveRoomHostVM = [[YCTLiveRoomHostViewModel alloc] initWithLiveStreamManager: LiveStreamManager.shared liveEventId:liveEventId];
        YCTLiveRoomHostViewController *liveRoomHostVC = [[YCTLiveRoomHostViewController alloc] initWithViewModel:liveRoomHostVM];
        liveRoomHostVC.hidesBottomBarWhenPushed = YES;
        [rootVC.selectedViewController pushViewController:liveRoomHostVC animated:true];
    }];


//    YCTLiveRoomHostViewModel *liveRoomHostVM = [[YCTLiveRoomHostViewModel alloc] initWithLiveStreamManager: LiveStreamManager.shared liveEventId:@"7f605c5f-daeb-41d3-9082-2e51032dca30"];
//    YCTLiveRoomHostViewController *liveRoomHostVC = [[YCTLiveRoomHostViewController alloc] initWithViewModel:liveRoomHostVM];
//    liveRoomHostVC.hidesBottomBarWhenPushed = YES;
//    [rootVC.selectedViewController pushViewController:liveRoomHostVC animated:true];
}
-(void)createLive:(UIViewController *)suprVc
{
    YCTRootViewController * rootVC = (YCTRootViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;

    YCTSettingLiveRoomViewModel *settingLiveRoomVM = [[YCTSettingLiveRoomViewModel alloc] initWithLiveStreamManager: LiveStreamManager.shared];
    YCTSettingLiveRoomViewController *settingLiveRoomVC = [[YCTSettingLiveRoomViewController alloc] initWithViewModel:settingLiveRoomVM];
    settingLiveRoomVC.hidesBottomBarWhenPushed = YES;
    [suprVc.navigationController pushViewController:settingLiveRoomVC animated:true];

    [settingLiveRoomVC didCreateLiveStreamWithCallback:^(NSString * liveEventId) {
        NSLog(@"Thong LiveEventId ", liveEventId);
        
        YCTLiveRoomHostViewModel *liveRoomHostVM = [[YCTLiveRoomHostViewModel alloc] initWithLiveStreamManager: LiveStreamManager.shared liveEventId:liveEventId];
        YCTLiveRoomHostViewController *liveRoomHostVC = [[YCTLiveRoomHostViewController alloc] initWithViewModel:liveRoomHostVM];
        liveRoomHostVC.hidesBottomBarWhenPushed = YES;
        [suprVc.navigationController pushViewController:liveRoomHostVC animated:true];
    }];
}

- (void)_showVideoCutView:(UGCKitResult *)result inNavigationController:(UINavigationController *)nav {
    UGCKitCutViewController *vc = [[UGCKitCutViewController alloc] initWithMedia:result.media theme:[UGCKitTheme sharedTheme]];
    @weakify(self);
    vc.completion = ^(UGCKitResult *result, int rotation) {
        @strongify(self);
        if ([result isCancelled]) {
            [nav dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self showEditViewController:result rotation:TCEditRotation0 inNavigationController:nav];
        }
    };
    [nav pushViewController:vc animated:YES];
}


- (void)showEditViewController:(UGCKitResult *)result
                      rotation:(TCEditRotation)rotation
        inNavigationController:(UINavigationController *)nav{
    UGCKitMedia *media = result.media;
    UGCKitEditConfig *config = [[UGCKitEditConfig alloc] init];
    config.rotation = (TCEditRotation)(rotation / 90);

    UIImage *tailWatermarkImage = [UIImage imageNamed:@"tcloud_logo"];
    TXVideoInfo *info = [TXVideoInfoReader getVideoInfoWithAsset:media.videoAsset];
    float w = 0.15;
    float x = (1.0 - w) / 2.0;
    float width = w * info.width;
    float height = width * tailWatermarkImage.size.height / tailWatermarkImage.size.width;
    float y = (info.height - height) / 2 / info.height;
    config.tailWatermark = [UGCKitWatermark watermarkWithImage:tailWatermarkImage
                                                     frame:CGRectMake(x, y, w, 0)
                                                  duration:2];
    UGCKitEditViewController *vc = [[UGCKitEditViewController alloc] initWithMedia:media
                                                                            config:config
                                                                             theme:[UGCKitTheme sharedTheme]];
    
    vc.onTapNextButton = ^(void (^finish)(BOOL)) {
        finish(YES);
    };

    vc.completion = ^(UGCKitResult *result) {
        if (result.cancelled) {
            [nav popViewControllerAnimated:YES];
        } else {
            YCTPublishViewController * publish = [[YCTPublishViewController alloc] initWithUGCKitResult:result];
            NSMutableArray * viewControllers = nav.viewControllers.mutableCopy;
            [viewControllers removeAllObjects];
            [viewControllers addObject:publish];
            [nav setViewControllers:viewControllers.copy animated:YES];
        }
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CACHE_PATH_LIST];
    };
    [nav pushViewController:vc animated:YES];
}
YCT_SINGLETON_IMP
@end
