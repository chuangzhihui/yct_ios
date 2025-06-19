//
//  UGCKitRecordViewController+bgm.m
//  YCT
//
//  Created by hua-cloud on 2022/1/6.
//

#import "UGCKitRecordViewController+bgm.h"
#import "YCTUGCWrapper.h"
@implementation UGCKitRecordViewController (bgm)
+(void)load{
    Method onBtnMusicStoped = class_getInstanceMethod(self.class, NSSelectorFromString(@"onBtnMusicStoped"));
    Method yct_onBtnMusicStoped = class_getInstanceMethod(self.class, @selector(yct_onBtnMusicStoped));
    method_exchangeImplementations(onBtnMusicStoped, yct_onBtnMusicStoped);
    
    Method onBGMControllerPlay = class_getInstanceMethod(self.class, NSSelectorFromString(@"onBGMControllerPlay:bgmId:"));
    Method yct_onBGMControllerPlay = class_getInstanceMethod(self.class, @selector(yct_onBGMControllerPlay:bgmId:));
    method_exchangeImplementations(onBGMControllerPlay, yct_onBGMControllerPlay);
    
    
    
//    Method showLiveBtnTouch = class_getInstanceMethod(self.class, NSSelectorFromString(@"showLiveBtnTouch"));
//    Method yct_showLiveBtnTouch = class_getInstanceMethod(self.class, @selector(yct_showLiveBtnTouch));
//    method_exchangeImplementations(showLiveBtnTouch, yct_showLiveBtnTouch);
//    
//    Method showShootBtnTouch = class_getInstanceMethod(self.class, NSSelectorFromString(@"showShootBtnTouch"));
//    Method yct_showShootBtnTouch = class_getInstanceMethod(self.class, @selector(yct_showShootBtnTouch));
//    method_exchangeImplementations(showShootBtnTouch, yct_showShootBtnTouch);
//    
//    Method videoVwTapTouch = class_getInstanceMethod(self.class, NSSelectorFromString(@"videoVwTapTouch"));
//    Method yct_videoVwTapTouch = class_getInstanceMethod(self.class, @selector(yct_videoVwTapTouch));
//    method_exchangeImplementations(videoVwTapTouch, yct_videoVwTapTouch);
//    
//    Method photoVwTapTouch = class_getInstanceMethod(self.class, NSSelectorFromString(@"photoVwTapTouch"));
//    Method yct_photoVwTapTouch = class_getInstanceMethod(self.class, @selector(yct_photoVwTapTouch));
//    method_exchangeImplementations(photoVwTapTouch, yct_photoVwTapTouch);
}

- (void)yct_onBtnMusicStoped{
    [self yct_onBtnMusicStoped];
    [[YCTUGCWrapper sharedInstance] setEdtingBgmId:nil];
}

- (void)yct_onBGMControllerPlay:(NSObject*)path bgmId:(NSString *)Id{
    [self yct_onBGMControllerPlay:path bgmId:Id];
    [[YCTUGCWrapper sharedInstance] setEdtingBgmId:Id];
}


//if (index == 0) {
//    [[YCTUGCWrapper sharedInstance] videoPublish];
//}else if (index == 1){
//    [[YCTUGCWrapper sharedInstance] recordPublish];
//}else if (index == 2){
//    [[YCTUGCWrapper sharedInstance] picturePublish];
//}else {
//    [[YCTUGCWrapper sharedInstance] createLive];
//}
- (void)yct_showLiveBtnTouch {
    [[YCTUGCWrapper sharedInstance] createLive:self];
}

- (void)yct_showShootBtnTouch {
    
}

- (void)yct_videoVwTapTouch {
    [[YCTUGCWrapper sharedInstance] videoPublish:self];
}

- (void)yct_photoVwTapTouch {
    [[YCTUGCWrapper sharedInstance] picturePublish:self];
}

@end
