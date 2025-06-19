//
//  YCTApiUpload.m
//  YCT
//
//  Created by hua-cloud on 2021/12/26.
//

#import "YCTApiUpload.h"
#import <QCloudCore/QCloudCore.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import "YCTApiGetUploadToken.h"
@implementation YCTCOSUploaderTaskConfig

@end

@implementation YCTCOSUploaderResult

@end

@interface YCTApiUpload ()<QCloudSignatureProvider>
@property (nonatomic, strong) YCTCOSUploaderTaskConfig * config;
@property (nonatomic, copy) NSDictionary * token;
@end

@implementation YCTApiUpload

- (instancetype)initWithConfig:(YCTCOSUploaderTaskConfig *)config
{
    self = [super init];
    if (self) {
        self.config = config;
    }
    return self;
}


- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        YCTCOSUploaderTaskConfig * config = [YCTCOSUploaderTaskConfig new];
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[date timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
        NSData *data = UIImageJPEGRepresentation(image, 0.9);
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[NSUUID UUID].UUIDString,timeString]];
        [data writeToFile:path atomically:YES];
        config.type = @"png";
        config.filePath = path;
        self.config = config;
    }
    return self;
}

- (void)doStartWithSuccess:(void(^)(YCTCOSUploaderResult * _Nullable result))success failure:(void(^)(NSString * errorString))failure
{
    YCTApiGetUploadToken * api = [[YCTApiGetUploadToken alloc] init];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.token = request.responseJSONObject[@"data"];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
            [self configCOS];
            NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[date timeIntervalSince1970] * 1000;
            NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
            NSString *name = [NSString stringWithFormat:@"%@%@.%@",timeString,[self getRandomString],self.config.type];
            QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
            put.object = [NSString stringWithFormat:@"/%@%@", [self.token objectForKey:@"path"],name];
            put.bucket = [self.token objectForKey:@"Bucket"];
            put.body =  [NSURL fileURLWithPath:self.config.filePath?:@""];
            [put setFinishBlock:^(QCloudUploadObjectResult* result, NSError* error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"QCloudCOSTransferMangerService result = %@, error = %@", result.location, error);
                    if (result) {
                        if (success) {
                            YCTCOSUploaderResult *ret = [[YCTCOSUploaderResult alloc] init];
                            ret.url = result.location;
                            ret.cosKey = result.key;
                            success(ret);
                        }
                    } else {
                        failure(YCTLocalizedString(@"request.error"));
                    }
                });
            }];
            [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
        });
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(YCTLocalizedString(@"request.error"));
    }];
}

- (NSString *)getRandomString
{
    //声明并赋值字符串长度变量
    static NSInteger kNumber = 32;
    //随机字符串产生的范围（可自定义）
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //可变字符串
    NSMutableString *resultString = [NSMutableString string];
    //使用for循环拼接字符串
    for (NSInteger i = 0; i < kNumber; i++) {
        //36是sourceString的长度，也可以写成sourceString.length
        [resultString appendString:[sourceString substringWithRange:NSMakeRange(arc4random() % 36, 1)]];
    }
    return resultString;
}
#pragma mark -
- (void) configCOS
{

    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = [self.token objectForKey:@"Region"];
    configuration.endpoint = endpoint;
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
}

//第二步：实现QCloudSignatureProvider协议
- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSMutableURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    NSString *sessionToken = [self.token objectForKey:@"SecurityToken"];
    NSString *tmpSecretId = [self.token objectForKey:@"TmpSecretId"];
    NSString *tmpSecretKey = [self.token objectForKey:@"TmpSecretKey"];
    
    NSUInteger startTime = [[self.token objectForKey:@"StartTime"] integerValue];
    NSUInteger expiredTime = [[self.token objectForKey:@"ExpiredTime"] integerValue];
    
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID = tmpSecretId;
    credential.secretKey = tmpSecretKey;
    credential.token = sessionToken;
    credential.startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    credential.expirationDate = [NSDate dateWithTimeIntervalSince1970:expiredTime];
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}

@end
