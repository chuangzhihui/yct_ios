//
//  YCTQRCodeScanViewController.h
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LBXScanBaseViewController.h"
#import "ZXingWrapper.h"

@interface YCTQRCodeScanViewController : LBXScanBaseViewController

#pragma mark ---- 需要初始化参数 ------

/// ZXing扫码对象
@property (nonatomic, strong) ZXingWrapper *zxingObj;

/// 开关闪光灯
- (void)openOrCloseFlash;

/// 启动扫描
- (void)reStartDevice;

/// 关闭扫描
- (void)stopScan;

@end
