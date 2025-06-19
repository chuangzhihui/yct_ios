//
//  YCTHud.m
//  YCT
//
//  Created by 木木木 on 2021/12/26.
//

#import "YCTHud.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (YCTCustom)

- (void)showLoadingHud:(NSString * _Nullable)text;

- (void)showToastHudWithText:(NSString * _Nullable)text
                  detailText:(NSString * _Nullable)detail;

- (void)showImageHud:(UIImage *)image text:(NSString *)text;

@end

@implementation MBProgressHUD (YCTCustom)

- (void)resetHud {
    self.square = NO;
    self.label.text = nil;
    self.detailsLabel.text = nil;
    self.label.font = [UIFont PingFangSCBold:16];
    self.detailsLabel.font = [UIFont PingFangSCMedium:15];
}

- (void)showLoadingHud:(NSString * _Nullable)text {
    [self resetHud];
    self.mode = MBProgressHUDModeIndeterminate;
    self.label.text = text;
}

- (void)showToastHudWithText:(NSString * _Nullable)text
                  detailText:(NSString * _Nullable)detail {
    [self resetHud];
    self.mode = MBProgressHUDModeText;
    self.label.text = text;
    self.detailsLabel.text = detail;
    [self hideAnimated:YES afterDelay:kDefaultDelayTimeInterval];
}

- (void)showImageHud:(UIImage *)image text:(NSString *)text {
    [self resetHud];
    self.mode = MBProgressHUDModeCustomView;
    self.label.text = text;
    self.customView = [[UIImageView alloc] initWithImage:image];
    self.square = YES;
    [self hideAnimated:YES afterDelay:kDefaultDelayTimeInterval];
}

- (void)showProgress:(float)progess text:(NSString * _Nullable)text {
    [self resetHud];
    self.mode = MBProgressHUDModeDeterminate;
    self.label.text = text;
    self.progress = progess;
    [self hideAnimated:YES afterDelay:kDefaultDelayTimeInterval];
}

- (void)showProgress:(float)progess {
    self.mode = MBProgressHUDModeDeterminate;
    self.progress = progess;
    [self hideAnimated:YES afterDelay:kDefaultDelayTimeInterval];
}

@end

@interface YCTHud ()
@property (nonatomic, strong) MBProgressHUD *progressView;
@end

@implementation YCTHud

+ (instancetype)sharedInstance {
    static YCTHud *hudView = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        hudView = [[self alloc] init];
    });
    
    if (hudView.progressView.superview) {
        [hudView.progressView.superview bringSubviewToFront:hudView.progressView];
    }
    
    return hudView;
}

- (instancetype)init {
    if (self = [super init]) {
        _progressView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] delegate].window animated:NO];
        _progressView.removeFromSuperViewOnHide = NO;
    }
    return self;
}

- (void)showLoadingHud {
    [_progressView showAnimated:YES];
    [_progressView showLoadingHud:nil];
}
- (void)showLoadingHud:(NSString *)text {
    [_progressView showAnimated:YES];
    [_progressView showLoadingHud:text];
}

- (void)showSuccessHud:(NSString * _Nullable)text {
    [_progressView showAnimated:YES];
    [_progressView showImageHud:[[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] text:text];
}

- (void)showFailedHud:(NSString * _Nullable)text {
    [_progressView showAnimated:YES];
    [_progressView showImageHud:[[UIImage imageNamed:@"fork"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] text:text];
}

- (void)showToastHud:(NSString * _Nullable)text {
    [_progressView showAnimated:YES];
    [_progressView showToastHudWithText:text detailText:nil];
}

- (void)showDetailToastHud:(NSString * _Nullable)text {
    [_progressView showAnimated:YES];
    [_progressView showToastHudWithText:nil detailText:text];
}

- (void)showProgress:(float)progess text:(NSString * _Nullable)text {
    [_progressView showAnimated:YES];
    [_progressView showProgress:progess text:text];
}

- (void)showProgress:(float)progess {
    [_progressView showAnimated:YES];
    [_progressView showProgress:progess];
}

- (void)hideHud {
    [_progressView hideAnimated:YES];
}

- (void)hideHudAfterDelay:(NSTimeInterval)delay completion:(void (^ _Nullable)(void))completion {
    [_progressView hideAnimated:YES afterDelay:delay];
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

@end

@implementation UIView (YCTHud)

- (void)showLoadingHud {
    [[self hud] showLoadingHud:nil];
}

- (void)showSuccessHud:(NSString * _Nullable)text {
    [[self hud] showImageHud:[[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] text:text];
}

- (void)showFailedHud:(NSString * _Nullable)text {
    [[self hud] showImageHud:[[UIImage imageNamed:@"fork"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] text:text];
}

- (void)showToastHud:(NSString * _Nullable)text {
    [[self hud] showToastHudWithText:text detailText:nil];
}

- (void)showDetailToastHud:(NSString * _Nullable)text {
    [[self hud] showToastHudWithText:nil detailText:text];
}

- (void)showProgress:(float)progess text:(NSString * _Nullable)text {
    [[self hud] showProgress:progess text:text];
}

- (void)showProgress:(float)progess {
    [[self hud] showProgress:progess];
}

- (void)hideHud {
    [[self hud] hideAnimated:YES];
}

- (void)hideHudAfterDelay:(NSTimeInterval)delay completion:(void (^ _Nullable)(void))completion {
    [[self hud] hideAnimated:YES afterDelay:delay];
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

- (MBProgressHUD *)hud {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
    return hud;
}

@end


