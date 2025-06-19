//
//  YCTApiFileDownload.h
//  YCT
//
//  Created by hua-cloud on 2022/1/9.
//

#import <Foundation/Foundation.h>
typedef void(^downloadProgressHandler) (CGFloat downloadProgress);
typedef void(^downloadCompletionHandler) (NSError * _Nullable error,NSURL * _Nullable resultUrl);
NS_ASSUME_NONNULL_BEGIN

@interface YCTApiFileDownloader : NSObject

+ (id)startDownloadWithFileUrl:(NSURL *)url
       downloadProgressHandler:(downloadProgressHandler)progresHandler
     downloadCompletionHandler:(downloadCompletionHandler)completionHandler;

//暂停下载  可以恢复
- (void)suspend;
 
//cancel:取消是不能恢复
//cancelByProducingResumeData:是可以恢复
- (void)cancel;

//恢复下载
- (void)resum;

@end

NS_ASSUME_NONNULL_END
