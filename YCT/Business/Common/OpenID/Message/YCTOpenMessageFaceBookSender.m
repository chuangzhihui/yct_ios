//
//  YCTOpenMessageFaceBookSender.m
//  YCT
//
//  Created by 张大爷的 on 2022/9/14.
//

#import "YCTOpenMessageFaceBookSender.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <FBSDKShareKit/FBSDKShareKit.h>
@interface YCTOpenMessageWeChatSender<FBSDKSharingDelegate>

@end
@implementation YCTOpenMessageFaceBookSender
- (void)sendMessage:(YCTOpenMessageObject *)message
         toPlatform:(YCTOpenPlatformType)platformType
   inViewController:(UIViewController *)viewController
         completion:(YCTOpenPlatformShareCompletionHandler)completion {
    if ([message.shareObject isKindOfClass:YCTShareVideoItem.class]) {
        NSLog(@"YCTShareVideoItem");
       
//        [self sendWeChatMeidoMessage:(YCTShareVideoItem *)(message.shareObject) scene:platformType == YCTOpenPlatformTypeWeChatSession ? 0 : 1];
    }
    else if ([message.shareObject isKindOfClass:YCTShareWebpageItem.class]) {
//        [self sendWeChatWebpageMessage:(YCTShareWebpageItem *)message.shareObject scene:platformType == YCTOpenPlatformTypeWeChatSession ? 0 : 1];
        YCTShareWebpageItem * share=(YCTShareWebpageItem *)message.shareObject;
        FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
        linkContent.contentURL = [NSURL URLWithString:share.webpageUrl];
        linkContent.quote=YCTLocalizedTableString(@"CFBundleDisplayName", @"InfoPlist");
        [FBSDKShareDialog showFromViewController:viewController withContent:linkContent delegate:self];
        NSLog(@"YCTShareWebpageItem");
    }
  
    
//    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//
//       dialog.shareContent = content;
//
//       dialog.fromViewController = self;
//
//       dialog.delegate = self;
//
//       dialog.mode = FBSDKShareDialogModeNative;
//
//       [dialog show];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"--results:%@",results);
    
//    [MBProgressHUD showError:@"分享成功"];
//    [self anchorShareSucess];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"--error");
    
//    [MBProgressHUD showError:@"分享失败"];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    NSLog(@"--cancel");
}
@end
