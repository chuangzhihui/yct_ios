//
//  LBXScanBaseViewController.m
//  YCT
//
//  Created by 木木木 on 2021/12/30.
//

#import "LBXScanBaseViewController.h"
#import <Photos/Photos.h>

@interface LBXScanBaseViewController ()

@end

@implementation LBXScanBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = UIColor.mainTextColor;
    
    self.firstLoad = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.firstLoad = NO;
}

#pragma mark - 识别结果

- (void)scanResultWithArray:(NSArray<LBXScanResult *> *)array {
    if (!array || array.count < 1) {
        [self reStartDevice];
        return;
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString *strResult = scanResult.strScanned;
    
    if (!strResult) {
        [self reStartDevice];
        return;
    }
    
    [self.qRScanView stopScanAnimation];
    
    self.scanImage = scanResult.imgScanned;
    
    /// TODO:表示二维码位置
    if (self.cameraPreView && !CGRectEqualToRect(CGRectZero, scanResult.bounds) ) {
        /// 条码位置边缘绘制及内部填充
        [self didDetectCodes:scanResult.bounds corner:scanResult.corners];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
                 [self showNextVCWithScanResult:scanResult];
//            });
        });
    } else {
        [self showNextVCWithScanResult:scanResult];
    }
}

- (UIImage *)getImageFromLayer:(CALayer *)layer size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, [[UIScreen mainScreen]scale]);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (CGPoint)pointForCorner:(NSDictionary *)corner {
    CGPoint point;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corner, &point);
    return point;
}
  
- (void)reStartDevice {
    
}

- (void)resetCodeFlagView {
    if (self.layers) {
        for (CALayer *layer in self.layers) {
            [layer removeFromSuperlayer];
        }
        self.layers = nil;
    }
}

- (UIImage *)imageByCroppingWithSrcImage:(UIImage*)srcImg cropRect:(CGRect)cropRect {
    CGImageRef imageRef = srcImg.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, cropRect);
    UIImage *cropImage = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return cropImage;
}

- (void)showNextVCWithScanResult:(LBXScanResult *)strResult {
    [self resetCodeFlagView];
    if (self.scanResultBlock) {
        self.scanResultBlock(strResult.strScanned);
    }
}

#pragma mark - 绘制二维码区域标志

- (void)didDetectCodes:(CGRect)bounds corner:(NSArray<NSDictionary *> *)corners {
    AVCaptureVideoPreviewLayer *preview = nil;
    
    for (CALayer *layer in [self.cameraPreView.layer sublayers]) {
        if ([layer isKindOfClass:[AVCaptureVideoPreviewLayer class]]) {
            preview = (AVCaptureVideoPreviewLayer*)layer;
        }
    }
    
    NSArray *layers = nil;
    if (!layers) {
        layers = @[[self makeBoundsLayer],[self makeCornersLayer]];
        [preview addSublayer:layers[0]];
        [preview addSublayer:layers[1]];
    }
    
    CAShapeLayer *boundsLayer = layers[0];
    boundsLayer.path = [self bezierPathForBounds:bounds].CGPath;
    
    if (corners) {
        CAShapeLayer *cornersLayer = layers[1];
        cornersLayer.path = [self bezierPathForCorners:corners].CGPath;
    }
    
    self.layers = layers;
}

- (UIBezierPath *)bezierPathForBounds:(CGRect)bounds {
    return [UIBezierPath bezierPathWithRect:bounds];
}

- (CAShapeLayer *)makeBoundsLayer {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor colorWithRed:0.96f green:0.75f blue:0.06f alpha:1.0f].CGColor;
    shapeLayer.fillColor = nil;
    shapeLayer.lineWidth = 4.0f;
    
    return shapeLayer;
}

- (CAShapeLayer *)makeCornersLayer {
    CAShapeLayer *cornersLayer = [CAShapeLayer layer];
    cornersLayer.lineWidth = 2.0f;
    cornersLayer.strokeColor = [UIColor colorWithRed:0.172 green:0.671 blue:0.428 alpha:1.0].CGColor;
    cornersLayer.fillColor = [UIColor colorWithRed:0.190 green:0.753 blue:0.489 alpha:0.5].CGColor;
    
    return cornersLayer;;
}

- (UIBezierPath *)bezierPathForCorners:(NSArray *)corners {
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < corners.count; i ++) {
        CGPoint point = [self pointForCorner:corners[i]];
        if (i == 0) {
            [path moveToPoint:point];
        } else {
            [path addLineToPoint:point];
        }
    }
    [path closePath];
    return path;
}

#pragma mark - 权限

- (void)requestCameraPemissionWithResult:(void(^)(BOOL granted))completion {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO);
                break;
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (granted) {
                            completion(true);
                        } else {
                            completion(false);
                        }
                    });
                }];
            }
                break;
        }
    }
}

+ (void)authorizePhotoPermissionWithCompletion:(void(^)(BOOL granted, BOOL firstTime))completion {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusAuthorized: {
            if (completion) {
                completion(YES,NO);
            }
        }
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied: {
            if (completion) {
                completion(NO,NO);
            }
        }
            break;
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(status == PHAuthorizationStatusAuthorized,YES);
                    });
                }
            }];
        }
            break;
        default: {
            if (completion) {
                completion(NO,NO);
            }
        }
            break;
    }
}

@end
