//
//  YCTOpenMessageHelper.m
//  YCT
//
//  Created by 木木木 on 2022/1/14.
//

#import "YCTOpenMessageHelper.h"
#import "YCTOpenMessageZaloSender.h"
#import "YCTOpenMessageWeChatSender.h"
#import "YCTOpenMessageFaceBookSender.h"
#import "UIImage+Resizing.h"

@interface YCTOpenMessageHelper ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, id<YCTOpenMessageSend>> *senderDic;
@end

@implementation YCTOpenMessageHelper

+ (instancetype)sharedInstance {
    static YCTOpenMessageHelper *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         _sharedInstance = [YCTOpenMessageHelper new];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        YCTOpenMessageZaloSender *zaloSender = [[YCTOpenMessageZaloSender alloc] init];
        YCTOpenMessageWeChatSender *weChatSender = [[YCTOpenMessageWeChatSender alloc] init];
        YCTOpenMessageFaceBookSender *faceBookSender = [[YCTOpenMessageFaceBookSender alloc] init];
        self.senderDic = @{}.mutableCopy;
        [self.senderDic setObject:weChatSender forKey:@(YCTOpenPlatformTypeWeChatSession)];
        [self.senderDic setObject:weChatSender forKey:@(YCTOpenPlatformTypeWeChatTimeLine)];
        [self.senderDic setObject:zaloSender forKey:@(YCTOpenPlatformTypeZalo)];
        [self.senderDic setObject:faceBookSender forKey:@(YCTOpenPlatformTypeFaceBook)];
    }
    return self;
}

- (void)sendMessage:(YCTOpenMessageObject *)message
         toPlatform:(YCTOpenPlatformType)platformType
   inViewController:(UIViewController *)viewController
         completion:(YCTOpenPlatformShareCompletionHandler)completion {
    if (message.shareObject && !message.shareObject.title) {
        message.shareObject.title = YCTLocalizedTableString(@"CFBundleDisplayName", @"InfoPlist");
    }
    
    if ([message.shareObject.thumbImage isKindOfClass:NSString.class]) {
        [[YCTHud sharedInstance] showLoadingHud];
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:message.shareObject.thumbImage] options:0 progress:NULL completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [[YCTHud sharedInstance] hideHud];
            if (image) {
                image = [image scaleToSize:(CGSize){100, 100} usingMode:(NYXResizeModeAspectFill)];
            }
            message.shareObject.thumbImage = image;
            id<YCTOpenMessageSend> sender = self.senderDic[@(platformType)];
            [sender sendMessage:message toPlatform:platformType inViewController:viewController completion:completion];
        }];
    } else {
        id<YCTOpenMessageSend> sender = self.senderDic[@(platformType)];
        [sender sendMessage:message toPlatform:platformType inViewController:viewController completion:completion];
    }
}

@end
