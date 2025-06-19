//
//  YCTQRCodeScanViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import "YCTQRCodeScanViewController.h"
#import <ZXResultPoint.h>
#import "UIWindow+Common.h"
#define cameraInvokeMsg YCTLocalizedTableString(@"mine.scan.ready", @"Mine")

@interface YCTQRCodeScanViewController ()
@end

@implementation YCTQRCodeScanViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        LBXScanViewStyle *style = [[LBXScanViewStyle alloc] init];
        
        //扫码框周围4个角的类型,设置为外挂式
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
        
        //扫码框周围4个角绘制的线条宽度
        style.photoframeLineW = 6;
        
        //扫码框周围4个角的宽度
        style.photoframeAngleW = 24;
        
        //扫码框周围4个角的高度
        style.photoframeAngleH = 24;
        
        //扫码框内 动画类型 --线条上下移动
        style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
        
        //线条上下移动图片
        style.animationImage = [UIImage imageNamed:@"qrcode_scan_light_green"];
        
        style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 60;
        
        self.style = style;
    }
    return self;
}
-(void)check{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus==AVAuthorizationStatusDenied || authStatus==AVAuthorizationStatusRestricted){
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:YCTLocalizedTableString(@"mine.scan.tipsCamera", @"Mine") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelaction = [UIAlertAction actionWithTitle:YCTLocalizedString(@"lbs.cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:cancelaction];
        
        UIAlertAction * setaction = [UIAlertAction actionWithTitle:YCTLocalizedString(@"lbs.goset") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addAction:setaction];
        
        [[UIWindow yct_currentViewController] presentViewController:alert animated:YES completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self check];
    
    
    self.title = YCTLocalizedTableString(@"mine.title.scan", @"Mine");
    
    [self drawScanView];
    
    [self requestCameraPemissionWithResult:^(BOOL granted) {
        if (granted) {
            [self startScan];
        } else {
            [self.qRScanView stopDeviceReadying];
        }
    }];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect rect = self.view.frame;
    rect.origin = CGPointMake(0, 0);
    
    self.qRScanView.frame = rect;
    
    self.cameraPreView.frame = self.view.bounds;
    
    if (_zxingObj) {
        [_zxingObj setVideoLayerframe:self.cameraPreView.frame];
    }
    
    [self.qRScanView stopScanAnimation];
    
    [self.qRScanView startScanAnimation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeNavigationBarColor:UIColor.mainTextColor titleColor:UIColor.whiteColor];
    
    if (!self.firstLoad) {
        [self reStartDevice];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self changeNavigationBarColor:UIColor.whiteColor titleColor:UIColor.navigationBarTitleColor];
    [self stopScan];
    [self.qRScanView stopScanAnimation];
}

/// 绘制扫描区域
- (void)drawScanView {
    if (!self.qRScanView) {
        self.qRScanView = [[LBXScanView alloc] initWithFrame:self.view.bounds style:self.style];
        [self.view insertSubview:self.qRScanView atIndex:1];
    }
}

- (void)reStartDevice {
//    [self.qRScanView startDeviceReadyingWithText:cameraInvokeMsg];
    
    if (_zxingObj) {
        [_zxingObj start];
    }
}

- (void)startScan {
    if (!self.cameraPreView) {
        CGRect frame = self.view.bounds;
        
        UIView *videoView = [[UIView alloc] initWithFrame:frame];
        videoView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:videoView atIndex:0];
        
        self.cameraPreView = videoView;
    }
        
    __weak __typeof(self) weakSelf = self;
    if (!_zxingObj) {
        self.zxingObj = [[ZXingWrapper alloc] initWithPreView:self.cameraPreView success:^(ZXBarcodeFormat barcodeFormat, NSString *str, UIImage *scanImg, NSArray *resultPoints) {
            [weakSelf handZXingResult:barcodeFormat barStr:str scanImg:scanImg resultPoints:resultPoints];
        }];
    }
//    [self.qRScanView startDeviceReadyingWithText:cameraInvokeMsg];

#if TARGET_OS_SIMULATOR
    
#else
    [_zxingObj start];
#endif
    
    _zxingObj.onStarted = ^{
        [weakSelf.qRScanView stopDeviceReadying];
        [weakSelf.qRScanView startScanAnimation];
    };

    self.view.backgroundColor = [UIColor clearColor];
}

- (void)handZXingResult:(ZXBarcodeFormat)barcodeFormat barStr:(NSString *)str scanImg:(UIImage *)scanImg resultPoints:(NSArray *)resultPoints {
    LBXScanResult *result = [[LBXScanResult alloc] init];
    result.strScanned = str;
    result.imgScanned = scanImg;
    result.strBarCodeType = [self convertZXBarcodeFormat:barcodeFormat];
    
    if (self.cameraPreView && resultPoints && scanImg) {
        CGFloat minx = 100000;
        CGFloat miny= 100000;
        CGFloat maxx = 0;
        CGFloat maxy= 0;
        
        for (ZXResultPoint *pt in resultPoints) {
            if (pt.x < minx) {
                minx = pt.x;
            }
            if (pt.x > maxx) {
                maxx = pt.x;
            }
            
            if (pt.y < miny) {
                miny = pt.y;
            }
            if (pt.y > maxy) {
                maxy = pt.y;
            }
        }
        
        CGSize imgSize = scanImg.size;
        CGSize preViewSize = self.cameraPreView.frame.size;
        minx = minx / imgSize.width * preViewSize.width;
        maxx = maxx / imgSize.width * preViewSize.width;
        miny = miny / imgSize.height * preViewSize.height;
        maxy = maxy / imgSize.height * preViewSize.height;
        
        result.bounds = CGRectMake(minx, miny, maxx - minx, maxy - miny);
        
        [self scanResultWithArray:@[result]];
    } else {
        [self scanResultWithArray:@[result]];
    }
}

- (void)stopScan {
    [_zxingObj stop];
}

- (void)openOrCloseFlash {
    [_zxingObj openOrCloseTorch];

    self.isOpenFlash =!self.isOpenFlash;
}

- (NSString *)convertZXBarcodeFormat:(ZXBarcodeFormat)barCodeFormat {
    NSString *strAVMetadataObjectType = nil;
    
    switch (barCodeFormat) {
        case kBarcodeFormatQRCode:
            strAVMetadataObjectType = AVMetadataObjectTypeQRCode;
            break;
        case kBarcodeFormatEan13:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN13Code;
            break;
        case kBarcodeFormatEan8:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN8Code;
            break;
        case kBarcodeFormatPDF417:
            strAVMetadataObjectType = AVMetadataObjectTypePDF417Code;
            break;
        case kBarcodeFormatAztec:
            strAVMetadataObjectType = AVMetadataObjectTypeAztecCode;
            break;
        case kBarcodeFormatCode39:
            strAVMetadataObjectType = AVMetadataObjectTypeCode39Code;
            break;
        case kBarcodeFormatCode93:
            strAVMetadataObjectType = AVMetadataObjectTypeCode93Code;
            break;
        case kBarcodeFormatCode128:
            strAVMetadataObjectType = AVMetadataObjectTypeCode128Code;
            break;
        case kBarcodeFormatDataMatrix:
            strAVMetadataObjectType = AVMetadataObjectTypeDataMatrixCode;
            break;
        case kBarcodeFormatITF:
            strAVMetadataObjectType = AVMetadataObjectTypeITF14Code;
            break;
        case kBarcodeFormatRSS14:
            break;
        case kBarcodeFormatRSSExpanded:
            break;
        case kBarcodeFormatUPCA:
            break;
        case kBarcodeFormatUPCE:
            strAVMetadataObjectType = AVMetadataObjectTypeUPCECode;
            break;
        default:
            break;
    }
    
    return strAVMetadataObjectType;
}

#pragma mark - Override

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
