//
//  YCTComprehensiveSearchModel.m
//  YCT
//
//  Created by hua-cloud on 2022/1/12.
//

#import "YCTComprehensiveSearchModel.h"

@implementation YCTComprehensiveSearchModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
        @"companyInfo" : [YCTSearchUserModel class],
        @"videos" : [YCTVideoModel class],
        @"hotVideos": [YCTVideoModel class],
        @"tjVideos": [YCTVideoModel class]
    };
}

@end
