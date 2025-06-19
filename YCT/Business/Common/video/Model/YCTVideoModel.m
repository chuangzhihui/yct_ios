//
//  YCTHomeVideoModel.m
//  YCT
//
//  Created by hua-cloud on 2021/12/28.
//

#import "YCTVideoModel.h"

@implementation YCTVideoModel

@end

@implementation YCTVideoDataModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
        @"datas" : [YCTVideoModel class],
    };
}

@end
