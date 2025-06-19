//
//  YCTApiReport.m
//  YCT
//
//  Created by hua-cloud on 2022/1/22.
//

#import "YCTApiReport.h"

@implementation YCTApiReport{
    YCTReportType _type;
    NSString * _typeIds;
    NSString * _title;
    NSString * _imgs;
    NSString * _told;
}

- (instancetype)initWithType:(YCTReportType)type
                     typeIds:(NSString *)typeIds
                       title:(NSString *)title
                        imgs:(NSString *)imgs
                        told:(NSString *)told{
    if (self = [super init]){
        _type = type;
        _typeIds = typeIds;
        _title = title;
        _imgs = imgs;
        _told = told;
    }
    return self;
}

- (NSString *)requestUrl{
    return @"/index/report/report";
}


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSDictionary *)yct_requestArgument {
    return @{
        @"type": @(_type),
        @"typeIds": _typeIds,
        @"title": _title,
        @"imgs": _imgs,
        @"toId": _told
    };
}

@end
