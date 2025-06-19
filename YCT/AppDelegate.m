//
//  AppDelegate.m
//  YCT
//
//  Created by 木木木 on 2021/12/8.
//

#import "AppDelegate.h"
#import "YCTRootViewController.h"
#import "YCTAppAppearanceConfig.h"
#import "YCTGuideViewController.h"
#import <MMKV.h>
#import "YCTBaseRequestAgent.h"
#import "YCTRequestConfig.h"
#import "TUILogin.h"
#import "YCTLocationManager.h"
#import "SJRotationManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "YCT-Bridging-Header.h"
#import "YCT-Swift.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "YCTApiUploadRegId.h"
#import "YCTApiCheckVersion.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YCTApiCheckVersionModel.h"
#import "LineSDK/LineSDK-Swift.h"
#import "BecomeCompanySuccessPromptView.h"
@import LineSDK;
@import GoogleSignIn;
@import TXLiteAVSDK_UGC;
@import FirebaseCore;

@interface AppDelegate ()<TXUGCBaseDelegate,JPUSHRegisterDelegate>
@property (nonatomic, strong) YCTRootViewController *rootVc;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    GIDSignIn.sharedInstance.configuration = [[GIDConfiguration alloc] initWithClientID:@"626193180281-s2a4s57c8h08onuvhe8kng8rb37csgbi.apps.googleusercontent.com"];
    [[LiveStreamManager shared] initLivestream];
//    [NSThread sleepForTimeInterval:1.5];
    [TUILogin initWithSdkAppID:kTUChatAppID];
    [self registerOpenPlatform];
//    dispatch_async(dispatch_get_main_queue(), ^{
        [MMKV initializeMMKV:nil];
//    });
    [YCTAppAppearanceConfig config];
    [self initNet];
    [YCTGuideViewController checkNeedShow] ? [self initGuide] : [self initRootVC];
    [self initUGC];
    [[YCTLocationManager sharedInstance] checkPrivacyAgree];
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[FBSDKSettings sharedSettings] setAppID:@"1507656199650057"];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"108ee1d824a0fb889a6eaedb" channel:@"product" apsForProduction:YES ];
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
      entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    
    [FIRApp configure];
    [application setIdleTimerDisabled: TRUE];
    
    [self checkVersion];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeCompanyPayNotification) name:@"BecomeCompanyPaySuccess" object:nil];
    return YES;
}
- (void)didBecomeCompanyPayNotification {
    NSLog(@"准备弹出弹窗");
    BecomeCompanySuccessPromptView *view = [[BecomeCompanySuccessPromptView alloc]init];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:view];
    [view show];
}

-(void)checkVersion{
    int version=1;//版本标识号  如果这个值小于返回的version 弹窗提示更新
    YCTApiCheckVersion * api=[[YCTApiCheckVersion alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YCTBaseRequest * _Nonnull request) {
        YCTApiCheckVersionModel * model=request.responseDataModel;
        if(model.version>version)
        {
            //如果返回的version值大于定义的 则需要更新
            [self showAlert:model.url_ios];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
//    [[YCTHud sharedInstance] show]
    
}
//弹窗
-(void)showAlert:(NSString *)url{
    //1.创建UIAlertControler
       UIAlertController *alert = [UIAlertController alertControllerWithTitle:YCTLocalizedTableString(@"mine.version.title", @"Mine") message:YCTLocalizedTableString(@"mine.version.content", @"Mine") preferredStyle:UIAlertControllerStyleAlert];
           /*
            参数说明：
            Title:弹框的标题
            message:弹框的消息内容
            preferredStyle:弹框样式：UIAlertControllerStyleAlert
            */
           
           //2.添加按钮动作
           //2.1 确认按钮
           UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               //使用下面接口可以打开当前应用的设置页面
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                   
               }];
               NSLog(@"点击了确认按钮");
           }];
           
           //3.将动作按钮 添加到控制器中
           [alert addAction:conform];
           
           //4.显示弹框
           [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
//************************************************JPush start************************************************

//注册 APNS 成功并上报 DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"极光上报token：%@",JPUSHService.registrationID);
    YCTApiUploadRegId * api=[[YCTApiUploadRegId alloc] init];
    api.reg_id=JPUSHService.registrationID;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
  [JPUSHService registerDeviceToken:deviceToken];
}

//iOS 7 APNS
- (void)application:(UIApplication *)application didReceiveRemoteNotification:  (NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  // iOS 10 以下 Required
  NSLog(@"iOS 7 APNS");
  [JPUSHService handleRemoteNotification:userInfo];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"直达工厂111" object:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}

//iOS 10 前台收到消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center  willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    // Apns
    NSLog(@"iOS 10 APNS 前台收到消息");
    [JPUSHService handleRemoteNotification:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"直达工厂111" object:userInfo];
  }
  else {
    // 本地通知 todo
    NSLog(@"iOS 10 本地通知 前台收到消息");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"直达工厂111" object:userInfo];
  }
  //需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
  completionHandler(UNNotificationPresentationOptionAlert);
}

//iOS 10 消息事件回调
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler: (void (^)(void))completionHandler {
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    // Apns
    NSLog(@"iOS 10 APNS 消息事件回调");
    [JPUSHService handleRemoteNotification:userInfo];
    // 保障应用被杀死状态下，用户点击推送消息，打开app后可以收到点击通知事件
//    [[RCTJPushEventQueue sharedInstance]._notificationQueue insertObject:userInfo atIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"直达工厂111" object:userInfo];
  }
  else {
    // 本地通知
    NSLog(@"iOS 10 本地通知 消息事件回调");
    // 保障应用被杀死状态下，用户点击推送消息，打开app后可以收到点击通知事件
//    [[RCTJPushEventQueue sharedInstance]._localNotificationQueue insertObject:userInfo atIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"直达工厂111" object:userInfo];
  }
  // 系统要求执行这个方法
  completionHandler();
}

//自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
  NSDictionary * userInfo = [notification userInfo];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"直达工厂111" object:userInfo];
}

//************************************************JPush end************************************************


- (void)initNet {
    [[YCTBaseRequestAgent sharedAgent] setBaseUrl:BaseUrl];
    [[YCTBaseRequestAgent sharedAgent] setConfig:[YCTRequestConfig new]];
}

- (void)initUGC {
    NSString * const licenceURL = @"https://license.vod2.myqcloud.com/license/v2/1308832855_1/v_cube.license";
    NSString * const licenceKey = @"fcabe1e1e95f9033b78f2be3d26dd9c4";
    [TXUGCBase setLicenceURL:licenceURL key:licenceKey];
    [TXUGCBase sharedInstance].delegate = self;
}

- (void)registerOpenPlatform {
    [[YCTOpenPlatformManager defaultManager] setPlaform:(YCTOpenPlatformTypeWeChatSession) appKey:kWxAppID appSecret:nil universalLink:kUniversalLink];
    [[YCTOpenPlatformManager defaultManager] setPlaform:(YCTOpenPlatformTypeZalo) appKey:kZaloAppID appSecret:nil universalLink:nil];
}

- (void)onLicenceLoaded:(int)result Reason:(NSString *)reason{
    
}

- (void)initGuide{
    YCTGuideViewController * rootVC = [YCTGuideViewController new];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
}

- (void)initRootVC{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[YCTRootViewController alloc] init];
    [self.window makeKeyAndVisible];
}

- (void)switchToNewRootVC {
    YCTRootViewController *newRootVC = [[YCTRootViewController alloc] init];
    self.window.rootViewController = newRootVC;
    
    [UIView transitionWithView:self.window duration:0.3 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    
    
    
    BOOL result = [[YCTOpenPlatformManager defaultManager] handleOpenUniversalLink:userActivity];
    
    return result;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
//    BOOL result = [[YCTOpenPlatformManager defaultManager] handleApplication:app openURL:url options:options];
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"resu11lt = %@",resultDic);
            NSString *status=[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
              NSLog(@"status:%@",[resultDic objectForKey:@"resultStatus"]);
            if ([status isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"alipaySuccess" object:nil userInfo:nil];
            }else{
                [[YCTHud sharedInstance] showFailedHud:@"pay fail"];
                
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"resul22t = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        return YES;
    }else{
        BOOL handled;
        
        handled = [GIDSignIn.sharedInstance handleURL:url];
        if (handled) {
            return YES;
        }
        
        // Handle LINE Login URL
        if ([[LineSDKLoginManager sharedManager] application:app open:url options:options]) {
            return YES;
        }
        
        BOOL result = [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        return result;
    }
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return [SJRotationManager supportedInterfaceOrientationsForWindow:window];
}

@end
