//
//  YCTOpenMessageWeChatSender.m
//  YCT
//
//  Created by 木木木 on 2022/1/22.
//

#import "YCTOpenMessageWeChatSender.h"
#import "WXApi.h"

@implementation YCTOpenMessageWeChatSender

- (void)sendMessage:(YCTOpenMessageObject *)message
         toPlatform:(YCTOpenPlatformType)platformType
   inViewController:(UIViewController *)viewController
         completion:(YCTOpenPlatformShareCompletionHandler)completion {
    if ([message.shareObject isKindOfClass:YCTShareVideoItem.class]) {
        [self sendWeChatMeidoMessage:(YCTShareVideoItem *)(message.shareObject) scene:platformType == YCTOpenPlatformTypeWeChatSession ? 0 : 1];
    }
    else if ([message.shareObject isKindOfClass:YCTShareWebpageItem.class]) {
        [self sendWeChatWebpageMessage:(YCTShareWebpageItem *)message.shareObject scene:platformType == YCTOpenPlatformTypeWeChatSession ? 0 : 1];
    }
}

- (void)sendWeChatWebpageMessage:(YCTShareWebpageItem *)webpage scene:(int)scene {
    WXMediaMessage *message = [self wxMediaMessage:webpage];
    message.mediaObject = ({
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = webpage.webpageUrl;
        webpageObject;
    });
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [self sendWeChatRequest:req];
}

- (WXMediaMessage *)wxMediaMessage:(YCTShareObject *)shareObject {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareObject.title;
    message.description = shareObject.desc;
    if ([shareObject.thumbImage isKindOfClass:UIImage.class]) {
        [message setThumbImage:shareObject.thumbImage];
    } else if ([shareObject.thumbImage isKindOfClass:NSData.class]) {
        message.thumbData = shareObject.thumbImage;
    }
    return message;
}

- (void)sendWeChatMeidoMessage:(YCTShareVideoItem *)video scene:(int)scene {
    WXMediaMessage *message = [self wxMediaMessage:video];
    message.title = video.title;
    message.description = video.desc;
    if ([video.thumbImage isKindOfClass:UIImage.class]) {
        [message setThumbImage:video.thumbImage];
    } else if ([video.thumbImage isKindOfClass:NSData.class]) {
        message.thumbData = video.thumbImage;
    }
    message.mediaObject = ({
        WXVideoObject *videoObject = [WXVideoObject object];
        videoObject.videoUrl = video.videoUrl;
        videoObject;
    });
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [self sendWeChatRequest:req];
}

- (void)sendWeChatRequest:(SendMessageToWXReq *)request {
    [WXApi sendReq:request completion:NULL];
}

@end
