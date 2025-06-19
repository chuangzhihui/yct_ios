//
//  UGCKitEditViewController+bgm.m
//  YCT
//
//  Created by hua-cloud on 2022/1/6.
//

#import "UGCKitEditViewController+bgm.h"
#import "YCTUGCWrapper.h"
@implementation UGCKitEditViewController (bgm)
+(void)load{
    Method onBtnMusicStoped = class_getInstanceMethod(self.class, NSSelectorFromString(@"onBtnMusicStoped"));
    Method yct_onBtnMusicStoped = class_getInstanceMethod(self.class, @selector(yct_onBtnMusicStoped));
    method_exchangeImplementations(onBtnMusicStoped, yct_onBtnMusicStoped);
    
    Method onBGMControllerPlay = class_getInstanceMethod(self.class, NSSelectorFromString(@"onBGMControllerPlay:bgmId:"));
    Method yct_onBGMControllerPlay = class_getInstanceMethod(self.class, @selector(yct_onBGMControllerPlay:bgmId:));
    method_exchangeImplementations(onBGMControllerPlay, yct_onBGMControllerPlay);
}

- (void)yct_onBtnMusicStoped{
    [self yct_onBtnMusicStoped];
    [[YCTUGCWrapper sharedInstance] setEdtingBgmId:nil];
}

- (void)yct_onBGMControllerPlay:(NSObject*)path bgmId:(NSString *)Id{
    [self yct_onBGMControllerPlay:path bgmId:Id];
    [[YCTUGCWrapper sharedInstance] setEdtingBgmId:Id];
}
@end
