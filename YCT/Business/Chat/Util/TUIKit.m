#import "TUIKit.h"
#import "TUILogin.h"
#import "TUICore.h"

@implementation TUIKit
{
    UInt32    _sdkAppid;
    NSString  *_userID;
    NSString  *_userSig;
    NSString  *_nickName;
    NSString  *_faceUrl;
}

+ (instancetype)sharedInstance
{
    static TUIKit *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TUIKit alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _config = [TUIConfig defaultConfig];
    }
    return self;
}

- (void)setupWithAppId:(UInt32)sdkAppId
{
    _sdkAppid = sdkAppId;
    [TUILogin initWithSdkAppID:sdkAppId];
}

- (void)login:(NSString *)userID userSig:(NSString *)sig succ:(TSucc)succ fail:(TFail)fail
{
    _userID = userID;
    _userSig = sig;
    
    [TUILogin login:_userID userSig:_userSig succ:^{
        succ();
    } fail:^(int code, NSString *msg) {
        fail(code,msg);
    }];
}

- (void)logout:(TSucc)succ fail:(TFail)fail {
    // 退出
    [[V2TIMManager sharedInstance] logout:^{
        
        succ();
        
        NSLog(@"登出成功！");
    } fail:fail];
}

- (void)onReceiveGroupCallAPNs:(V2TIMSignalingInfo *)signalingInfo {
    NSDictionary *param = @{
        TUICore_TUICallingService_ShowCallingViewMethod_SignalingInfo : signalingInfo,
    };
    [TUICore callService:TUICore_TUICallingService
                  method:TUICore_TUICallingService_ReceivePushCallingMethod
                   param:param];
}

- (UInt32)sdkAppId {
    return _sdkAppid;
}

- (NSString *)userID {
    return _userID;
}

- (NSString *)userSig {
    return _userSig;
}

- (NSString *)faceUrl {
    return [TUILogin getFaceUrl];
}

- (NSString *)nickName {
    return [TUILogin getNickName];
}
@end
