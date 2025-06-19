//
//  TCUtil.m
//  TCLVBIMDemo
//
//  Created by felixlin on 16/8/2.
//  Copyright © 2016年 tencent. All rights reserved.
//
/** 腾讯云IM Demo数据处理单元
 *
 *  本类为Demo客户端提供数据处理服务，以便客户端更好的工作
 *
 */
#define ENABLE_SHARE 1

#define kHttpTimeout                         30

//错误码
#define kError_InvalidParam                            -10001
#define kError_ConvertJsonFailed                       -10002
#define kError_HttpError                               -10003

//IMSDK群组相关错误码
#define kError_GroupNotExist                            10010  //该群已解散
#define kError_HasBeenGroupMember                       10013  //已经是群成员

//错误信息
#define  kErrorMsgNetDisconnected  @"网络异常，请检查网络"

#import "TCUtil.h"
#import "NSString+TUIUtil.h"
#import <mach/mach.h>
#import <Accelerate/Accelerate.h>
#import <mach/mach.h>
#import <sys/types.h>
#import <sys/sysctl.h>
//#import "TCLoginParam.h"
//#import "TCConstants.h"
#import <CommonCrypto/CommonDigest.h>
#import "TUIKit.h"

static const NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation TCUtil

#define CHECK_STRING_NULL(x) (x == nil) ? @"" : x

+ (NSData *)dictionary2JsonData:(NSDictionary *)dict
{
    // 转成Json数据
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        if(error)
        {
            NSLog(@"[%@] Post Json Error", [self class]);
        }
        return data;
    }
    else
    {
        NSLog(@"[%@] Post Json is not valid", [self class]);
    }
    return nil;
}

+ (NSString *)dictionary2JsonStr:(NSDictionary *)dict {
    return [[NSString alloc] initWithData:[self dictionary2JsonData:dict] encoding:NSUTF8StringEncoding];;
}

+ (NSDictionary *)jsonSring2Dictionary:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err || ![dic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Json parse failed: %@", jsonString);
        return nil;
    }
    return dic;
}

+ (NSDictionary *)jsonData2Dictionary:(NSData *)jsonData
{
    if (jsonData == nil) {
        return nil;
    }
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err || ![dic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Json parse failed");
        return nil;
    }
    return dic;
}

+ (NSString *)getFileCachePath:(NSString *)fileName
{
    if (nil == fileName)
    {
        return nil;
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];

    NSString *fileFullPath = [cacheDirectory stringByAppendingPathComponent:fileName];
    return fileFullPath;
}


//通过分别计算中文和其他字符来计算长度
+ (NSUInteger)getContentLength:(NSString*)content
{
    size_t length = 0;
    for (int i = 0; i < [content length]; i++)
    {
        unichar ch = [content characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff)
        {
            length += 2;
        }
        else
        {
            length++;
        }
    }

    return length;
}
+ (NSString *)md5Hash:(NSData *)data {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (CC_LONG)[data length], result);

    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14],
            result[15]
            ];
}

+ (NSString *)transImageURL2HttpsURL:(NSString *)httpURL
{
    if (httpURL.length == 0) {
        return nil;
    }
    if ([NSURL URLWithString:httpURL] == nil) {
        return nil;
    }
    NSString * httpsURL = httpURL;
    if ([httpURL hasPrefix:@"http:"]) {
        httpsURL = [httpURL stringByReplacingOccurrencesOfString:@"http:" withString:@"https:"];
    }else{
        httpsURL = [NSString stringWithFormat:@"https:%@",httpURL];
    }
    return httpsURL;
}

+(NSString *) randomStringWithLength: (int) len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity:
                                     len];
    for (int i=0; i<len; i++) {
         [randomString appendFormat: @"%C",
          [letters characterAtIndex:
           arc4random_uniform((uint32_t)[letters length])]];
    }
    return randomString;
}

@end
