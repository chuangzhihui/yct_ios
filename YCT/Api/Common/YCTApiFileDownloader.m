//
//  YCTApiFileDownload.m
//  YCT
//
//  Created by hua-cloud on 2022/1/9.
//

#import "YCTApiFileDownloader.h"

@interface YCTApiFileDownloader ()<NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumData;
@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, copy) NSURL * resultFileUrl;
@property (nonatomic, copy) NSURL * downloadUrl;

@property (nonatomic, copy) downloadProgressHandler progressHandler;
@property (nonatomic, copy) downloadCompletionHandler completionHandler;
@end
 
@implementation YCTApiFileDownloader

+ (id)startDownloadWithFileUrl:(NSURL *)url
       downloadProgressHandler:(downloadProgressHandler)progresHandler
     downloadCompletionHandler:(downloadCompletionHandler)completionHandler{
    YCTApiFileDownloader * instance = [[YCTApiFileDownloader alloc] init];
    instance.downloadUrl = url;
    [instance startDownload];
    [instance setProgressHandler:progresHandler];
    [instance setCompletionHandler:completionHandler];
    return instance;
}

//开始下载
-(void)startDownload{
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:self.downloadUrl];
    //3.创建session
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.session = session;
    //4.创建Task
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
    self.downloadTask = downloadTask;
    //5.执行Task
    [downloadTask resume];
}
 
//暂停下载  可以恢复
- (void)suspend{
    NSLog(@"+++++++++++++++++++暂停");
    [self.downloadTask suspend];
}
 
//cancel:取消是不能恢复
//cancelByProducingResumeData:是可以恢复
- (void)cancel{
    //恢复下载的数据!=文件数据
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumData = resumeData;
    }];
}

//恢复下载
- (void)resum{
    NSLog(@"+++++++++++++++++++恢复下载");
    if(self.resumData){
        self.downloadTask = [self.session downloadTaskWithResumeData:self.resumData];
    }
    [self.downloadTask resume];
}

#pragma mark NSURLSessionDownloadDelegate
/**
 *  写数据
 *
 *  @param session                   会话对象
 *  @param downloadTask              下载任务
 *  @param bytesWritten              本次写入的数据大小
 *  @param totalBytesWritten         下载的数据总大小
 *  @param totalBytesExpectedToWrite  文件的总大小
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    !self.progressHandler ? : self.progressHandler(1.0 * totalBytesWritten/totalBytesExpectedToWrite);
}
 
/**
 *  当恢复下载的时候调用该方法
 *
 *  @param fileOffset         从什么地方下载
 *  @param expectedTotalBytes 文件的总大小
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    NSLog(@"%s",__func__);
}
 
/**
 *  当下载完成的时候调用
 *
 *  @param location     文件的临时存储路径
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    self.resultFileUrl = location.copy;
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",downloadTask.response.suggestedFilename]];
    NSError * error;
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:&error];
    if (!error) {
        self.resultFileUrl = [NSURL fileURLWithPath:path];
    }
}
 
/**
 *  请求结束
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    !self.completionHandler ? : self.completionHandler(error, self.resultFileUrl);
}
@end
