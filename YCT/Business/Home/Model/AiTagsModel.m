//
//  AiTagsModel.m
//  YCT
//
//  Created by 林涛 on 2025/3/25.
//

#import "AiTagsModel.h"

@implementation Children
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
        @"children" : [Children class],
    };
}
@end

@implementation AiTagsModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
        @"children" : [Children class],
    };
}
@end
