//
//  YCTLocationManager.m
//  YCT
//
//  Created by 木木木 on 2022/4/6.
//

#import "YCTLocationManager.h"
#import <AMapFoundationKit/AMapServices.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIWindow+Common.h"

NSString * const YCTLocationErrorDomain = @"com.hhkj.yct.error.location";

@interface YCTLocationManager ()<AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation YCTLocationManager

YCT_SINGLETON_IMP

- (instancetype)init {
    self = [super init];
    if (self) {
        [AMapServices sharedServices].apiKey = @"0fb8c2ec60ea0ac6dce0687580b34bd2";
        NSLog(@"🐔%@", [NSBundle mainBundle].bundleIdentifier);
    }
    return self;
}

- (void)checkPrivacyAgree {
    [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
}

- (void)requestLocationWithCompletion:(YCTLocationCompletion)completion {
    if (!([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)) {//
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:YCTLocalizedString(@"lbs.disableToust") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelaction = [UIAlertAction actionWithTitle:YCTLocalizedString(@"lbs.cancel") style:UIAlertActionStyleDefault handler:NULL];
        [alert addAction:cancelaction];
        
        UIAlertAction * setaction = [UIAlertAction actionWithTitle:YCTLocalizedString(@"lbs.goset") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addAction:setaction];
        
        [[UIWindow yct_currentViewController] presentViewController:alert animated:YES completion:nil];
        return;
    }
    [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (regeocode) {
            YCTLocationResultModel *model = [[YCTLocationResultModel alloc] init];
            model.formattedAddress = regeocode.formattedAddress;
            model.POIName = regeocode.POIName;
            model.AOIName = regeocode.AOIName;
            completion(model, nil);
        }
        else if (error) {
            completion(nil, error);
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else {
            NSError *_error = [NSError errorWithDomain:YCTLocationErrorDomain code:111 userInfo:@{NSLocalizedDescriptionKey: YCTLocalizedString(@"alert.location")}];
            completion(nil, _error);
        }
    }];
}

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager {
    [locationManager requestWhenInUseAuthorization];
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        self.locationManager.locationTimeout = 20;
        self.locationManager.reGeocodeTimeout = 20;
        self.locationManager.delegate = self;
    }
    return _locationManager;
}

@end

@implementation YCTLocationResultModel
@end
