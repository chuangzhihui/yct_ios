//
//  LBXScanBaseViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import <UIKit/UIKit.h>
#import "YCTBaseViewController.h"

#import "LBXScanTypes.h"
#import "LBXScanView.h"

@interface LBXScanBaseViewController : YCTBaseViewController

@property (copy, nonatomic) void(^scanResultBlock)(NSString *result);

/// 相机预览
@property (nonatomic, strong) UIView *cameraPreView;

/// 界面效果参数
@property (nonatomic, strong) LBXScanViewStyle *style;

/// 扫码区域视图,二维码一般都是框
@property (nonatomic, strong) LBXScanView *qRScanView;

/// 首次加载
@property (nonatomic, assign) BOOL firstLoad;

/// 条码识别位置标示
@property (nonatomic, strong) NSArray<CALayer*> *layers;


/// 扫码存储的当前图片
@property (nonatomic,strong) UIImage *scanImage;


/// 闪关灯开启状态记录
@property(nonatomic, assign) BOOL isOpenFlash;



/// 继承者实现
- (void)reStartDevice;
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array;


- (void)resetCodeFlagView;

/// /截取UIImage指定区域图片
- (UIImage *)imageByCroppingWithSrcImage:(UIImage*)srcImg cropRect:(CGRect)cropRect;

- (void)requestCameraPemissionWithResult:(void(^)( BOOL granted))completion;
+ (void)authorizePhotoPermissionWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

@end


